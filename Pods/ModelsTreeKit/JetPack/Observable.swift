//
//  Observable.swift
//  ModelsTreeKit
//
//  Created by aleksey on 04.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

public enum ObservingOptions {
  
  case Old, New, Initial
  
}

public class Observable<T>: Signal<T> {
  
  public typealias ObservingHandler = ((new: T?, old: T?, initial: T?) -> Void)
  
  public init(_ value: T) {
    super.init()
    
    _value = value
  }
  
  override init() {
    super.init()
  }
  
  public var value: T {
    get {
      return _value!
    } set {
      _value = newValue
    }
  }
  
  internal var _value: T? {
    willSet {
      if let newValue = newValue { super.sendNext(newValue) }
    }
  }
  
  public override func sendNext(value: T) {
    self.value = value
  }
  
  public override func subscribeNext(handler: SignalHandler) -> Disposable {
    return subscribeNextStartingFromInitial(true, handler: handler)
  }
  
  public func subscribeWithOptions(options: [ObservingOptions], handler: ObservingHandler) -> Disposable {
    let initialValue = _value
    
    let extendedObservable = map { [weak self] (newValue: T?) -> (T?, T?, T?) in
      guard let _self = self else { return (new: nil, old: nil, initial: nil)}
      let initial = options.contains(.Initial) ? initialValue : nil
      let old = options.contains(.Old) ? _self._value : nil
      let new = options.contains(.New) ? newValue : nil
      
      return (new, old, initial)
    } as! Observable<(T?, T?, T?)>
    
    let subscription = extendedObservable.subscribeNextStartingFromInitial(false, handler: handler) as! Subscription<(T?, T?, T?)>
    
    if options.contains(.Initial) {
      subscription.handler?(initialValue, initialValue, initialValue)
    }
    
    return subscription
  }
  
  private func subscribeNextStartingFromInitial(startingFromInitial: Bool, handler: SignalHandler) -> Disposable {
    let subscription = super.subscribeNext(handler) as! Subscription<T>
    if startingFromInitial { subscription.handler?(value) }
    
    return subscription
  }
  
}