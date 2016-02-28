//
//  ExamCreationConfirmationModel.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class ExamCreationConfirmationModel: Model {
  
  let title = "Done!"
  
  private weak var flowModel: ExamCreationFlowModel!
  private let exam: Exam
  
  init(parent: ExamCreationFlowModel?, exam: Exam) {
    self.exam = exam

    super.init(parent: parent)
    
    flowModel = parent
  }
  
  func finish() {
    flowModel.childModelDidFinishFlow(self)
  }
}