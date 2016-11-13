//
//  ExamOptionsPickerModel.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class ExamOptionsPickerModel: Model {
  
  let timeLimitChangeSignal = Observable<NSTimeInterval>(0)
  let questionsCountChangeSignal = Observable<Int>(0)
  
  private weak var flowModel: ExamCreationFlow!
  
  private var timeLimit: NSTimeInterval = 0 {
    didSet { timeLimitChangeSignal.sendNext(timeLimit) }
  }
  
  private var questionsCount: Int = 0 {
    didSet { questionsCountChangeSignal.sendNext(questionsCount) }
  }
  
  required init(parent: Model?) {
    super.init(parent: parent)
    
    flowModel = parent as! ExamCreationFlow
    applyInitialState()
  }
  
  func applyInitialState() {
    timeLimit = 60
    questionsCount = 30
  }
  
  func applyTimeLimit(limit: NSTimeInterval) {
    timeLimit = floor(limit)
  }
  
  func applyQuestionsCount(count: Int) {
    questionsCount = count
  }
  
  func confirmExamCreation() {
    let options = ExamOptions(timeLimit: timeLimit, questionsCount: questionsCount)
    flowModel.child(self, didConfirmExamCreationWithOptions: options)
  }
  
}