//
//  ExamCreationFlowNavigationController.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import UIKit
import ModelsTreeKit

class ExamCreationFlowNavigationController: UINavigationController, ModelApplicable {
  weak var model: ExamCreationFlowModel! {
    didSet {
      model.pushChildSignal.subscribeNext { [weak self] child in
        self?.buildRepresentationFor(child)
      }.putInto(pool)
    }
  }
  
  override func viewDidLoad() {
    model.pushInitialChildren()
  }
  
  func buildRepresentationFor(model: Model) {
    switch model {
      
    case let model as ExamSubjectPickerModel:
      let controller = ExamSubjectPickerViewController()
      controller.applyModel(model)
      applyDefaultNavigationButtonsTo(controller)
      viewControllers = [controller]
      
    case let model as ExamTopicPickerModel:
      let controller = ExamTopicPickerViewController()
      controller.applyModel(model)
      applyDefaultNavigationButtonsTo(controller)
      pushViewController(controller, animated: true)
      
    case let model as ExamOptionsPickerModel:
      let controller = ExamCreationFlowStoryboard.optionsViewController()
      controller.applyModel(model)
      applyDefaultNavigationButtonsTo(controller)
      pushViewController(controller, animated: true)
      
    case let model as ExamCreationConfirmationModel:
      let controller = ExamCreationFlowStoryboard.confirmationViewController()
      controller.applyModel(model)
      controller.navigationItem.hidesBackButton = true
      pushViewController(controller, animated: true)
      
    default:
      break
    }
  }
  
  func applyDefaultNavigationButtonsTo(controller: UIViewController) {
    let button = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelFlow:")
    controller.navigationItem.rightBarButtonItem = button
  }
  
  //Actions
  
  @objc
  func cancelFlow(sender: AnyObject?) {
    model.cancelFlow()
  }

}