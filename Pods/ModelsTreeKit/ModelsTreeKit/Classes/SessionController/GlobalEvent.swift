//
//  GlobalEvent.swift
//  ModelsTreeKit
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

public protocol GlobalEventName {
  
  var rawValue: String { get }
  
}

public func ==(lhs: GlobalEventName, rhs: GlobalEventName) -> Bool {
  return lhs.rawValue == rhs.rawValue
}

public struct GlobalEvent {
  
  public var name: GlobalEventName
  public var object: Any?
  public var userInfo: [String: Any]
  
  public init(name: GlobalEventName, object: Any? = nil, userInfo: [String: Any] = [:]) {
    self.name = name
    self.object = object
    self.userInfo = userInfo
  }
  
  public var hashValue: Int {
    return name.rawValue.hashValue
  }

}

extension GlobalEvent: Equatable, Hashable {}

public func ==(lhs: GlobalEvent, rhs: GlobalEvent) -> Bool {
  return lhs.name.rawValue == rhs.name.rawValue
}