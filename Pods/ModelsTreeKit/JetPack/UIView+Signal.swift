//
//  UIView+Signal.swift
//  ModelsTreeKit
//
//  Created by aleksey on 06.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import UIKit

public extension UIView {
  
  func hiddenSignal(owner: DeinitObservable? = nil) -> Observable<Bool> {
    var assignedOwner: DeinitObservable! = owner
    if  assignedOwner == nil {
      assignedOwner = superview as! DeinitObservable
    }
    return signalForKeyPath("hidden", owner: assignedOwner).map { $0! } as! Observable<Bool>
  }
  
}