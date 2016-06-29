//
//  DeinitObservable.swift
//  ModelsTreeKit
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

public protocol DeinitObservable: class {
  
  var deinitSignal: Pipe<Void> { get }
  
}