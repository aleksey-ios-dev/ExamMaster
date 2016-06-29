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
  let inputValiditySignal: Observable<Bool>

  let usernameSignal = Observable<String>(value: "")
  let passwordSignal = Observable<String>(value: "")
  
  override init(parent: Model?) {
    let validator = Validator.longerThan(1)
    inputValiditySignal = (usernameSignal.mapValidWith(validator) && passwordSignal.mapValidWith(validator)).observable()
    
    super.init(parent: parent)
  }
  
  func applyUsername(username: String) {
    if !containsOnlyLetters(username) {
      raise(Error(code: ApplicationError.OnlyLettersInputAllowed))
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