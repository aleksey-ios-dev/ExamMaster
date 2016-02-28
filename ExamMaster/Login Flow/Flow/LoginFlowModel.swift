//
//  LoginFlowModel.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
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

protocol LoginFlowParent {
  func childModel( child: Model, didSelectRegister authorizationInfo: AuthorizationInfo) -> Void
}

class LoginFlowModel: Model {

  override init(parent: Model?) {
    super.init(parent: parent)
    
    registerForBubbleNotification(Bubble.LoginFlow.Register)
  }
  
  func pushInitialChildren() {
    pushChildSignal.sendNext(SignInModel(parent: self))
  }
  
  //Bubbles handling
  
  override func handleBubbleNotification(bubble: Bubble, sender: Model) {
    switch bubble.code {
    case Bubble.LoginFlowCodes.Register.rawValue:
      pushChildSignal.sendNext(RegistrationModel(parent: self))
      
    default:
      break
    }
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
  
}