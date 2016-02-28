//
//  SignInModel.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//


//Обратный вызов реализован при помощи Bubble Notification
//LoginFlowModel объявляет свой домен для этих уведомлений и перехватывает их на всплытии.
//Удобно для доставки сообщения вверх через несколько посредников

import Foundation
import ModelsTreeKit

class SignInModel: Model {

  let title = "Sign In"
  let inputValiditySignal: Signal<Bool>

  private weak var flowModel: LoginFlowModel!
  private let usernameSignal = Signal<String>()
  private let passwordSignal = Signal<String>()
  private let authorizationInfo = AuthorizationInfo()
  
  init(parent: LoginFlowModel?) {
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

  func authorize() {
    flowModel.childModel(self, didSelectRegister: authorizationInfo)
  }
  
  func register() {
    flowModel.childModelDidSelectShowRegistration(self)
  }
}