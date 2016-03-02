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
      model.pushChildSignal.subscribeNext { [weak self] child in
        self?.buildRepresentationFor(child)
      }.putInto(pool)
      
      model.pushInitialChildren()
      
      model.wantsRemoveChildSignal.subscribeNext { [weak self] child in
        self?.removePresentationFor(child)
      }.putInto(pool)
      
      model.showSideMenuSignal.subscribeNext { [weak self] in
        self?.presentLeftMenuViewController()
      }.putInto(pool)
    }
  }
  
  override init(contentViewController: UIViewController,
    leftMenuViewController: UIViewController,
    rightMenuViewController: UIViewController) {
      super.init(contentViewController: contentViewController,
        leftMenuViewController: leftMenuViewController,
        rightMenuViewController: rightMenuViewController)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  func removePresentationFor(child: Model) {
    switch child {
      
    case child as ExamCreationFlowModel:
      dismissViewControllerAnimated(true, completion: nil)
      
    default:
      break
    }
  }

  func buildRepresentationFor(model: Model) {
    switch model {
      
    case let model as SideMenuModel:
      let controller = MainFlowStoryboard.sideMenuViewController()
      controller.applyModel(model)
      leftMenuViewController = controller
      
    case let model as DashboardModel:
      let controller = MainFlowStoryboard.dashboardViewController()
      controller.applyModel(model)
      
      contentViewController = controller
      
    case let model as ExamCreationFlowModel:
      let controller = ExamCreationFlowNavigationController()
      controller.applyModel(model)
      contentViewController.presentViewController(controller, animated: true, completion: nil)
      
    default:
      break
    }
  }
  
}

extension MainFlowNavigaionController: RootModelAssignable {
  func assignRootModel(model: Model) {
    if let model = model as? MainFlowModel {
      self.model = model
    }
  }
}

