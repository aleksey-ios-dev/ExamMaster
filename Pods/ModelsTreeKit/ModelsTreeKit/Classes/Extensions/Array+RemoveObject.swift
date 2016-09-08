//
// Created by aleksey on 05.11.15.
// Copyright (c) 2015 aleksey chernish. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
  
  mutating func remove(_ element: Element) {
    if let index = self.index(of: element) {
      self.remove(at: index)
    }
  }
  
}
