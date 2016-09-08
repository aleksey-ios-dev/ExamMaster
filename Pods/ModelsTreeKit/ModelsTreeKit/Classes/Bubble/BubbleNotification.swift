//
//  BubbleNotification.swift
//  ModelsTreeKit
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

public protocol BubbleNotificationName {
  
  static var domain: String { get }
  var rawValue: String { get }
  
}

public func ==(lhs: BubbleNotificationName, rhs: BubbleNotificationName) -> Bool {
  return lhs.rawValue == rhs.rawValue
}

public struct BubbleNotification {
  
  public var name: BubbleNotificationName
  public var domain: String {
    get {
      return type(of: name).domain
    }
  }
  public var object: Any?
  public var hashValue: Int { return (name.rawValue.hashValue &+ name.rawValue.hashValue).hashValue }
  
  public init(name: BubbleNotificationName, object: Any? = nil) {
    self.name = name
    self.object = object
  }
  
}

extension BubbleNotification: Hashable, Equatable {}

public func ==(a: BubbleNotification, b: BubbleNotification) -> Bool {
  return a.name == b.name && a.domain == b.domain
}
