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
  let exam: Exam
  
  private weak var flowModel: ExamCreationFlow!
  
  init(parent: ExamCreationFlow?, exam: Exam) {
    self.exam = exam

    super.init(parent: parent)
    
    flowModel = parent
    
    printSessionTree(withOptions: [.ErrorsVerbous])
  }
  
  func finish() {
    flowModel.childModelDidFinishFlow(self)
  }
}