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
  
  @discardableResult
  public func bind(toKeyPath keyPath: String, of object: NSObject) -> Disposable {
    
    return subscribeNext { [weak object] in
      if let object = object {
        object.setValue($0, forKey: keyPath)
      }
      }.take(until: object.deinitSignal)
  }
  
  //Binds values passed by source signal to target observable. Subscription disposed manually.
  
  @discardableResult
  public func bindTo(observable: Observable<T>) -> Disposable {

    return subscribeNext { [weak observable] in
      guard let observable = observable else { return }
      observable.value = $0
    }
  }
  
}
