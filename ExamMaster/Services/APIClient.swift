//
//  APIClient.swift
//  ExamMaster
//
//  Created by aleksey on 29.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class APIClient: Service {
  func fetchSubjects(completion: (subjects: [Subject]?, error: Error?) -> Void) -> Void {
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
    
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      completion(subjects: ["Math", "Chemistry", "History"], error: nil)
    }
  }
  
  func fetchTopicsForSubject(subject: Subject, completion: (topics: [Subject]?, error: Error?) -> Void) -> Void {
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
    
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      var topics: [Topic]!
      switch subject {
      case "Math": topics = ["Trigonometry", "Algebra", "Tensor calculus"]
      case "Chemistry": topics = ["Organic", "Inorganic", "Biochemistry"]
      case "History": topics = ["Medieval", "Renaissance", "Modern"]
      default: topics = []
      }
      //let error = Error(domain: NetworkErrorDomain(), code: NetworkErrorDomain.Errors.BadToken)
      let error = Error(domain: NetworkErrorDomain(), code: NetworkErrorDomain.Errors.ResponseError)
      completion(topics: topics, error: error)
    }
  }
}

