//
//  UISearchBar+Signal.swift
//  ModelsTreeKit
//
//  Created by aleksey on 04.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import UIKit

extension UISearchBar {
  
  public func textSignal() -> Observable<String>? {
    for subview in flatSubviews() {
      if let textField = subview as? UITextField {
        return textField.textSignal
      }
    }
    return nil
  }
  
}
