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
  
  @IBOutlet
  private weak var examsCreatedLabel: UILabel!
  
  weak var model: SideMenuModel! {
    didSet {
      model.applyRepresentation(self)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    model.examsCountSignal.map { return "Exams created: \($0)" }.subscribeNext { [weak self] in
      self?.examsCreatedLabel.text = $0
    }.putInto(pool)
  }
  
  @IBAction
  private func logout(sender: AnyObject?) {
    model.logout()
  }
  
  @IBAction
  private func startNewExam(sender: AnyObject?) {
    model.startNewExam()
  }
  
}