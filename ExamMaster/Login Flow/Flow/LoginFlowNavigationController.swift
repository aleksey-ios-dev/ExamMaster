//
//  LoginFlowNavigationController.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import UIKit
import ModelsTreeKit

class LoginFlowNavigationController: UINavigationController {
  
  weak var model: LoginFlowModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    model.pushChildSignal.subscribeNext { [weak self] child in
      self?.buildRepresentationFor(child)
    }.putInto(pool)
    
    model.pushInitialModels()
  }
  
  private func buildRepresentationFor(model: Model) {
    switch model {
    case let model as SignInModel:
      let signInController = SignInViewController()
      signInController.model = model
      self.viewControllers = [signInController]
    default:
      break
    }
  }
  
}

extension LoginFlowNavigationController: ModelAssignable {
  
  func assignModel(model: Model) {
    if let flowModel = model as? LoginFlowModel {
      self.model = flowModel
    }
  }
  
}