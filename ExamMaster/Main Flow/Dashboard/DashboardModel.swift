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
  
  let showMenuSignal = Observable<Void>()
  
  var title: String {
    return session.credentials!.username
  }
  
  func startNewExam() {
    raise(AppEvent.StartExam)
  }
  
  func showMenu() {
    raise(BubbleNotification.MainFlow.ShowSideMenu)
  }
  
}
