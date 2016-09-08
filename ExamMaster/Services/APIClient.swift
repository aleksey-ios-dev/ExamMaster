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
  func fetchSubjects(completion: @escaping (_ subjects: [Subject]?, _ error: ModelTreeError?) -> Void) -> Void {
    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
      completion(["Math", "Chemistry", "History", "Physics (for bad response)", "English (for bad token)"], nil)
    })
  }
  
  func fetchTopics(for subject: Subject, completion: @escaping (_ topics: [Subject]?, _ error: ModelTreeError?) -> Void) -> Void {
    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
      var topics: [Topic]!
      var error: ModelTreeError?
      switch subject {
      case "Math": topics = ["Trigonometry", "Algebra", "Tensor calculus"]
      case "Chemistry": topics = ["Organic", "Inorganic", "Biochemistry"]
      case "History": topics = ["Medieval", "Renaissance", "Modern"]
      case "Physics (for bad response)": error = ModelTreeError(code: NetworkError.BadResponse)
      case "English (for bad token)": error = ModelTreeError(code: NetworkError.BadToken)
      default: topics = []
      }
      completion(topics, error)
    })
  }
}

