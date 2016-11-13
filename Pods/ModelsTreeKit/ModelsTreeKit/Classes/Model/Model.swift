//
//  Model.swift
//  SessionSwift
//
//  Created by aleksey on 10.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

extension Model: DeinitObservable { }

public class Model {
  
  public private(set) weak var parent: Model!
  
  public let pushChildSignal = Pipe<Model>()
  public let wantsRemoveChildSignal = Pipe<Model>()
  public let errorSignal = Pipe<Error>()
  public let pool = AutodisposePool()
  public let deinitSignal = Pipe<Void>()
  
  private let hash = NSProcessInfo.processInfo().globallyUniqueString
  private let timeStamp = NSDate()
  
  deinit {
    deinitSignal.sendNext()
    representationDeinitDisposable?.dispose()
  }
  
  public required init(parent: Model?) {
    self.parent = parent
    parent?.addChild(self)
  }
  
  //Connection with representation
  
  private weak var representationDeinitDisposable: Disposable?
  
  public func applyRepresentation(representation: DeinitObservable) {
    representationDeinitDisposable = representation.deinitSignal.subscribeNext { [weak self] _ in
      self?.parent?.removeChild(self!)
      }.autodispose()
  }
  
  //Lifecycle
  
  public func sessionWillClose() {
    childModels.forEach { $0.sessionWillClose() }
  }
  
  //Child models
  
  private(set) lazy var childModels = Set<Model>()
  
  final func addChild(childModel: Model) {
    childModels.insert(childModel)
  }
  
  final func removeChild(childModel: Model) {
    childModels.remove(childModel)
  }
  
  public func removeFromParent() {
    parent?.removeChild(self)
  }
  
  //Session Helpers
  
  public final var session: Session {
    get {
      if let session = parent as? Session {
        return session
      } else {
        return parent.session
      }
    }
  }
  
  //Bubble Notifications
  
  private var registeredBubbles = Set<String>()
  
  public final func register(for bubbleNotification: BubbleNotificationName) {
    registeredBubbles.insert(bubbleNotification.dynamicType.domain + "." + bubbleNotification.rawValue)
    pushChildSignal.sendNext(self)
  }
  
  public final func unregister(from bubbleNotification: BubbleNotificationName) {
    registeredBubbles.remove(bubbleNotification.dynamicType.domain + "." + bubbleNotification.rawValue)
  }
  
  public final func isRegistered(for bubbleNotification: BubbleNotificationName) -> Bool {
    return registeredBubbles.contains(bubbleNotification.dynamicType.domain + "." + bubbleNotification.rawValue)
  }
  
  public func raise(bubbleNotification: BubbleNotificationName, withObject object: Any? = nil) {
    _raise(bubbleNotification, withObject: object, sender: self)
  }
  
  public func _raise(bubbleNotification: BubbleNotificationName, withObject object: Any? = nil, sender: Model) {
    if isRegistered(for: bubbleNotification) {
      handle(BubbleNotification(name: bubbleNotification, object: object), sender: sender)
    } else {
      parent?._raise(bubbleNotification, withObject: object, sender: sender)
    }
  }
  
  public func handle(bubbleNotification: BubbleNotification, sender: Model) {}
  
  //Errors
  
  //TODO: extensions
  private var registeredErrors = [String: Set<String>]()
  
  public final func register(for error: ErrorCode) {
    var allCodes = registeredErrors[error.dynamicType.domain] ?? []
    allCodes.insert(error.rawValue)
    registeredErrors[error.dynamicType.domain] = allCodes
  }
  
  public final func register<T where T: ErrorCode>(for errorCodes: [T]) {
    var allCodes = registeredErrors[T.domain] ?? []
    let mappedCodes = errorCodes.map { $0.rawValue }
    mappedCodes.forEach { allCodes.insert($0) }
    registeredErrors[T.domain] = allCodes
  }
  
  public final func unregister(from error: ErrorCode) {
    if let codes = registeredErrors[error.dynamicType.domain] {
      var filteredCodes = codes
      filteredCodes.remove(error.rawValue)
      registeredErrors[error.dynamicType.domain] = filteredCodes
    }
  }
  
  public final func isRegistered(for error: Error) -> Bool {
    guard let codes = registeredErrors[error.domain] else { return false }
    return codes.contains(error.code.rawValue)
  }
  
  public func raise(error: Error) {
    if isRegistered(for: error) {
      handle(error)
    } else {
      parent?.raise(error)
    }
  }
  
  //Override to achieve custom behavior
  
  public func handle(error: Error) {
    errorSignal.sendNext(error)
  }
  
  //Global events
  
  private var registeredGlobalEvents = Set<String>()
  
  public final func register(for globalEvent: GlobalEventName) {
    registeredGlobalEvents.insert(globalEvent.rawValue)
  }
  
  public final func unregister(from globalEvent: GlobalEventName) {
    registeredGlobalEvents.remove(globalEvent.rawValue)
  }
  
  public final func isRegistered(for globalEvent: GlobalEventName) -> Bool {
    return registeredGlobalEvents.contains(globalEvent.rawValue)
  }
  
  public final func raise(
    globalEvent: GlobalEventName,
    withObject object: Any? = nil,
               userInfo: [String: Any] = [:]) {
    let event = GlobalEvent(name: globalEvent, object: object, userInfo: userInfo)
    session.propagate(event)
  }
  
  private func propagate(globalEvent: GlobalEvent) {
    if isRegistered(for: globalEvent.name) {
      handle(globalEvent)
    }
    childModels.forEach { $0.propagate(globalEvent) }
  }
  
  public func handle(globalEvent: GlobalEvent) {}
  
}

extension Model: Hashable, Equatable {
  
  public var hashValue: Int { get { return hash.hash } }
  
}

public func ==(lhs: Model, rhs: Model) -> Bool {
  return lhs.hash == rhs.hash
}

extension Model {
  
  public enum TreeInfoOptions {
    case Representation
    case GlobalEvents
    case BubbleNotifications
    case Errors
    case ErrorsVerbous
    case YouAreHere
  }
  
  public final func printSubtree(params: [TreeInfoOptions] = []) {
    _printSubtree(params, sender: self)
  }
  
  private func _printSubtree(params: [TreeInfoOptions] = [], sender: Model) {
    print("\n")
    printTree(withPrefix: nil, decoration: .EntryPoint, params: params, sender: sender)
    print("\n")
  }
  
  public final func printSessionTree(withOptions params: [TreeInfoOptions] = []) {
    session._printSubtree(params, sender: self)
  }
  
  private enum NodDecoration: String {
    case EntryPoint = "──"
    case Middle = "├─"
    case Last = "└─"
  }
  
  private func printTree(withPrefix prefix: String?, decoration: NodDecoration, params: [TreeInfoOptions] = [], sender: Model) {
    let indent = prefix == nil ? "" : "   "
    
    let currentPrefix = (prefix ?? "") + indent
    
    var nextIndent = ""
    if prefix != nil {
      if decoration == .Last {
        nextIndent = "   "
      } else {
        nextIndent = "   │"
      }
    }
    
    let nextPrefix = (prefix ?? "") + nextIndent
    
    var output = currentPrefix + decoration.rawValue + "\(String(self).componentsSeparatedByString(".").last!)"
    if params.contains(.YouAreHere) && sender == self {
      output += " <- "
    }
    
    if params.contains(.Representation) && representationDeinitDisposable != nil {
      output += "  | (R)"
    }
    
    if params.contains(.GlobalEvents) && !registeredGlobalEvents.isEmpty {
      output += "  | (E):"
      registeredGlobalEvents.forEach { output += " \($0)" }
    }
    
    if params.contains(.BubbleNotifications) && !registeredBubbles.isEmpty {
      output += "  | (B):"
      registeredBubbles.forEach { output += " \($0)" }
    }
    
    if params.contains(.ErrorsVerbous) && !registeredErrors.isEmpty {
      output += "  | (Err): "
      for (domain, codes) in registeredErrors {
        codes.forEach { output += "[\(NSLocalizedString("\(domain).\($0)", comment: ""))] " }
      }
    } else if params.contains(.Errors) && !registeredErrors.isEmpty {
      output += "  | (Err): "
      for (domain, codes) in registeredErrors {
        output += "\(domain) > "
        codes.forEach { output += "\($0) " }
      }
    }
    print(output)
    
    let models = childModels.sort { return $0.timeStamp.compare($1.timeStamp) == .OrderedAscending }
    
    models.forEach {
      var decoration: NodDecoration
      if models.count == 1 {
        decoration = .Last
      } else {
        decoration = $0 == models.last ? .Last : .Middle
      }
      
      $0.printTree(withPrefix: nextPrefix, decoration: decoration, params: params, sender: sender)
    }
  }
  
}
