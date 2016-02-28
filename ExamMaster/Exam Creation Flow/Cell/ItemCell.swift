//
//  ItemCell.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class ItemCell: UITableViewCell, ObjectConsuming {
  var object: String?
  
  func applyObject(object: String) {
    textLabel?.text = object
  }
}