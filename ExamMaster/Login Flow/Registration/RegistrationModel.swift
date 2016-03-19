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
  
  let title = "Registration"
  
  weak var flowModel: LoginFlow!
  
  let inputValiditySignal: Signal<Bool>
  
  private let usernameSignal = ValueKeepingSignal<String>(value: "")
  private let passwordSignal = ValueKeepingSignal<String>(value: "")
  private let authorizationInfo = AuthorizationInfo()

  init(parent: LoginFlow?) {
    inputValiditySignal = usernameSignal.combineLatest(passwordSignal).map { username, password in
      guard let username = username, let password = password else { return false }
      return username.characters.count > 1 && password.characters.count > 1
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