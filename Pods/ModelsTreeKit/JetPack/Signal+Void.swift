//
//  Signal+Void.swift
//  ModelsTreeKit
//
//  Created by aleksey on 05.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

public extension Signal {
  
  func void() -> Pipe<Void> {
    return pipe().map { _ in return Void() } as! Pipe<Void>
  }
  
}