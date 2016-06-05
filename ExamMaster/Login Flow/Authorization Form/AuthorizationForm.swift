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
      usernameTextField.textSignal.subscribeNext { [weak self] text in self?.model.applyUsername(text) }.ownedBy(self)
      passwordTextField.textSignal.subscribeNext { [weak self] text in self?.model.applyPassword(text) }.ownedBy(self)
      usernameTextField.returnSignal.subscribeNext { [weak self] in self?.passwordTextField.becomeFirstResponder() }.ownedBy(self)

      model.usernameSignal.subscribeNext { [weak self] in self?.usernameTextField.text = $0 }.ownedBy(self)
      model.passwordSignal.subscribeNext { [weak self] in self?.passwordTextField.text = $0 }.ownedBy(self)
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
