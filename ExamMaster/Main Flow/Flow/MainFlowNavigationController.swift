//
//  MainFlowNavigationController.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import UIKit
import ModelsTreeKit

class MainFlowNavigaionController: RESideMenu {
  
  var model: MainFlowModel! {
    didSet {
      model.applyRepresentation(self)
      model.pushChildSignal.subscribeNext { [weak self] child in
        self?.buildRepresentationFor(child)
        }.putInto(pool)
      model.pushInitialChildren()
    }
  }
  
  override init(contentViewController: UIViewController,
    leftMenuViewController: UIViewController,
    rightMenuViewController: UIViewController) {
      super.init(contentViewController: contentViewController,
        leftMenuViewController: leftMenuViewController,
        rightMenuViewController: rightMenuViewController)
      
//      panGestureEnabled = false
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  func buildRepresentationFor(child: Model) {
    switch child {
      
    case let child as SideMenuModel:
      let controller = MainFlowStoryboard.sideMenuViewController()
      controller.model = child
      leftMenuViewController = controller
      
    case let child as DashboardModel:
      let controller = MainFlowStoryboard.dashboardViewController()
      controller.model = child
      
      contentViewController = controller
      
    default:
      break
    }
  }
  
}

extension MainFlowNavigaionController: ModelAssignable {
  func assignModel(model: Model) {
    if let model = model as? MainFlowModel {
      self.model = model
    }
  }
}

