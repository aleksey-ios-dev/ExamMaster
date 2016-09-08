//
// Created by aleksey on 06.11.15.
// Copyright (c) 2015 aleksey chernish. All rights reserved.
//

import Foundation

public protocol ObjectConsuming {
  
  associatedtype ObjectType
  
  var object: ObjectType? { get }
  
  func applyObject(object: ObjectType) -> Void
  
}

public extension ObjectConsuming {
  
  var object: ObjectType {
    set {
      self.object = object
      if let object = self.object {
        applyObject(object: object)
      }
    }
    get { return self.object }
  }
  
  func reapplyObject() {
    if let object = self.object { applyObject(object: object) }
  }
  
}
