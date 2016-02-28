//
//  SideMenuViewController.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import UIKit

class SideMenuViewController: UIViewController {
  weak var model: SideMenuModel! {
    didSet {
      model.applyRepresentation(self)
    }
  }
  
  @IBAction
  private func logout(sender: AnyObject?) {
    model.logout()
  }
}