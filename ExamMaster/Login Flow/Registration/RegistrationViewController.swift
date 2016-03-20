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
  private weak var confirmationButton: UIButton!
  
  @IBOutlet
  private weak var authorizationForm: AuthorizationForm!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    model.printSessionTree(withOptions: [.ErrorsVerbous])
    authorizationForm.model = model.authorizationFormModel
    
    model.authorizationFormModel.inputValiditySignal.subscribeNext { [weak self] valid in
      self?.confirmationButton.enabled = valid
    }.putInto(pool)
  }
  
  @IBAction
  private func register(sender: AnyObject?) {
    model.register()
  }
}