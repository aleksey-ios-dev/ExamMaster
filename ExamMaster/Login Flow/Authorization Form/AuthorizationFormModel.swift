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
    inputValiditySignal = (usernameSignal.mapValid(with: validator) && passwordSignal.mapValid(with: validator)).observable()
    
    super.init(parent: parent)
  }
  
  func applyUsername(_ username: String) {
    if !containsOnlyLetters(username) {
      raise(ModelTreeError(code: ApplicationError.OnlyLettersInputAllowed))
      raise(BubbleNotification.MainFlow.ShowSideMenu)
      usernameSignal.sendNext(authorizationInfo.username)
      return
    }
    
    usernameSignal.sendNext(username)
    authorizationInfo.username = username
  }
  
  func applyPassword(_ password: String) {
    authorizationInfo.password = password
    passwordSignal.sendNext(password)
  }
  
  private func containsOnlyLetters(_ input: String) -> Bool {
    for chr in input.characters {
      if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
        return false
      }
    }
    return true
  }

}
