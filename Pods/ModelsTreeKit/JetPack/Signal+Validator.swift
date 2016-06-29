//
//  Signal+Validator.swift
//  ModelsTreeKit
//
//  Created by aleksey on 04.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

extension Signal {
  
  public func filterValidWith(validator: (T -> Bool)) -> Signal<T> {
    return self.filter { validator($0) }
  }
  
  public func mapValidWith(validator: (T -> Bool)) -> Signal<Bool> {
    return self.map { validator($0) }
  }
  
}