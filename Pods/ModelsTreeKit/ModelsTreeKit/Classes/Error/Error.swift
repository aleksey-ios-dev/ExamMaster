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

public protocol ErrorCode {
  
  static var domain: String { get }
  var rawValue: Int { get }
  
}

public struct Error: ErrorType {
  
  public var hashValue: Int {
    return (code.rawValue.hashValue + domain.hashValue).hashValue
  }
  
  public let domain: String
  public let code: ErrorCode
  
  public init(code: ErrorCode) {
    self.domain = code.dynamicType.domain
    self.code = code
  }
  
  public func localizedDescription() -> String {
    return NSLocalizedString(descriptionString(), comment: "")
  }
  
  public func fullDescription() -> String {
    return descriptionString() + ": " + localizedDescription()
  }
  
  private func descriptionString() -> String {
    return "\(domain).\(code.rawValue)"
  }
  
}

extension Error: Hashable, Equatable {
  
}

public func ==(a: Error, b: Error) -> Bool {
  return a.code.rawValue == b.code.rawValue && a.domain == b.domain
}