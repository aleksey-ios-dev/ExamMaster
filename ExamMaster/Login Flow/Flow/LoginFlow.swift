//
//  LoginFlow.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

protocol LoginFlowParent: class {
  func childModel(child: Model, didSelectRegister authorizationInfo: AuthorizationInfo) -> Void
  func childModelDidSelectShowRegistration(child: Model) -> Void
}

class LoginFlow: Model {

  let authorizationProgressSignal = Signal<Bool>()
  
  func pushInitialChildren() {
    pushChildSignal.sendNext(SignInModel(parent: self, flowParent: self))
  }

}

extension LoginFlow: LoginFlowParent {
  
  func childModel(child: Model, didSelectRegister authorizationInfo: AuthorizationInfo) {
    authorizationProgressSignal.sendNext(true)
    
    let authorizationClient: AuthorizationClient = session()!.services.getService()!
    
    authorizationClient.authorizeWithInfo(authorizationInfo) { [weak self] params, error in
      self?.authorizationProgressSignal.sendNext(false)
      guard error == nil else {
        self?.raiseError(error!)
        return
      }
      
      self?.session()?.closeWithParams(params)
    }
  }
  
  func childModelDidSelectShowRegistration(child: Model) {
    pushChildSignal.sendNext(RegistrationModel(parent: self))
  }
  
}