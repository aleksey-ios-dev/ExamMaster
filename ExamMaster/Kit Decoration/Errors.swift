//
//  Errors.swift
//  ModelsTreeKit
//
//  Created by aleksey on 20.12.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

enum NetworkError: String, ErrorCode {
  
  static var domain = "NetworkErrors"
  
  case BadResponse = "100"
  case BadToken = "101"
  
}

enum ApplicationError: String, ErrorCode {
  
  static var domain = "ApplicationErrors"
  
  case OnlyLettersInputAllowed = "100"
}