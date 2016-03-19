//
//  SignInViewController.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import UIKit
import ModelsTreeKit

class SignInViewController: UIViewController, ModelApplicable {
  
  weak var model: SignInModel! { didSet { title = model.title } }
  
  @IBOutlet
  private weak var usernameTextField: UITextField!
  
  @IBOutlet
  private weak var passwordTextField: UITextField!
  
  @IBOutlet
  private weak var confirmationButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    usernameTextField.textSignal.subscribeNext { [weak self] text in self?.model.applyUsername(text) }.putInto(pool)
    passwordTextField.textSignal.subscribeNext { [weak self] text in self?.model.applyPassword(text) }.putInto(pool)
    model.inputValiditySignal.subscribeNext { [weak self] valid in self?.confirmationButton.enabled = valid }.putInto(pool)
    
    usernameTextField.returnSignal.subscribeNext { [weak self] in self?.passwordTextField.becomeFirstResponder() }.putInto(pool)
  }
  
  @IBAction
  private func register(sender: AnyObject?) {
    model.register()
  }
  
  @IBAction
  private func authorize(sender: AnyObject?) {
    model.authorize()
  }
  
}