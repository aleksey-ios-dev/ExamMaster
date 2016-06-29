//
//  Validator.swift
//  ModelsTreeKit
//
//  Created by aleksey on 04.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import UIKit

public typealias StringValidator = (String -> Bool)

public func && (left: StringValidator, right: StringValidator) -> StringValidator {
  return { left($0) && right($0) }
}

public func || (left: StringValidator, right: StringValidator) -> StringValidator {
  return { left($0) || right($0) }
}

public func != (left: StringValidator, right: StringValidator) -> StringValidator {
  return { left($0) != right($0) }
}

public prefix func ! (left: StringValidator) -> StringValidator {
  return { !left($0) }
}





public struct Validator {
  
  public static func longerThan(length: Int) -> StringValidator {
    return { $0.characters.count > length }
  }
  
  public static func contains(string: String) -> StringValidator {
    return { $0.containsString(string) }
  }
  
  public static func hasPrefix(string: String) -> StringValidator {
    return { $0.hasPrefix(string) }
  }
  
  public static func hasSuffix(string: String) -> StringValidator {
    return { $0.hasSuffix(string) }
  }
  
}