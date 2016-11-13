//
//  Error.swift
//  SessionSwift
//
//  Created by aleksey on 14.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

public protocol ErrorCodesList {
  
  static func allCodes() -> [ErrorCode]
  
}

public protocol ErrorContext {
  
  var rawValue: String { get }
  
}

public protocol ErrorCode {
  
  static var domain: String { get }
  var rawValue: String { get }
  
}

public struct Error: ErrorType {
  
  public var hashValue: Int {
    return (code.rawValue + domain).hashValue
  }
  
  public let domain: String
  public let code: ErrorCode
  public let context: ErrorContext?
  public let underlyingError: NSError?
  
  public init(code: ErrorCode, context: ErrorContext? = nil, underlyingError: NSError? = nil) {
    self.domain = code.dynamicType.domain
    self.code = code
    self.context = context
    self.underlyingError = underlyingError
  }
  
  public func localizedDescription() -> String {
    return NSLocalizedString(descriptionString(), comment: "")
  }
  
  public func fullDescription() -> String {
    return descriptionString() + ": " + localizedDescription()
  }
  
  private func descriptionString() -> String {
    
    var descriptionString = "\(domain).\(code.rawValue)"
    if let context = context {
      descriptionString += ".\(context.rawValue)"
    }
    
    return descriptionString
  }
  
}

extension Error: Hashable, Equatable {
  
}

public func ==(a: Error, b: Error) -> Bool {
  return a.code == b.code
}

public func ==(a: ErrorCode, b: ErrorCode) -> Bool {
  return a.rawValue == b.rawValue && a.dynamicType.domain == b.dynamicType.domain
}
