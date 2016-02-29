//
//  ExamTopicPickerModel.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

typealias Topic = String

class ExamTopicPickerModel: List<Topic> {
  
  let title = "Topic"
  let progressSignal = Signal<Bool>()
  
  private weak var flowModel: ExamCreationFlowModel!
  private let subject: Subject
  
  init(parent: ExamCreationFlowModel, subject: Subject) {
    self.subject = subject
    super.init(parent: parent)
    self.flowModel = parent
    
    registerForError(Error(domain: NetworkErrorDomain(), code: NetworkErrorDomain.Errors.ResponseError))
  }
  
  //Actions
  
  func fetchTopics() {
    progressSignal.sendNext(true)
    let client: APIClient = session()!.services.getService()
    client.fetchTopicsForSubject(subject) { [ weak self] topics, error in
      guard let _self = self else { return }
      
      _self.progressSignal.sendNext(false)
      
      guard error == nil else {
        _self.raiseError(error!)
        return
      }
      
      _self.performUpdates { _self.insert(topics!) }
    }
  }
  
  func selectTopic(topic: Topic) {
    flowModel.child(self, didSelectTopic: topic)
  }
}