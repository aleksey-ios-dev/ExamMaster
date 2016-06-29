//
//  Signal+BooleanType.swift
//  ModelsTreeKit
//
//  Created by aleksey on 03.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

extension Signal where T: BooleanType {
  
  func and(otherSignal: Signal<T>) -> Signal<Bool> {
    return observable().combineLatest(otherSignal.observable()).map {
      guard let value1 = $0, let value2 = $1 else { return false }
      return value1.boolValue && value2.boolValue
    }
  }
  
  func or(otherSignal: Signal<T>) -> Signal<Bool> {
    return observable().combineLatest(otherSignal.observable()).map { $0?.boolValue == true || $1?.boolValue == true }
  }
  
  func xor(otherSignal: Signal<T>) -> Signal<Bool> {
    return observable().combineLatest(otherSignal.observable()).map {
      return $0?.boolValue == true && $1?.boolValue != true || $0?.boolValue != true && $1?.boolValue == true
    }
  }
  
  func not() -> Signal<Bool> {
    return map { !$0.boolValue }
  }
  
}

public func && <T where T: BooleanType> (left: Signal<T>, right: Signal<T>) -> Signal<Bool> {
  return left.and(right)
}

public func || <T where T: BooleanType> (left: Signal<T>, right: Signal<T>) -> Signal<Bool> {
  return left.or(right)
}

public func != <T where T: BooleanType> (left: Signal<T>, right: Signal<T>) -> Signal<Bool> {
  return left.xor(right)
}

public prefix func ! <T where T: BooleanType> (left: Signal<T>) -> Signal<Bool> {
  return left.not()
}