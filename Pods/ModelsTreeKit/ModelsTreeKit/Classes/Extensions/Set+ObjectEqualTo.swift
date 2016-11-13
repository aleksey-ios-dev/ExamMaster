//
//  Set+ObjectEqualTo.swift
//  ModelsTreeDemo
//
//  Created by Aleksey on 15.10.16.
//  Copyright © 2016 Aleksey Chernish. All rights reserved.
//

import Foundation

extension Set where Element: Equatable, Element: Hashable {
  
  func objectEqualTo(object: Element) -> Element? {
    return self.filter { $0 == object }.first
  }
  
}
