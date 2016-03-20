//
//  AuthorizationClient.swift
//  ExamMaster
//
//  Created by aleksey on 29.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

typealias AuthorizationCompletion = (params: SessionCompletionParams?, error: Error?) -> Void

class AuthorizationClient: Service {
  func authorizeWithInfo(info: AuthorizationInfo, completion: AuthorizationCompletion) -> Void {
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))

    dispatch_after(delayTime, dispatch_get_main_queue()) {
      var params = SessionCompletionParams()
      
      params[AppCredentialsKeys.Token.rawValue] = String(info.password.hash)
      params[AppCredentialsKeys.Uid.rawValue] = info.username
      params[AppCredentialsKeys.Username.rawValue] = info.username
      
      completion(params: params, error: nil)
    }
  }
}
