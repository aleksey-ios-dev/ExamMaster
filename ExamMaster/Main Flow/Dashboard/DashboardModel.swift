//
//  DashboardModel.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class DashboardModel: Model {
  
  var title: String {
    return session()!.credentials!.username
  }
  
  func startNewExam() {
    raiseSessionEvent(.StartExam, withObject: nil)
  }
  
}