//
//  AuthorizationForm.swift
//  ExamMaster
//
//  Created by aleksey on 20.03.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class AuthorizationForm: UIView {
  
  weak var model: AuthorizationFormModel! {
    didSet {
      usernameTextField.textSignal.subscribeNext { [weak self] text in self?.model.applyUsername(text) }.putInto(pool)
      passwordTextField.textSignal.subscribeNext { [weak self] text in self?.model.applyPassword(text) }.putInto(pool)
      usernameTextField.returnSignal.subscribeNext { [weak self] in self?.passwordTextField.becomeFirstResponder() }.putInto(pool)

      model.usernameSignal.subscribeNext { [weak self] in self?.usernameTextField.text = $0 }
      model.passwordSignal.subscribeNext { [weak self] in self?.passwordTextField.text = $0 }
    }
  }
  
  @IBOutlet
  private weak var usernameTextField: UITextField!
  
  @IBOutlet
  private weak var passwordTextField: UITextField!
  
  private weak var formView: UIView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setup()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    formView.frame = bounds
  }
  
  private func setup() {
    let nib = UINib(nibName: "AuthorizationForm", bundle: nil)
    formView = nib.instantiateWithOwner(self, options: nil).first as! UIView
    backgroundColor = .blackColor()
    
    addSubview(formView)
  }
  
}
