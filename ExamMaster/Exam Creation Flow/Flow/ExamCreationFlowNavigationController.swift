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
  weak var model: ExamCreationFlow! {
    didSet {
      model.pushChildSignal.subscribeNext { [weak self] child in
        self?.buildRepresentation(for: child)
        }.owned(by: self)
      
      model.errorSignal.subscribeNext { [weak self] error in
        self?.showAlert(for: error)
        }.owned(by: self)
    }
  }
  
  override func viewDidLoad() {
    model.pushInitialChildren()
  }
  
  func buildRepresentation(for model: Model) {
    switch model {
      
    case let model as ExamSubjectPickerModel:
      let controller = ExamSubjectPickerViewController()
      controller.applyModel(model)
      applyDefaultNavigationButtons(to: controller)
      viewControllers = [controller]
      
    case let model as ExamTopicPickerModel:
      let controller = ExamTopicPickerViewController()
      controller.applyModel(model)
      applyDefaultNavigationButtons(to: controller)
      pushViewController(controller, animated: true)
      
    case let model as ExamOptionsPickerModel:
      let controller = ExamCreationFlowStoryboard.optionsViewController()
      controller.applyModel(model)
      applyDefaultNavigationButtons(to: controller)
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
  
  func applyDefaultNavigationButtons(to controller: UIViewController) {
    let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelFlow(sender:)))
    controller.navigationItem.rightBarButtonItem = button
  }
  
  //Actions
  
  @objc
  func cancelFlow(sender: AnyObject?) {
    model.cancelFlow()
  }

}
