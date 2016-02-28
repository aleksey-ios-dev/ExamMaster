//
//  DashboardViewController.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

class DashboardViewController: UIViewController {
  
  weak var model: DashboardModel! {
    didSet {
      model.applyRepresentation(self)
    }
  }
  
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
  
}