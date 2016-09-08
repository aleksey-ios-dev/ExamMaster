//
//  ModelAssignable.swift
//  SessionSwift
//
//  Created by aleksey on 26.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

public protocol RootModelAssignable: class {
  
  func assignRootModel(model: Model)
  
}

public protocol ModelApplicable: class {
  
  associatedtype T: Model
  weak var model: T! { get set }
  
}

public extension ModelApplicable where Self: DeinitObservable {
  
  func applyModel(_ model: T) {
    self.model = model
    model.applyRepresentation(representation: self)
  }
  
}
