//
//  RegistrationViewController.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import UIKit
import ModelsTreeKit

class RegistrationViewController: UIViewController, ModelApplicable {
  weak var model: RegistrationModel! { didSet { title = model.title } }
  
  @IBOutlet
  private weak var usernameTextField: UITextField!
  
  @IBOutlet
  private weak var passwordTextField: UITextField!
  
  @IBOutlet
  private weak var confirmationButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    model.printSessionTree(withOptions: [.Representation])
    usernameTextField.textSignal.subscribeNext { [weak self] text in self?.model.authorizationFormModel.applyUsername(text) }.putInto(pool)
    passwordTextField.textSignal.subscribeNext { [weak self] text in self?.model.authorizationFormModel.applyPassword(text) }.putInto(pool)
    model.authorizationFormModel.inputValiditySignal.subscribeNext { [weak self] valid in self?.confirmationButton.enabled = valid }.putInto(pool)
  }
  
  @IBAction
  private func register(sender: AnyObject?) {
    model.register()
  }
}