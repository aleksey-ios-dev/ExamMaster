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
  
  func showAlertForError(error: Error) {
    let controller = UIAlertController(title: "Error", message: error.localizedDescription(), preferredStyle: .Alert)
    let action = UIAlertAction(title: "ok", style: .Cancel) { _ in
      controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    controller.addAction(action)
    
    presentViewController(controller, animated: true, completion: nil)
  }
  
}