//
//  MainFlowModel.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class MainFlowModel: Model {
  
  override init(parent: Model?) {
    super.init(parent: parent)
    
    registerForEvent(.StartExam) { [weak self] _ in
      guard let _self = self else { return }
      
      let flowModel = ExamCreationFlowModel(parent: self)
      
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
  
}