//
//  Dictionary+Join.swift
//  ModelsTreeDemo
//
//  Created by Aleksey on 04.11.16.
//  Copyright © 2016 Aleksey Chernish. All rights reserved.
//

import Foundation

extension Dictionary {
  
  mutating func append(anotherDictionary: Dictionary<Key, Value>) -> Dictionary<Key, Value> {
    for (key, value) in anotherDictionary {
      self[key] = value
    }
    
    return self
  }
  
}
