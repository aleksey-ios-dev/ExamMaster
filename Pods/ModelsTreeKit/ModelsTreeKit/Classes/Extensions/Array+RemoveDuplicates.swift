//
//  Array+RemoveDuplicates.swift
//  ModelsTreeDemo
//
//  Created by Aleksey on 15.10.16.
//  Copyright © 2016 Aleksey Chernish. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
  
  func removeDuplicates() -> [Element] {
    return self.reduce([Element]()) { result, element in
      return result.contains(element) ? result : result + [element]
    }
  }
  
}
