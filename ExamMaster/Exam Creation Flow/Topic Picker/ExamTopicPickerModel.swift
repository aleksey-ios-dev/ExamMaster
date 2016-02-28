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
  
  private weak var flowModel: ExamCreationFlowModel!
  private let subject: Subject
  
  init(parent: ExamCreationFlowModel, subject: Subject) {
    self.subject = subject
    super.init(parent: parent)
    self.flowModel = parent
  }
  
  func fetchTopics() {
    var result: [String]!

    switch subject {
      case "Math": result = ["Trigonometry", "Algebra", "Tensor calculus"]
      case "Chemistry": result = ["Organic", "Inorganic", "Biochemistry"]
      case "History": result = ["Medieval", "Renaissance", "Modern"]
      default: result = []
    }
    performUpdates { insert(result) }
  }
  
  func selectTopic(topic: Topic) {
    flowModel.child(self, didSelectTopic: topic)
  }
}