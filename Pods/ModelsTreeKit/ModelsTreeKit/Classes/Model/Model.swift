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
  
  public init(parent: Model?) {
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
  
  public final func registerFor(bubbleNotification: BubbleNotificationName) {
    registeredBubbles.insert(bubbleNotification.dynamicType.domain + "." + bubbleNotification.rawValue)
    pushChildSignal.sendNext(self)
  }
  
  public final func unregisterFrom(bubbleNotification: BubbleNotificationName) {
    registeredBubbles.remove(bubbleNotification.dynamicType.domain + "." + bubbleNotification.rawValue)
  }
  
  public final func isRegisteredFor(bubbleNotification: BubbleNotificationName) -> Bool {
    return registeredBubbles.contains(bubbleNotification.dynamicType.domain + "." + bubbleNotification.rawValue)
  }
  
  public func raise(bubbleNotification: BubbleNotificationName, withObject object: Any? = nil) {
    _raise(bubbleNotification, withObject: object, sender: self)
  }
  
  public func _raise(bubbleNotification: BubbleNotificationName, withObject object: Any? = nil, sender: Model) {
    if isRegisteredFor(bubbleNotification) {
      handle(BubbleNotification(name: bubbleNotification, object: object), sender: sender)
    } else {
      parent?._raise(bubbleNotification, withObject: object, sender: sender)
    }
  }
  
  public func handle(bubbleNotification: BubbleNotification, sender: Model) {}
  
  //Errors
  
  //TODO: extensions
  private var registeredErrors = [String: Set<Int>]()
  
  public final func registerFor(error: ErrorCode) {
    var allCodes = registeredErrors[error.dynamicType.domain] ?? []
    allCodes.insert(error.rawValue)
    registeredErrors[error.dynamicType.domain] = allCodes
  }
  
  public final func registerForErrorCodes<T where T: ErrorCode>(errorCodes codes: [T]) {
    var allCodes = registeredErrors[T.domain] ?? []
    let mappedCodes = codes.map { $0.rawValue }
    mappedCodes.forEach { allCodes.insert($0) }
    registeredErrors[T.domain] = allCodes
  }
  
  public final func unregisterFrom(error: ErrorCode) {
    if let codes = registeredErrors[error.dynamicType.domain] {
      var filteredCodes = codes
      filteredCodes.remove(error.rawValue)
      registeredErrors[error.dynamicType.domain] = filteredCodes
    }
  }
  
  public final func isRegisteredFor(error: Error) -> Bool {
    guard let codes = registeredErrors[error.domain] else { return false }
    return codes.contains(error.code.rawValue)
  }
  
  public func raise(error: Error) {
    if isRegisteredFor(error) {
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
  
  public final func registerFor(globalEvent: GlobalEventName) {
    registeredGlobalEvents.insert(globalEvent.rawValue)
  }
  
  public final func unregisterFrom(globalEvent: GlobalEventName) {
    registeredGlobalEvents.remove(globalEvent.rawValue)
  }
  
  public final func isRegisteredFor(globalEvent: GlobalEventName) -> Bool {
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
    if isRegisteredFor(globalEvent.name) {
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
  }
  
  public final func printSubtree(params: [TreeInfoOptions] = []) {
    print("\n")
    printTreeLevel(0, params: params)
    print("\n")
  }
  
  public final func printSessionTree(withOptions params: [TreeInfoOptions] = []) {
    session.printSubtree(params)
  }
  
  private func printTreeLevel(level: Int, params: [TreeInfoOptions] = []) {
    var output = "|"
    let indent = "  |"
    
    for _ in 0..<level {
      output += indent
    }
    
    output += "\(String(self).componentsSeparatedByString(".").last!)"
    
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
    
    childModels.sort { return $0.timeStamp.compare($1.timeStamp) == .OrderedAscending }.forEach { $0.printTreeLevel(level + 1, params:  params) }

  }
  
}