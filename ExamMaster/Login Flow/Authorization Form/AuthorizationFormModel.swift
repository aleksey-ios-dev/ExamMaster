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

  let usernameSignal = ValueKeepingSignal<String>(value: "")
  let passwordSignal = ValueKeepingSignal<String>(value: "")
  
  override init(parent: Model?) {
    inputValiditySignal = usernameSignal.combineLatest(passwordSignal).map { username, password in
      guard let username = username, let password = password else { return false }
      return username.characters.count > 1 && password.characters.count > 1
    }
    
    super.init(parent: parent)
  }
  
  func applyUsername(username: String) {
    if !containsOnlyLetters(username) {
      raiseError(Error(domain: ErrorDomains.Application, code: ApplicationErrors.OnlyLettersInputAllowed))
      usernameSignal.sendNext(authorizationInfo.username)
      return
    }
    
    usernameSignal.sendNext(username)
    authorizationInfo.username = username
  }
  
  func applyPassword(password: String) {
    authorizationInfo.password = password
    passwordSignal.sendNext(password)
  }
  
  private func containsOnlyLetters(input: String) -> Bool {
    for chr in input.characters {
      if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
        return false
      }
    }
    return true
  }

}