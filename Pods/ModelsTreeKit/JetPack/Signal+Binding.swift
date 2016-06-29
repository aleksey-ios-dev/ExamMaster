//
//  Signal+Binding.swift
//  ModelsTreeKit
//
//  Created by aleksey on 04.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

public extension Signal {
  
  //Binds value for keypath of object to signal. Unsubscribes on object deallocation,
  //or earlier if you handle subscrition manually
  
  public func bindTo(keyPath keyPath: String, of object: NSObject) -> Disposable {
    
    return subscribeNext { [weak object] in
      if let value = $0 as? AnyObject, let object = object {
        object.setValue(value, forKey: keyPath)
      }
    }.takeUntil(object.deinitSignal)
  }
  
  //Binds values passed by source signal to target observable. Subscription disposed manually.
  
  public func bindTo(observable: Observable<T>) -> Disposable {

    return subscribeNext { [weak observable] in
      guard let observable = observable else { return }
      observable.value = $0
    }
  }
  
}