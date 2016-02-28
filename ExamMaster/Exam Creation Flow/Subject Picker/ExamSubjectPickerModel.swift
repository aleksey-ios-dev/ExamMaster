//
//  ExamSubjectPickerModel.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class ExamSubjectPickerModel: Model {
  
  let title = "Pick subject"
  
  private weak var flowModel: ExamCreationFlowModel!
  
  init(parent: ExamCreationFlowModel) {
    super.init(parent: parent)
    
    flowModel = parent
  }
  
  func cancelFlow() {
    flowModel.childModelDidCancelFlow(self)
  }
}