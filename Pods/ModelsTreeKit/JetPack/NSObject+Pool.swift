//
//  UIViewController+Pool.swift
//  ModelsTreeKit
//
//  Created by aleksey on 13.12.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation
import UIKit

public extension NSObject {
  
  private struct AssociatedKeys {
    static var AutodisposePoolKey = "AutodisposePoolKey"
  }
  
  public var pool: AutodisposePool {
    get {
      var wrapper = objc_getAssociatedObject(self, &AssociatedKeys.AutodisposePoolKey) as? ObjectObjcWrapper
      
      if (wrapper == nil) {
        wrapper = ObjectObjcWrapper(object: AutodisposePool())
        objc_setAssociatedObject(self, &AssociatedKeys.AutodisposePoolKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      }
      
      return wrapper!.object as! AutodisposePool
    }
  }
}

private class ObjectObjcWrapper: NSObject {
  
  var object: AnyObject
  
  init(object: AnyObject) {
    self.object = object
  }
  
}