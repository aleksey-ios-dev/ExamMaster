//
//  ExamSubjectPickerModel.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

typealias Subject = String

class ExamSubjectPickerModel: List<String> {
  
  let title = "Subject"
  
  private weak var flowModel: ExamCreationFlowModel!
  
  init(parent: ExamCreationFlowModel) {
    super.init(parent: parent)
    
    flowModel = parent
  }
  
  func cancelFlow() {
    flowModel.childModelDidCancelFlow(self)
  }
  
  func fetchSubjects() {
    performUpdates { insert(["Math", "Chemistry", "History"]) }
  }
  
  func selectSubject(subject: String) {
    flowModel.child(self, didSelectSubject: subject)
  }
}