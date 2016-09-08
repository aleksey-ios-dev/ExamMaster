//
//  Validator.swift
//  ModelsTreeKit
//
//  Created by aleksey on 04.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import UIKit

public typealias StringValidator = ((String) -> Bool)

public func && (left: @escaping StringValidator, right: @escaping StringValidator) -> StringValidator {
  return { left($0) && right($0) }
}

public func || (left: @escaping StringValidator, right: @escaping StringValidator) -> StringValidator {
  return { left($0) || right($0) }
}

public func != (left: @escaping StringValidator, right: @escaping StringValidator) -> StringValidator {
  return { left($0) != right($0) }
}

public prefix func ! (left: @escaping StringValidator) -> StringValidator {
  return { !left($0) }
}

public struct Validator {
  
  public static func longerThan(_ length: Int) -> StringValidator {
    return { $0.characters.count > length }
  }
  
  public static func contains(_ string: String) -> StringValidator {
    return { $0.contains(string) }
  }
  
  public static func hasPrefix(_ prefix: String) -> StringValidator {
    return { $0.hasPrefix(prefix) }
  }
  
  public static func hasSuffix(_ suffix: String) -> StringValidator {
    return { $0.hasSuffix(suffix) }
  }
  
}
