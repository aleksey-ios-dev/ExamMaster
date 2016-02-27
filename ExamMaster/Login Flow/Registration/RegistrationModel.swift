//
//  RegistrationModel.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

//Обратный отклик реализован через явную типизацию родителя

class RegistrationModel: Model {
  
  weak var flowModel: LoginFlowModel!
  
  let inputValiditySignal: Signal<Bool>
  
  private let usernameSignal = Signal<String>()
  private let passwordSignal = Signal<String>()
  private let authorizationInfo = AuthorizationInfo()

  init(parent: LoginFlowModel?) {
    inputValiditySignal = usernameSignal.combineLatest(passwordSignal).map { username, password in
      guard let username = username, let password = password else { return false }
      return username.characters.count > 3 && password.characters.count > 5
    }

    super.init(parent: parent)
    
    self.flowModel = parent
  }
  
  func applyUsername(username: String) {
    authorizationInfo.username = username
    usernameSignal.sendNext(username)
  }
  
  func applyPassword(password: String) {
    authorizationInfo.password = password
    passwordSignal.sendNext(password)
  }
  
  //State
  
  func register() {
    flowModel.childModel(self, didSelectRegister: authorizationInfo)
  }
}