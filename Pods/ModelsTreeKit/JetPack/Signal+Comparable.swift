//
//  Signal+Comparable.swift
//  ModelsTreeKit
//
//  Created by aleksey on 03.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

extension Signal where T: Comparable {
  
  //Pass values only in ascending order
  
  public func passAscending() -> Observable<T> {
    let nextSignal = Observable<T>()
    
    subscribeNext { [weak nextSignal] newValue in
      if nextSignal?.value == nil || nextSignal?.value < newValue {
        nextSignal?.sendNext(newValue)
      }
    }.putInto(nextSignal.pool)
    
    chainSignal(nextSignal)
    
    return nextSignal
  }
  
  //Pass values only in descending order
  
  public func passDescending() -> Observable<T> {
    let nextSignal = Observable<T>()
    subscribeNext { [weak nextSignal] newValue in
      if nextSignal?.value == nil || nextSignal?.value > newValue {
        nextSignal?.sendNext(newValue)
      }
      }.putInto(nextSignal.pool)
    
    chainSignal(nextSignal)
    
    return nextSignal
  }
  
}