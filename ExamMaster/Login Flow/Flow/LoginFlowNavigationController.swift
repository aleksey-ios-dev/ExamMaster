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
  
  weak var model: LoginFlow! {
    didSet {
      model.pushChildSignal.subscribeNext { [weak self] child in
        self?.buildRepresentationFor(child)
      }.ownedBy(self)
      
      model.authorizationProgressSignal.subscribeNext { inProgress in
        if inProgress { SVProgressHUD.show() }
        else { SVProgressHUD.dismiss() }
      }.ownedBy(self)
      
      model.errorSignal.subscribeNext { [weak self] error in
        self?.showAlertForError(error)
      }.ownedBy(self)
      
      model.pushInitialChildren()
    }
  }
  
  private func buildRepresentationFor(model: Model) {
    switch model {
      
    case let model as SignInModel:
      let signInController = LoginFlowStoryboard.signInViewController()
      signInController.applyModel(model)
      self.viewControllers = [signInController]
      
    case let model as RegistrationModel:
      let controller = LoginFlowStoryboard.registrationViewController()
      controller.applyModel(model)
      pushViewController(controller, animated: true)
      
    default:
      break
    }
  }
  
}

extension LoginFlowNavigationController: RootModelAssignable {
  
  func assignRootModel(model: Model) {
    if let flowModel = model as? LoginFlow {
      self.model = flowModel
    }
  }
  
}