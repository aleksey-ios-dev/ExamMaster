//
//  UIView+FlatSubviews.swift
//  ModelsTreeDemo
//
//  Created by Aleksey on 24.10.16.
//  Copyright © 2016 Aleksey Chernish. All rights reserved.
//

import UIKit

extension UIView {
  
  func flatSubviews() -> [UIView] {
    var flatSubviews = [UIView]()
    
    subviews.forEach {
      flatSubviews.append($0)
      flatSubviews.appendContentsOf($0.flatSubviews())
    }
    
    return flatSubviews
  }
  
}
