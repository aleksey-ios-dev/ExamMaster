//
//  ExamCreationFlowModel.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

struct ExamOptions {
  
  var timeLimit: NSTimeInterval
  var questionsCount: Int
  
}

protocol ExamCreationFlowParent {
  
  func childModelDidFinishFlow(child: Model) -> Void
  func childModelDidCancelFlow(child: Model) -> Void
  func child(child: Model, didSelectSubject subject: Subject) -> Void
  func child(child: Model, didSelectTopic topic: Topic) -> Void
  func child(child: Model, didConfirmExamCreationWithOptions options: ExamOptions) -> Void
  
}

class ExamCreationFlowModel: Model {
  
  let cancelSignal = Signal<Void>()
  let completionSignal = Signal<Void>()

  private let exam = Exam()

  override init(parent: Model?) {
    super.init(parent: parent)
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

extension ExamCreationFlowModel: ExamCreationFlowParent {
  
  func childModelDidCancelFlow(child: Model) {
    cancelFlow()
  }
  
  func child(child: Model, didSelectTopic topic: Topic) {
    exam.topic = topic
    pushChildSignal.sendNext(ExamOptionsPickerModel(parent: self))
  }
  
  func child(child: Model, didSelectSubject subject: Subject) {
    exam.subject = subject
    pushChildSignal.sendNext(ExamTopicPickerModel(parent: self, subject: subject))
  }
  
  func child(child: Model, didConfirmExamCreationWithOptions options: ExamOptions) {
    exam.questionsCount = options.questionsCount
    exam.timeLimit = options.timeLimit
    pushChildSignal.sendNext(ExamCreationConfirmationModel(parent: self, exam: exam))
  }
  
  func childModelDidFinishFlow(child: Model) {
    completionSignal.sendCompleted()
    raiseSessionEvent(AppEvent.ExamCreated)
  }
  
}