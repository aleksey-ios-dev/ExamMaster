//
//  SideMenuModel.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class SideMenuModel: Model {
  func logout() {
    session()?.closeWithParams(nil)
  }
}