//
//  TestCell.swift
//  ModelsTreeDemo
//
//  Created by Aleksey on 15.10.16.
//  Copyright © 2016 Aleksey Chernish. All rights reserved.
//

import UIKit

class TestCell: UITableViewCell, ObjectConsuming {
  
  func applyObject(object: Int) {
    textLabel?.text = String(object)
  }
  
}
