//
//  Errors.swift
//  WeLearnEnglish
//
//  Created by aleksey on 20.12.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

struct NetworkErrorDomain: ErrorDomain {
    let domainTitle = "NetworkErrorDomain"
    
    init() {
    }
    
    enum Errors: Int, ErrorCodesList, ErrorCode {
        case DownloadError = 100
        case BadToken = 101
        
        static func allCodes() -> [ErrorCode] {
            return [Errors.DownloadError, Errors.BadToken]
        }
        
        func codeValue() -> Int {
            return rawValue
        }
    }
}

struct ParseErrorDomain: ErrorDomain {
    let domainTitle = "RegistrationErrorDomain"
    
    init() {
    }
    
    enum Errors: Int, ErrorCodesList, ErrorCode {
        case UserExists = 202
        case WrongPassword = 101
        
        static func allCodes() -> [ErrorCode] {
            return [Errors.UserExists, Errors.WrongPassword]
        }
        
        func codeValue() -> Int {
            return rawValue
        }
    }
}


struct ApplicationErrorDomain: ErrorDomain {
    let domainTitle = "ApplicationErrorDomain"
    
    init() {
    }
    
    enum Errors: Int, ErrorCodesList, ErrorCode {
        case UnknownError = 100
        case ScannerError = 101
        case DownloadError = 102
        
        static func allCodes() -> [ErrorCode] {
            return [Errors.UnknownError, Errors.ScannerError, Errors.DownloadError]
        }
        
        func codeValue() -> Int {
            return rawValue
        }
    }
}

extension Error {
    public static func mappedErrorFromNSError(error: NSError?) -> Error? {
        guard let error = error else {
            return nil
        }
        
        switch error.domain {
        case "Parse":
            if let code = ParseErrorDomain.Errors(rawValue: error.code) {
                return Error(domain: ParseErrorDomain(), code: code)
            }
        default:
            break
        }
        
        
        return Error(domain: ApplicationErrorDomain(), code: ApplicationErrorDomain.Errors.UnknownError)
    }
}