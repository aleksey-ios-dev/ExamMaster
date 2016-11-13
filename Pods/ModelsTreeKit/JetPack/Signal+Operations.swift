//
//  Signal+Operations.swift
//  ModelsTreeKit
//
//  Created by aleksey on 04.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

public struct Signals {
  
  static func merge<U>(signals: [Signal<U>]) -> Signal<U> {
    let nextSignal = Signal<U>()
    
    signals.forEach { signal in
      signal.subscribeNext { [weak nextSignal] in nextSignal?.sendNext($0) }.putInto(nextSignal.pool)
    }
    
    return nextSignal
  }
  
}

public extension Signal {
  
  //Transforms value, can change passed value type
  
  public func map<U>(handler: T -> U) -> Signal<U> {
    var nextSignal: Signal<U>!
    if let observableSelf = self as? Observable<T> {
      nextSignal = Observable<U>(handler(observableSelf.value))
    }
    else { nextSignal = Pipe<U>() }
    subscribeNext { [weak nextSignal] in nextSignal?.sendNext(handler($0)) }.putInto(nextSignal.pool)
    chainSignal(nextSignal)
    
    return nextSignal
  }
  
  //Adds a condition for sending next value, doesn't change passed value type
  
  public func filter(handler: T -> Bool) -> Pipe<T> {
    let nextSignal = Pipe<T>()
    subscribeNext { [weak nextSignal] in
      if handler($0) { nextSignal?.sendNext($0) }
      }.putInto(nextSignal.pool)
    
    chainSignal(nextSignal)
    
    return nextSignal
  }
  
  //Applies passed values to the cumulative reduced value
  
  public func reduce<U>(handler: (newValue: T, reducedValue: U?) -> U) -> Signal<U> {
    let nextSignal = Observable<U>()
    subscribeNext { [weak nextSignal] in
      nextSignal?.sendNext(handler(newValue: $0, reducedValue: nextSignal?.value))
      }.putInto(nextSignal.pool)
    
    chainSignal(nextSignal)
    
    return nextSignal
  }
  
  //Sends combined value when any of signals fire
  
  func distinctLatest<U>(otherSignal: Signal<U>) -> Signal<(T?, U?)> {
    let transientSelf = pipe()
    let transientOther = otherSignal.pipe()
    
    let nextSignal = Observable<(T?, U?)>()
    
    transientOther.subscribeNext { [weak nextSignal] in
      guard let nextSignal = nextSignal else { return }
      nextSignal.sendNext((nil, $0))
      }.putInto(nextSignal.pool)
    
    transientSelf.subscribeNext { [weak nextSignal] in
      guard let nextSignal = nextSignal else { return }
      nextSignal.sendNext(($0, nil))
      }.putInto(nextSignal.pool)
    
    chainSignal(nextSignal)
    
    return nextSignal
  }
  
  public func combineLatest<U>(otherSignal: Signal<U>) -> Signal<(T?, U?)> {
    let persistentSelf = observable()
    let persistentOther = otherSignal.observable()
    if let observableSelf = self as? Observable<T> {
      persistentSelf.value = observableSelf.value
    }
    
    if let observableOther = otherSignal as? Observable<U> {
      persistentOther.value = observableOther.value
    }
    
    let nextSignal = Observable<(T?, U?)>()
    
    persistentOther.subscribeNext { [weak persistentSelf, weak nextSignal] in
      guard let _self = persistentSelf, let nextSignal = nextSignal else { return }
      nextSignal.sendNext((_self.value, $0))
      }.putInto(nextSignal.pool)
    
    persistentSelf.subscribeNext { [weak persistentOther, weak nextSignal] in
      guard let otherSignal = persistentOther, let nextSignal = nextSignal else { return }
      nextSignal.sendNext(($0, otherSignal.value))
      }.putInto(nextSignal.pool)
    
    chainSignal(nextSignal)
    
    return nextSignal
  }
  
  //Sends combined value every time when both signals fire at least once
  
  public func combineBound<U>(otherSignal: Signal<U>) -> Signal<(T, U)> {
    let nextSignal = combineLatest(otherSignal).reduce { (newValue, reducedValue) -> ((T? , T?), (U?, U?)) in
      
      var reducedSelfValue: T? = reducedValue?.0.1
      var reducedOtherValue: U? = reducedValue?.1.1
      
      if let newSelfValue = newValue.0 { reducedSelfValue = newSelfValue }
      if let newOtherValue = newValue.1 { reducedOtherValue = newOtherValue }
      if let reducedSelfValue = reducedSelfValue, let reducedOtherValue = reducedOtherValue {
        return ((reducedSelfValue, nil), (reducedOtherValue, nil))
      } else {
        return ((nil, reducedValue?.0.1), (nil, reducedValue?.1.1))
      }
      
      }.map { ($0.0.0, $0.1.0)
      }.filter { $0.0 != nil && $0.1 != nil
      }.map { ($0.0!, $0.1!) }
    
    chainSignal(nextSignal)
    
    return nextSignal
  }
  
  //Zip
  
  public func zip<U>(otherSignal: Signal <U>) -> Signal<(T, U)> {
    let nextSignal = distinctLatest(otherSignal).reduce { (newValue, reducedValue) -> ((T?, [T]), (U?, [U])) in
      let newSelfValue = newValue.0
      let newOtherValue = newValue.1
      
      var reducedSelf = reducedValue?.0.1
      if reducedSelf == nil { reducedSelf = [T]() }
      
      var reducedOther = reducedValue?.1.1
      if reducedOther == nil { reducedOther = [U]() }
      
      if let newSelfValue = newSelfValue { reducedSelf?.append(newSelfValue) }
      if let newOtherValue = newOtherValue { reducedOther?.append(newOtherValue) }
      
      var zippedSelfValue: T? = nil
      var zippedOtherValue: U? = nil
      
      if !reducedSelf!.isEmpty && !reducedOther!.isEmpty {
        zippedSelfValue = reducedSelf!.first
        zippedOtherValue = reducedOther!.first
        reducedSelf!.removeFirst()
        reducedOther!.removeFirst()
      }
      
      return ((zippedSelfValue, reducedSelf!), (zippedOtherValue, reducedOther!))
      }.map { ($0.0.0, $0.1.0)
      }.filter { $0.0 != nil && $0.1 != nil
      }.map { ($0.0!, $0.1!)
    }
    
    chainSignal(nextSignal)
    
    return nextSignal
  }
  
  //Adds blocking signal. false - blocks, true - passes
  
  public func blockWith(blocker: Signal<Bool>) -> Signal<T> {
    let persistentBlocker = blocker.observable()
    return filter { newValue in
      return persistentBlocker.value == false
    }
  }
  
  //Splits signal into two
  
  public func split<U, V>(splitter: T -> (a: U, b: V)) -> (a: Signal<U>, b: Signal<V>) {
    let signalA = Pipe<U>()
    let signalB = Pipe<V>()
    
    subscribeNext { [weak signalA] in signalA?.sendNext(splitter($0).a) }.putInto(signalA.pool)
    subscribeNext { [weak signalB] in signalB?.sendNext(splitter($0).b) }.putInto(signalB.pool)
    
    chainSignal(signalA)
    chainSignal(signalB)
    
    return (signalA, signalB)
  }
  
  //Skips n first values
  
  public func skipFirst(n: Int) -> Pipe<T> {
    let nextSignal = Pipe<T>()
    
    var count = 0
    
    subscribeNext { [weak nextSignal] in
      if count >= n {
        nextSignal?.sendNext($0)
      } else {
        count += 1
      }
    }.putInto(nextSignal.pool)
    
    return nextSignal
  }
  
}
