//
//  Errors.swift
//  ModelsTreeKit
//
//  Created by aleksey on 20.12.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

struct NetworkErrorDomain: ErrorDomain {
  
  let title = "NetworkErrorDomain"
  
  init() {
  }
  
  enum Errors: Int, ErrorCodesList, ErrorCode {
    case ResponseError = 100
    case BadToken = 101
    
    static func allCodes() -> [ErrorCode] {
      return [Errors.ResponseError, Errors.BadToken]
    }
  }
  
}


struct ApplicationErrorDomain: ErrorDomain {
  
  let title = "ApplicationErrorDomain"
  
  init() {
  }
  
  enum Errors: Int, ErrorCodesList, ErrorCode {
    case UnknownError = 100
    
    static func allCodes() -> [ErrorCode] {
      return [Errors.UnknownError]
    }
  }
  
}