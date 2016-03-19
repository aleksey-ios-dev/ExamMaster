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
  
  enum MainFlow {
    private static var domain = "MainFlow"
    
    static var ShowSideMenu: BubbleNotification {
      return BubbleNotification(code: MainFlowCodes.ShowSideMenu.rawValue, domain: domain)
    }
  }
  
  enum MainFlowCodes: Int {
    case ShowSideMenu
  }
  
}

class MainFlowModel: Model {
  
  let showSideMenuSignal = Signal<Void>()
  
  override init(parent: Model?) {
    super.init(parent: parent)
    
    registerForBubbleNotification(BubbleNotification.MainFlow.ShowSideMenu)
    
    registerForEvent(AppEvent.StartExam)
  }
  
  override func handleSessionEvent(event: SessionEvent) {
    switch event.name {
    case AppEvent.StartExam:
      let flowModel = ExamCreationFlowModel(parent: self)
      
      flowModel.completionSignal.subscribeCompleted { [weak self] _ in
        self?.wantsRemoveChildSignal.sendNext(flowModel)
        }.putInto(pool)
      
      flowModel.cancelSignal.subscribeCompleted { [weak self] _ in
        self?.wantsRemoveChildSignal.sendNext(flowModel)
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
    
    switch bubble.code {
    case BubbleNotification.MainFlowCodes.ShowSideMenu.rawValue:
      showSideMenuSignal.sendNext()
    default:
      break
    }
  }
  
}