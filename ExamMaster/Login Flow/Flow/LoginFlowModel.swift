//
//  LoginFlowModel.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

protocol LoginFlowParent {
  func childModel(child: Model, didSelectRegister authorizationInfo: AuthorizationInfo) -> Void
  func childModelDidSelectShowRegistration(child: Model) -> Void
}

class LoginFlowModel: Model {

  func pushInitialChildren() {
    pushChildSignal.sendNext(SignInModel(parent: self))
  }

}

extension LoginFlowModel: LoginFlowParent {
  
  func childModel(child: Model, didSelectRegister authorizationInfo: AuthorizationInfo) {
    var params = SessionCompletionParams()
    
    params[AppCredentialsKeys.Token.rawValue] = String(authorizationInfo.password?.hash)
    params[AppCredentialsKeys.Uid.rawValue] = authorizationInfo.username
    params[AppCredentialsKeys.Username.rawValue] = authorizationInfo.username
    
    session()?.closeWithParams(params)
  }
  
  func childModelDidSelectShowRegistration(child: Model) {
    pushChildSignal.sendNext(RegistrationModel(parent: self))
  }
  
}