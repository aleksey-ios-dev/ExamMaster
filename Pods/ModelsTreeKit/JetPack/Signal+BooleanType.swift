//
//  Signal+BooleanType.swift
//  ModelsTreeKit
//
//  Created by aleksey on 03.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

public protocol BooleanExpressible {
  var boolValue: Bool { get }
}

extension Bool: BooleanExpressible {
  public var boolValue: Bool { return self }
}

public extension Signal where T: BooleanExpressible {
  
  func and(_ otherSignal: Signal<T>) -> Signal<Bool> {
    return observable().combineLatest(otherSignal.observable()).map {
      guard let value1 = $0, let value2 = $1 else { return false }
      return value1.boolValue && value2.boolValue
    }
  }
  
  func or(_ otherSignal: Signal<T>) -> Signal<Bool> {
    return observable().combineLatest(otherSignal.observable()).map { $0?.boolValue == true || $1?.boolValue == true }
  }
  
  func xor(_ otherSignal: Signal<T>) -> Signal<Bool> {
    return observable().combineLatest(otherSignal.observable()).map {
      return $0?.boolValue == true && $1?.boolValue != true || $0?.boolValue != true && $1?.boolValue == true
    }
  }
  
  func not() -> Signal<Bool> {
    return map { !$0.boolValue }
  }
  
}

public func && <T> (left: Signal<T>, right: Signal<T>) -> Signal<Bool> where T: BooleanExpressible {
  return left.and(right)
}

public func || <T> (left: Signal<T>, right: Signal<T>) -> Signal<Bool> where T: BooleanExpressible {
  return left.or(right)
}

public func != <T> (left: Signal<T>, right: Signal<T>) -> Signal<Bool> where T: BooleanExpressible {
  return left.xor(right)
}

public prefix func ! <T> (left: Signal<T>) -> Signal<Bool> where T: BooleanExpressible {
  return left.not()
}
