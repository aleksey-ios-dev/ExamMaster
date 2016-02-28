//
//  ExamCreationConfirmationViewController.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

class ExamCreationConfirmationViewController: UIViewController {

  weak var model: ExamCreationConfirmationModel! {
    didSet {
      model.applyRepresentation(self)
      title = model.title
    }
  }
  
  @IBAction
  private func finish(sender: AnyObject?) {
    model.finish()
  }
  
}