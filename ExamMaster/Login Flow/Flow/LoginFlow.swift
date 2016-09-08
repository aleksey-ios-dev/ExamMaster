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
  func childModel(_ child: Model, didSelectRegister authorizationInfo: AuthorizationInfo) -> Void
  func childModelDidSelectShowRegistration(_ child: Model) -> Void
}

class LoginFlow: Model {

  override init(parent: Model?) {
    super.init(parent: parent)
    
    register(for: ApplicationError.OnlyLettersInputAllowed)
  }
  
  let authorizationProgressSignal = Observable<Bool>() //TODO: Pipe
  
  func pushInitialChildren() {
    pushChildSignal.sendNext(SignInModel(parent: self, flowParent: self))
  }

}

extension LoginFlow: LoginFlowParent {
  
  func childModel(_ child: Model, didSelectRegister authorizationInfo: AuthorizationInfo) {
    authorizationProgressSignal.sendNext(true)
    
    let authorizationClient: AuthorizationClient = session.services.getService()
    
    authorizationClient.authorize(with: authorizationInfo) { [weak self] params, error in
      self?.authorizationProgressSignal.sendNext(false)
      guard error == nil else {
        self?.raise(error!)
        return
      }
      self?.session.close(withParams: params)
    }
  }
  
  func childModelDidSelectShowRegistration(_ child: Model) {
    pushChildSignal.sendNext(RegistrationModel(parent: self))
  }
  
}
