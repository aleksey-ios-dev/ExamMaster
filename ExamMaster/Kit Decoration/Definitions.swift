//
//  Definitions.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

public enum AppEvent: String, GlobalEventName {
  case StartExam = "StartExam"
  case ExamCreated = "ExamCreated"
}
