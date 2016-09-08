//
//  MainFlowStoryboard.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import UIKit

class MainFlowStoryboard: UIStoryboard {
  
  class func sideMenuViewController() -> SideMenuViewController {
    return storyboard.instantiateViewController(withIdentifier: "SideMenu") as! SideMenuViewController
  }
  
  class func dashboardViewController() -> DashboardViewController {
    return storyboard.instantiateViewController(withIdentifier: "Dashboard") as! DashboardViewController
  }
  
  static var storyboard: UIStoryboard {
    return UIStoryboard(name: "MainFlow", bundle: nil)
  }
  
}
