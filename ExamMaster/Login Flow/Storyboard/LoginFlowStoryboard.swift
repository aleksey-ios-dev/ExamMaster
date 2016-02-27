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
    return storyboard.instantiateViewControllerWithIdentifier("SignIn") as! SignInViewController
  }
  
  static var storyboard: UIStoryboard {
    return UIStoryboard(name: "LoginFlow", bundle: nil)
  }
  
}