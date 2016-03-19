//
//  AuthorizationFormModel.swift
//  ExamMaster
//
//  Created by aleksey on 19.03.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class AuthorizationFormModel: Model {
  
  let authorizationInfo = AuthorizationInfo()
  let inputValiditySignal: Signal<Bool>

  private let usernameSignal = ValueKeepingSignal<String>(value: "")
  private let passwordSignal = ValueKeepingSignal<String>(value: "")
  
  override init(parent: Model?) {
    inputValiditySignal = usernameSignal.combineLatest(passwordSignal).map { username, password in
      guard let username = username, let password = password else { return false }
      return username.characters.count > 1 && password.characters.count > 1
    }
    
    super.init(parent: parent)
  }

  func applyUsername(username: String) {
    authorizationInfo.username = username
    usernameSignal.sendNext(username)
  }
  
  func applyPassword(password: String) {
    authorizationInfo.password = password
    passwordSignal.sendNext(password)
  }

}