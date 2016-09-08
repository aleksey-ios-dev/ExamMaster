//
//  Model.swift
//  SessionSwift
//
//  Created by aleksey on 10.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

extension Model: DeinitObservable { }

open class Model {
  
  public private(set) weak var parent: Model!
  
  public let pushChildSignal = Pipe<Model>()
  public let wantsRemoveChildSignal = Pipe<Model>()
  public let errorSignal = Pipe<Error>()
  public let pool = AutodisposePool()
  public let deinitSignal = Pipe<Void>()
  
  fileprivate let hash = ProcessInfo.processInfo.globallyUniqueString
  fileprivate let timeStamp = NSDate()
  
  deinit {
    deinitSignal.sendNext()
    representationDeinitDisposable?.dispose()
  }
  
  public init(parent: Model?) {
    self.parent = parent
    parent?.add(child: self)
  }
  
  //Connection with representation
  
  fileprivate weak var representationDeinitDisposable: Disposable?
  
  public func applyRepresentation(representation: DeinitObservable) {
    representationDeinitDisposable = representation.deinitSignal.subscribeNext { [weak self] _ in
      self?.parent?.remove(child: self!)
    }.autodispose()
  }
  
  //Lifecycle
  
  open func sessionWillClose() {
    childModels.forEach { $0.sessionWillClose() }
  }
  
  //Child models
  
  private(set) lazy var childModels = Set<Model>()
  
  final func add(child: Model) {
    childModels.insert(child)
  }
  
  final func remove(child: Model) {
    childModels.remove(child)
  }
  
  public func removeFromParent() {
    parent?.remove(child: self)
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
  
  fileprivate var registeredBubbles = Set<String>()
  
  public final func register(for bubble: BubbleNotificationName) {
    registeredBubbles.insert(type(of: bubble).domain + "." + bubble.rawValue)
    pushChildSignal.sendNext(self)
  }
  
  public final func unregister(from bubble: BubbleNotificationName) {
    registeredBubbles.remove(type(of: bubble).domain + "." + bubble.rawValue)
  }
  
  public final func isRegistered(for bubble: BubbleNotificationName) -> Bool {
    return registeredBubbles.contains(type(of: bubble).domain + "." + bubble.rawValue)
  }
  
  public func raise(_ bubble: BubbleNotificationName, withObject object: Any? = nil) {
    _raise(bubble: bubble, withObject: object, sender: self)
  }
  
  private func _raise(bubble: BubbleNotificationName, withObject object: Any? = nil, sender: Model) {
    if isRegistered(for: bubble) {
      handle(bubble: BubbleNotification(name: bubble, object: object), sender: sender)
    } else {
      parent?._raise(bubble: bubble, withObject: object, sender: sender)
    }
  }
  
  open func handle(bubble: BubbleNotification, sender: Model) {}
  
  //Errors
  
  //TODO: extensions
  fileprivate var registeredErrors = [String: Set<Int>]()
  
  public final func register(for error: ErrorCode) {
    var allCodes = registeredErrors[type(of: error).domain] ?? []
    allCodes.insert(error.rawValue)
    registeredErrors[type(of: error).domain] = allCodes
  }
  
  public final func register<T>(for errorCodes: [T]) where T: ErrorCode {
    var allCodes = registeredErrors[T.domain] ?? []
    let mappedCodes = errorCodes.map { $0.rawValue }
    mappedCodes.forEach { allCodes.insert($0) }
    registeredErrors[T.domain] = allCodes
  }
  
  public final func unregister(from error: ErrorCode) {

    if let codes = registeredErrors[type(of: error).domain] {
      var filteredCodes = codes
      filteredCodes.remove(error.rawValue)
      registeredErrors[type(of: error).domain] = filteredCodes
    }
  }
  
  public final func isRegistered(for error: ModelTreeError) -> Bool {
    guard let codes = registeredErrors[error.domain] else { return false }
    return codes.contains(error.code.rawValue)
  }
  
  public func raise(_ error: ModelTreeError) {
    if isRegistered(for: error) {
      handle(error: error)
    } else {
      parent?.raise(error)
    }
  }
  
  //Override to achieve custom behavior
  
  open func handle(error: ModelTreeError) {
    errorSignal.sendNext(error)
  }
  
  //Global events
  
  fileprivate var registeredGlobalEvents = Set<String>()
  
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
    _ globalEvent: GlobalEventName,
    withObject object: Any? = nil,
    userInfo: [String: Any] = [:]) {
    let event = GlobalEvent(name: globalEvent, object: object, userInfo: userInfo)
    session.propagate(globalEvent: event)
  }
  
  private func propagate(globalEvent: GlobalEvent) {
    if isRegistered(for: globalEvent.name) {
      handle(globalEvent: globalEvent)
    }
    childModels.forEach { $0.propagate(globalEvent: globalEvent) }
  }
  
  open func handle(globalEvent: GlobalEvent) {}
  
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
  
  public final func printSubtree(withParams params: [TreeInfoOptions] = []) {
    print("\n")
    printTreeLevel(level: 0, params: params)
    print("\n")
  }
  
  public final func printSessionTree(withOptions params: [TreeInfoOptions] = []) {
    session.printSubtree(withParams: params)
  }
  
  private func printTreeLevel(level: Int, params: [TreeInfoOptions] = []) {
    var output = "|"
    let indent = "  |"
    
    for _ in 0..<level {
      output += indent
    }

    output += "\(String(describing: self).components(separatedBy: ".").last!)"
    
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
    
    childModels.sorted { return $0.timeStamp.compare($1.timeStamp as Date) == .orderedAscending }.forEach { $0.printTreeLevel(level: level + 1, params:  params) }
  }
  
}
