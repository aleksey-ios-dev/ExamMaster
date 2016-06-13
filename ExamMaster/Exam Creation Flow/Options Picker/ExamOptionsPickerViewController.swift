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
  private weak var switch1: UISwitch!
  
  @IBOutlet
  private weak var switch2: UISwitch!

  @IBOutlet
  private weak var timeLimitSlider: UISlider!
  
  @IBOutlet
  private weak var boundLabel: UILabel!
  
  weak var model: ExamOptionsPickerModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    (switch1.onSignal && switch2.onSignal).map { $0 ? "ON" : "OFF" }.bindTo(keyPath: "text", of: boundLabel)
    
    boundLabel.hiddenSignal.subscribeNext { print($0) }.ownedBy(self)
    
    model.questionsCountChangeSignal.subscribeNext { [weak self] in
      self?.questionsCountLabel.text = "Questions: \($0)"
      self?.questionsCountSlider.value = Float($0)
    }.ownedBy(self)
    
    model.timeLimitChangeSignal.subscribeNext { [weak self] in
      self?.timeLimitLabel.text = "Time limit: \(Int($0)) min"
      self?.timeLimitSlider.value = Float($0)
    }.ownedBy(self)
    
    questionsCountSlider.valueSignal.map { Int($0) }.subscribeNext { [weak self] in
      self?.model.applyQuestionsCount($0)
    }.ownedBy(self)
    
    timeLimitSlider.valueSignal.map { NSTimeInterval($0) }.subscribeNext { [weak self] in
      self?.model.applyTimeLimit($0)
    }.ownedBy(self)
  }
  
  @IBAction
  private func confirm(sender: AnyObject?) {
    model.confirmExamCreation()
  }
  
}