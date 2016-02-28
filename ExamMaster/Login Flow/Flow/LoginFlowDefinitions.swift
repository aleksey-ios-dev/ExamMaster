//
//  LoginFlowDefinitions.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class AuthorizationInfo {
  var username: String?
  var password: String?
}

extension Bubble {
  
  enum LoginFlow {
    private static var domain = "LoginFlow"
    
    static var Register: Bubble {
      return Bubble(code: LoginFlowCodes.Register.rawValue, domain: domain)
    }
  }
  
  enum LoginFlowCodes: Int {
    case Register
    case SignIn
  }
  
}