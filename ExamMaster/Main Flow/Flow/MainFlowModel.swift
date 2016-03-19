//
//  MainFlowModel.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

extension BubbleNotification {
  
  enum MainFlow: String, BubbleNotificationName {
    static var domain = "MainFlow"

    case ShowSideMenu = "ShowSideMenu"
  }
  
}

class MainFlowModel: Model {
  
  let showSideMenuSignal = Signal<Void>()
  
  override init(parent: Model?) {
    super.init(parent: parent)
    
    registerForBubbleNotification(BubbleNotification.MainFlow.ShowSideMenu, inDomain: BubbleNotification.MainFlow.domain)
    registerForEvent(AppEvent.StartExam)
  }
  
  override func handleSessionEvent(event: SessionEvent) {
    switch event.name {
    case AppEvent.StartExam:
      let flowModel = ExamCreationFlowModel(parent: self)
      
      flowModel.completionSignal.subscribeCompleted { [weak self, weak flowModel] _ in
        guard let _self = self, _flowModel = flowModel else { return }
        _self.wantsRemoveChildSignal.sendNext(_flowModel)
      }.putInto(pool)
      
      flowModel.cancelSignal.subscribeCompleted { [weak self, weak flowModel] _ in
        guard let _self = self, _flowModel = flowModel else { return }
        _self.wantsRemoveChildSignal.sendNext(_flowModel)
      }.putInto(pool)
      
      pushChildSignal.sendNext(flowModel)
    default:
      break
    }
  }
  
  func pushInitialChildren() {
    pushChildSignal.sendNext(DashboardModel(parent: self))
    pushChildSignal.sendNext(SideMenuModel(parent: self))
  }
  
  override func handleBubbleNotification(bubble: BubbleNotification, sender: Model) {
    guard bubble.domain == BubbleNotification.MainFlow.domain else { return }
    
    switch bubble.name {
    case BubbleNotification.MainFlow.ShowSideMenu:
      showSideMenuSignal.sendNext()
    default:
      break
    }
  }
  
}