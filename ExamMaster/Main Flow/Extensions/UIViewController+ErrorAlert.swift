//
//  UIViewController+ErrorAlert.swift
//  ExamMaster
//
//  Created by aleksey on 20.03.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

extension UIViewController {
  
  func showAlert(for error: Error) {
    let controller = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
    let action = UIAlertAction(title: "ok", style: .cancel) { _ in
      controller.dismiss(animated: true, completion: nil)
    }
    
    controller.addAction(action)
    
    present(controller, animated: true, completion: nil)
  }
  
}
