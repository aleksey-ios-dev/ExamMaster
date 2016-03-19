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
  
  let showMenuSignal = Signal<Void>()
  
  var title: String {
    return session()!.credentials!.username
  }
  
  func startNewExam() {
    raiseSessionEvent(AppEvent.StartExam)
  }
  
  func showMenu() {
    raiseBubbleNotification(BubbleNotification.MainFlow.ShowSideMenu, domain: BubbleNotification.MainFlow.domain, sender: self)
  }
  
}