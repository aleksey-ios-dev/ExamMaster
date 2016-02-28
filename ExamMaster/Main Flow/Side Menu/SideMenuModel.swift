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
  
  let examsCountSignal = Signal<Int>()
  
  private var examsCount = 0 {
    didSet { examsCountSignal.sendNext(examsCount) }
  }
  
  override init(parent: Model?) {
    super.init(parent: parent)
    registerForEvent(SessionEvent(name: AppEvent.ExamCreated)) { [weak self] _ in self?.examsCount++ }
    applyInitialState()
  }
  
  private func applyInitialState() {
    examsCount = 0
  }
  
  func logout() {
    session()?.closeWithParams(nil)
  }
  
  func startNewExam() {
    raiseSessionEvent(SessionEvent(name: AppEvent.StartExam), withObject: nil)
  }
  
}