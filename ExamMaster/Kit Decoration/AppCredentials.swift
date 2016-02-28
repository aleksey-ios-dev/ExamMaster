//
//  AppCredentials.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

enum AppCredentialsKeys: String {
  case Token = "token"
  case Uid = "uid"
  case Username = "username"
}


extension SessionCredentials {
  var uid: String! {
    return self[AppCredentialsKeys.Uid.rawValue] as! String
  }
  
  var token: String! {
    return self[AppCredentialsKeys.Token.rawValue] as! String
  }
  
  var username: String! {
    return self[AppCredentialsKeys.Username.rawValue] as! String
  }
}