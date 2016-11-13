//
//  RegistrationModel.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class RegistrationModel: Model {
  
  let title = "Registration"

  private(set) var authorizationFormModel: AuthorizationFormModel!

  private weak var flowModel: LoginFlow!

  init(parent: LoginFlow?) {
    super.init(parent: parent)
    
    authorizationFormModel = AuthorizationFormModel(parent: self)
    self.flowModel = parent
  }
  
  required init(parent: Model?) {
    fatalError("init(parent:) has not been implemented")
  }
  
  func register() {
    flowModel.childModel(self, didSelectRegister: authorizationFormModel.authorizationInfo)
  }
}