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
  
  let timeLimitChangeSignal = Observable<TimeInterval>()
  let questionsCountChangeSignal = Observable<Int>()
  
  private weak var flowModel: ExamCreationFlow!
  
  private var timeLimit: TimeInterval = 0 {
    didSet { timeLimitChangeSignal.sendNext(timeLimit) }
  }
  
  private var questionsCount: Int = 0 {
    didSet { questionsCountChangeSignal.sendNext(questionsCount) }
  }
  
  init(parent: ExamCreationFlow?) {
    super.init(parent: parent)
    
    flowModel = parent
    applyInitialState()
  }
  
  func applyInitialState() {
    timeLimit = 60
    questionsCount = 30
  }
  
  func applyTimeLimit(_ limit: TimeInterval) {
    timeLimit = floor(limit)
  }
  
  func applyQuestionsCount(_ count: Int) {
    questionsCount = count
  }
  
  func confirmExamCreation() {
    let options = ExamOptions(timeLimit: timeLimit, questionsCount: questionsCount)
    flowModel.child(self, didConfirmExamCreationWithOptions: options)
  }
  
}
