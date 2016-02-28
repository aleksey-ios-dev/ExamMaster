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

class ExamCreationFlowNavigationController: UINavigationController {
  weak var model: ExamCreationFlowModel! {
    didSet {
      model.applyRepresentation(self)
      model.pushChildSignal.subscribeNext { [weak self] child in
        self?.buildRepresentationFor(child)
      }
    }
  }
  
  override func viewDidLoad() {
    model.pushInitialChildren()
  }
  
  func buildRepresentationFor(model: Model) {
    switch model {
    case let model as ExamSubjectPickerModel:
      let controller = ExamSubjectPickerViewController()
      controller.model = model
      applyDefaultNavigationButtonsTo(controller)
      viewControllers = [controller]
      default:
      break
    }
  }
  
  func applyDefaultNavigationButtonsTo(controller: UIViewController) {
    let button = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelFlow:")
    controller.navigationItem.leftBarButtonItem = button
  }
  
  //Actions
  
  @objc
  func cancelFlow(sender: AnyObject?) {
    model.cancelFlow()
  }

}