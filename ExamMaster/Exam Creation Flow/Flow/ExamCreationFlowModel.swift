//
//  ExamCreationFlowModel.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

protocol ExamCreationFlowParent {
  func childModelDidCancelFlow(child: Model) -> Void
  func child(child: Model, didSelectSubject: Subject) -> Void
}

class ExamCreationFlowModel: Model {
  
  
  override init(parent: Model?) {
    super.init(parent: parent)
  }
  let cancelSignal = Signal<Void>()
  
  func pushInitialChildren() {
    pushChildSignal.sendNext(ExamSubjectPickerModel(parent: self))
  }
  
  func cancelFlow() {
    printSessionTree()
    cancelSignal.sendCompleted()
  }
  
}

extension ExamCreationFlowModel: ExamCreationFlowParent {
  
  func childModelDidCancelFlow(child: Model) {
    cancelFlow()
  }
  
  func child(child: Model, didSelectSubject subject: Subject) {
    pushChildSignal.sendNext(ExamTopicPickerModel(parent: self, subject: subject))
  }
}