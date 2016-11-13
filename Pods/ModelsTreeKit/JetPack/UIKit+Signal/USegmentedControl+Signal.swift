//
//  USegmentedControl+Signal.swift
//  ModelsTreeKit
//
//  Created by aleksey on 06.03.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import UIKit

extension UISegmentedControl {
  
  public var selectedSegmentIndexSignal: Observable<Int> {
    get {
      let observable = Observable<Int>(selectedSegmentIndex)
      signalForControlEvents(.ValueChanged).map { ($0 as! UISegmentedControl).selectedSegmentIndex }.bindTo(observable)
      
      return observable
    }
  }
  
}