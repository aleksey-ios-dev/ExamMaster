//
//  Signal.swift
//  SessionSwift
//
//  Created by aleksey on 14.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

infix operator >>> { associativity left precedence 160 }

public func >>><T> (signal: Signal<T>, handler: (T -> Void)) -> Disposable {
  return signal.subscribeNext(handler)
}


public class Signal<T> {
  
  public var hashValue = NSProcessInfo.processInfo().globallyUniqueString.hash
  
  public typealias SignalHandler = T -> Void
  public typealias StateHandler = Bool -> Void
    
  var nextHandlers = [Invocable]()
  var completedHandlers = [Invocable]()
  
  //Destructor is executed before the signal's deallocation. A good place to cancel your network operation.
  
  var destructor: (Void -> Void)?
  
  var pool = AutodisposePool()
    
  deinit {
    destructor?()
    pool.drain()
  }
    
  public func sendNext(newValue: T) {
    nextHandlers.forEach { $0.invoke(newValue) }
  }
  
  public func sendCompleted() {
    completedHandlers.forEach { $0.invokeState(true) }
  }
  
  //Adds handler to signal and returns subscription
  
  public func subscribeNext(handler: SignalHandler) -> Disposable {
    let wrapper = Subscription(handler: handler, signal: self)
    nextHandlers.append(wrapper)
    
    return wrapper
  }
  
  public func subscribeCompleted(handler: StateHandler) -> Disposable {
    let wrapper = Subscription(handler: nil, signal: self)
    wrapper.stateHandler = handler
    completedHandlers.append(wrapper)
    
    return wrapper
  }
  
  func chainSignal<U>(nextSignal: Signal<U>) -> Signal<U> {
    subscribeCompleted { [weak nextSignal] _ in nextSignal?.sendCompleted() }.putInto(nextSignal.pool)
    
    return nextSignal
  }
  
}

extension Signal: Hashable, Equatable {}

public func ==<T>(lhs: Signal<T>, rhs: Signal<T>) -> Bool {
  return lhs.hashValue == rhs.hashValue
}
