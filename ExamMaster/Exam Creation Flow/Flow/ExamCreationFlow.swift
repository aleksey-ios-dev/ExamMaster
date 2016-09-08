//
//  ExamCreationFlow.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

struct ExamOptions {
  
  var timeLimit: TimeInterval
  var questionsCount: Int
  
}

protocol ExamCreationFlowParent {
  
  func childModelDidFinishFlow(_ child: Model) -> Void
  func childModelDidCancelFlow(_ child: Model) -> Void
  func child(_ child: Model, didSelectSubject subject: Subject) -> Void
  func child(_ child: Model, didSelectTopic topic: Topic) -> Void
  func child(_ child: Model, didConfirmExamCreationWithOptions options: ExamOptions) -> Void
  
}

class ExamCreationFlow: Model {
  
  let cancelSignal = Observable<Int>() //TODO: Pipe
  let completionSignal = Observable<Int>() //TODO: Pipe

  fileprivate let exam = Exam()

  override init(parent: Model?) {
    super.init(parent: parent)
    
    register(for: NetworkError.BadResponse)
  }
  
  override func sessionWillClose() {
    super.sessionWillClose()
    
    cancelSignal.sendCompleted()
  }
  
  func pushInitialChildren() {
    pushChildSignal.sendNext(ExamSubjectPickerModel(parent: self))
  }
  
  func cancelFlow() {
    cancelSignal.sendCompleted()
  }
  
}

extension ExamCreationFlow: ExamCreationFlowParent {
  
  func childModelDidCancelFlow(_ child: Model) {
    cancelFlow()
  }
  
  func child(_ child: Model, didSelectTopic topic: Topic) {
    exam.topic = topic
    pushChildSignal.sendNext(ExamOptionsPickerModel(parent: self))
  }
  
  func child(_ child: Model, didSelectSubject subject: Subject) {
    exam.subject = subject
    pushChildSignal.sendNext(ExamTopicPickerModel(parent: self, subject: subject))
  }
  
  func child(_ child: Model, didConfirmExamCreationWithOptions options: ExamOptions) {
    exam.questionsCount = options.questionsCount
    exam.timeLimit = options.timeLimit
    pushChildSignal.sendNext(ExamCreationConfirmationModel(parent: self, exam: exam))
  }
  
  func childModelDidFinishFlow(_ child: Model) {
    completionSignal.sendCompleted()
    raise(AppEvent.ExamCreated as! BubbleNotificationName)
  }
  
}
