//
//  Model+Access.swift
//  ModelsTreeDemo
//
//  Created by Aleksey on 28.10.16.
//  Copyright © 2016 Aleksey Chernish. All rights reserved.
//

import Foundation

public extension Model {
  
  func conformingAncestor<T>() -> T? {
    return parent as? T ?? parent?.conformingAncestor()
  }
  
}
