//
//  DashboardViewController.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class DashboardViewController: UIViewController, ModelApplicable {
  
  weak var model: DashboardModel!
  
  @IBOutlet
  private weak var titleLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleLabel.text = "Hello, " + model.title + "!"
  }
  
  @IBAction
  private func startNewExam(sender: AnyObject?) {
    model.startNewExam()
  }
  
  @IBAction
  private func showMenu(sender: AnyObject?) {
    model.showMenu()
  }

  
}