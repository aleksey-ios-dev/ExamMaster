//
//  Signal+Equatable.swift
//  ModelsTreeKit
//
//  Created by aleksey on 03.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

extension Signal where T: Equatable {
  
  //Stops the value from being passed more than once
  
  //BUG: locks propagation of initial value
  public func skipRepeating() -> Signal<T> {
    
    let newSignal = Signal<T>()
    observable().subscribeWithOptions([.New, .Old]) { (new, old, initial) in
      if let new = new where new != old {
        newSignal.sendNext(new)
      }
    }.putInto(pool)
    
    return newSignal
  }
  
}