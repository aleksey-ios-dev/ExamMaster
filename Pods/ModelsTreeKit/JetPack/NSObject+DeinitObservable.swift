//
//  UIViewController+DeinitObservable.swift
//  ModelsTreeKit
//
//  Created by aleksey on 13.12.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

class DeinitNotifier: NSObject {
  
  let signal = Pipe<Void>()
  
  deinit {
    signal.sendNext()
  }
  
}

extension NSObject: DeinitObservable {
  
  private struct AssociatedKeys {
    static var DeinitNotifierKey = "DeinitNotifierKey"
  }
  
  public var deinitSignal: Pipe<Void> {
    get { return deinitNotifier.signal }
  }
  
  private var deinitNotifier: DeinitNotifier {
    get {
      var wrapper = objc_getAssociatedObject(self, &AssociatedKeys.DeinitNotifierKey) as? DeinitNotifier
      
      if (wrapper == nil) {
        wrapper = DeinitNotifier()
        objc_setAssociatedObject(self, &AssociatedKeys.DeinitNotifierKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      }
      
      return wrapper!
    }
  }
  
}