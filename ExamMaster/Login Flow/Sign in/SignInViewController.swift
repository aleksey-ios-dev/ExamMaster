//
//  SignInViewController.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import UIKit

class SignInViewController: UIViewController {
  
  weak var model: SignInModel! {
    didSet {
      model.applyRepresentation(self)
      title = model.title
    }
  }
  
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
  }
  
  @IBAction
  private func register(sender: AnyObject?) {
    guard let model = model else {
      print("dead")
      return
    }

    model.register()
  }
  
  @IBAction
  private func authorize(sender: AnyObject?) {
    model.authorize()
  }
  
}