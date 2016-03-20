//
//  SignInModel.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class SignInModel: Model {

  let title = "Sign In"
  private(set) var authorizationFormModel: AuthorizationFormModel!
  
  private weak var flowModel: LoginFlowParent!
  
  init(parent: Model?, flowParent: LoginFlowParent) {
    super.init(parent: parent)
    
    self.flowModel = flowParent
    authorizationFormModel = AuthorizationFormModel(parent: self)
  }
  
  func authorize() {
    flowModel.childModel(self, didSelectRegister: authorizationFormModel.authorizationInfo)
  }
  
  func register() {
    flowModel.childModelDidSelectShowRegistration(self)
  }
  
}