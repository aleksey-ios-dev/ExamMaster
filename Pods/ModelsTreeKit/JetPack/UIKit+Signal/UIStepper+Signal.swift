//
//  UIStepper+Signal.swift
//  ModelsTreeKit
//
//  Created by aleksey on 06.03.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import UIKit

extension UIStepper {
  
  public var valueSignal: Observable<Double> {
    get {
      let observable = Observable<Double>(value: value)
      signalForControlEvents(events: .valueChanged).map { ($0 as! UIStepper).value }.bindTo(observable: observable)
      
      return observable
    }
  }
  
  public var isAtMaximumSignal: Observable<Bool> {
    get {
      let observable = Observable<Bool>(value: value == maximumValue)
      valueSignal.filter { [weak self] in return self!.maximumValue == $0 }.map { _ in return true}.bindTo(observable: observable)
      
      return observable
    }
  }
  
  public var isAtMinimumSignal: Observable<Bool> {
    get {
      let observable = Observable<Bool>(value: value == minimumValue)
      valueSignal.filter { [weak self] in return self!.minimumValue == $0 }.map { _ in return true}.bindTo(observable: observable)
      
      return observable
    }
  }
  
}
