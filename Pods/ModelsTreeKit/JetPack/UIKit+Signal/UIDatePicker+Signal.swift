//
//  UIDatePicker+Signal.swift
//  ModelsTreeDemo
//
//  Created by Aleksey on 19.10.16.
//  Copyright © 2016 Aleksey Chernish. All rights reserved.
//

import UIKit

extension UIDatePicker {
  
  public var dateSignal: Observable<NSDate> {
    get {
      let observable = Observable<NSDate>(date)
      signalForControlEvents(.ValueChanged).map { ($0 as! UIDatePicker).date }.bindTo(observable)
      
      return observable
    }
  }
  
}
