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
  let progressSignal = Signal<Bool>()
  
  private weak var flowModel: ExamCreationFlowModel!
  
  init(parent: ExamCreationFlowModel) {
    super.init(parent: parent)
    
    flowModel = parent
  }
  
  func cancelFlow() {
    flowModel.childModelDidCancelFlow(self)
  }
  
  func fetchSubjects() {
    progressSignal.sendNext(true)
    let client: APIClient = session()!.services.getService()
    client.fetchSubjects { [ weak self] subjects, error in
      guard let _self = self else { return }
      
      _self.progressSignal.sendNext(false)
      
      guard error == nil else {
        _self.raiseError(error!)
        return
      }
      
      _self.performUpdates { _self.insert(subjects!) }
    }
  }
  
  func selectSubject(subject: String) {
    flowModel.child(self, didSelectSubject: subject)
  }
}