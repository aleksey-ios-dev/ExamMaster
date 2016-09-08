//
//  Signal+Validator.swift
//  ModelsTreeKit
//
//  Created by aleksey on 04.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

extension Signal {
  
  public func filterValid(with validator: @escaping ((T) -> Bool)) -> Signal<T> {
    return self.filter { validator($0) }
  }
  
  public func mapValid(with validator: @escaping ((T) -> Bool)) -> Signal<Bool> {
    return self.map { validator($0) }
  }
  
}
