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
  private weak var someSwitch: UISwitch!

  @IBOutlet
  private weak var timeLimitSlider: UISlider!
  
  @IBOutlet
  private weak var boundLabel: UILabel!
  
  weak var model: ExamOptionsPickerModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    someSwitch.onSignal.map { $0 ? "hello" : "goodbye" }.bindTo(keyPath: "text", of: boundLabel).ownedBy(self)
    
    someSwitch.onSignal.subscribeWithOptions([.New, .Old, .Initial]) { new, old, initial in
      print("new: \(new), old: \(old), initial: \(initial)")
    }.ownedBy(self)
    
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