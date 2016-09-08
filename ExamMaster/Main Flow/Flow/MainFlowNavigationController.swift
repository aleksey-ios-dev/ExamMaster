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
  
  var model: MainFlow! {
    didSet {
      model.pushChildSignal.subscribeNext { [weak self] child in
        self?.buildRepresentation(for: child)
        }.owned(by: self)
      
      model.pushInitialChildren()
      
      model.wantsRemoveChildSignal.subscribeNext { [weak self] child in
        self?.removePresentation(for: child)
        }.owned(by: self)
      
      model.showSideMenuSignal.subscribeNext { [weak self] in
        self?.presentLeftMenuViewController()
        }.owned(by: self)
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
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  func removePresentation(for child: Model) {
    switch child {
      
    case child as ExamCreationFlow:
      dismiss(animated: true, completion: nil)
      
    default:
      break
    }
  }

  func buildRepresentation(for model: Model) {
    switch model {
      
    case let model as SideMenuModel:
      let controller = MainFlowStoryboard.sideMenuViewController()
      controller.applyModel(model)
      leftMenuViewController = controller
      
    case let model as DashboardModel:
      let controller = MainFlowStoryboard.dashboardViewController()
      controller.applyModel(model)
      
      contentViewController = controller
      
    case let model as ExamCreationFlow:
      let controller = ExamCreationFlowNavigationController()
      controller.applyModel(model)
      contentViewController.present(controller, animated: true, completion: nil)
      
    default:
      break
    }
  }
  
}

extension MainFlowNavigaionController: RootModelAssignable {
  func assignRootModel(model: Model) {
    if let model = model as? MainFlow {
      self.model = model
    }
  }
}

