//
//  AuthorizationClient.swift
//  ExamMaster
//
//  Created by aleksey on 29.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

typealias AuthorizationCompletion = (_ params: SessionCompletionParams?, _ error: ModelTreeError?) -> Void

class AuthorizationClient: Service {
  func authorize(with info: AuthorizationInfo, completion: AuthorizationCompletion) -> Void {
    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
      var params = SessionCompletionParams()
      
      params[AppCredentialsKeys.Token.rawValue] = String(describing: info.password.hash) as AnyObject
      params[AppCredentialsKeys.Uid.rawValue] = info.username as AnyObject
      params[AppCredentialsKeys.Username.rawValue] = info.username as AnyObject
      
      completion(params, nil)
    })
  }
}
