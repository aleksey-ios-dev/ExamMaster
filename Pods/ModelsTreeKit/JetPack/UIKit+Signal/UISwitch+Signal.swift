//
//  UISwitch+Signal.swift
//  ModelsTreeKit
//
//  Created by aleksey on 06.03.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import UIKit

extension UISwitch {
  
  public var onSignal: Observable<Bool> {
    get {
      let observable = Observable<Bool>(on)
      signalForControlEvents(.ValueChanged).map { ($0 as! UISwitch).on }.bindTo(observable)
      
      return observable
    }
  }
  
}