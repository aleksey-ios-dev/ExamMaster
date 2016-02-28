//
//  MainFlowModel.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

extension Bubble { //TODO remove
  
  enum MainFlow {
    private static var domain = "MainFlow"
    
    static var ShowSideMenu: Bubble {
      return Bubble(code: MainFlowCodes.ShowSideMenu.rawValue, domain: domain)
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
    
    registerForBubbleNotification(Bubble.MainFlow.ShowSideMenu)
  
    registerForEvent(.StartExam) { [weak self] _ in
      guard let _self = self else { return }
      
      let flowModel = ExamCreationFlowModel(parent: self)
      
      flowModel.completionSignal.subscribeCompleted { _ in
        _self.removeChildSignal.sendNext(flowModel)
        }.putInto(_self.pool)
      
      flowModel.cancelSignal.subscribeCompleted { _ in
        _self.removeChildSignal.sendNext(flowModel)
      }.putInto(_self.pool)
      
      _self.pushChildSignal.sendNext(flowModel)
    }
  }
  
  func pushInitialChildren() {
    pushChildSignal.sendNext(DashboardModel(parent: self))
    pushChildSignal.sendNext(SideMenuModel(parent: self))
    
    printSessionTree()
  }
  
  override func handleBubbleNotification(bubble: Bubble, sender: Model) {
    guard bubble.domain == Bubble.MainFlow.domain else { return }
    
    switch bubble.code {
    case Bubble.MainFlowCodes.ShowSideMenu.rawValue:
      showSideMenuSignal.sendNext()
    default:
      break
    }
  }
  
}