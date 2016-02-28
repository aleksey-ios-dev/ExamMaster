//
//  ExamSubjectPickerViewController.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

class ExamSubjectPickerViewController: UITableViewController {
  
  weak var model: ExamSubjectPickerModel! {
    didSet { model.applyRepresentation(self) }
  }
  
}