//
//  LoginFlowStoryboard.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import UIKit

class LoginFlowStoryboard: UIStoryboard {
  class func signInViewController() -> SignInViewController {
    return storyboard.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
  }
  
  class func registrationViewController() -> RegistrationViewController {
    return storyboard.instantiateViewController(withIdentifier: "Registration") as! RegistrationViewController
  }
  
  static var storyboard: UIStoryboard {
    return UIStoryboard(name: "LoginFlow", bundle: nil)
  }
  
}
