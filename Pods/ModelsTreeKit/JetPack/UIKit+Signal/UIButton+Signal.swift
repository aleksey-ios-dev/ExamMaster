//
//  UIButton+Signal.swift
//  ModelsTreeKit
//
//  Created by aleksey on 13.03.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import UIKit

extension UIButton {
  
  public var selectionSignal: Pipe<Void> {
    get { return signalForControlEvents(.TouchUpInside).map { _ in return Void() } as! Pipe<Void> }
  }
  
//  public var enabledSignal: Observable<Bool> {
//    get { return signalForKeyPath("enabled").map { $0! } as! Observable<Bool> }
//  }

}