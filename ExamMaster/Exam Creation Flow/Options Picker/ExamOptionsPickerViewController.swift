//
//  ExamOptionsPickerViewController.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class ExamOptionsPickerViewController: UIViewController, ModelApplicable {
  
  @IBOutlet
  private weak var questionsCountLabel: UILabel!
  
  @IBOutlet
  private weak var timeLimitLabel: UILabel!
  
  @IBOutlet
  private weak var questionsCountSlider: UISlider!
  
  @IBOutlet
  private weak var timeLimitSlider: UISlider!
  
  weak var model: ExamOptionsPickerModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    model.questionsCountChangeSignal.subscribeNext { [weak self] in
      self?.questionsCountLabel.text = "Questions: \($0)"
      self?.questionsCountSlider.value = Float($0)
    }.putInto(pool)
    
    model.timeLimitChangeSignal.subscribeNext { [weak self] in
      self?.timeLimitLabel.text = "Time limit: \(Int($0)) min"
      self?.timeLimitSlider.value = Float($0)
    }.putInto(pool)
  }
  
  @IBAction
  private func changeQuestionsCount(sender: UISlider) {
    model.applyQuestionsCount(Int(sender.value))
  }
  
  @IBAction
  private func changeTimeLimit(sender: UISlider) {
    model.applyTimeLimit(NSTimeInterval(sender.value))
  }
  
  @IBAction
  private func confirm(sender: AnyObject?) {
    model.confirmExamCreation()
  }
  
}