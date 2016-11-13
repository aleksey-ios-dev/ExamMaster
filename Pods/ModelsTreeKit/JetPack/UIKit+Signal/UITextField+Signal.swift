//
//  UITextField+Signal.swift
//  SessionSwift
//
//  Created by aleksey on 24.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import UIKit

extension UITextField {
  
  public var textSignal: Observable<String> {
    let textSignal = signalForControlEvents(.EditingChanged).map { ($0 as! UITextField).text ?? "" }
    let textObservable = textSignal.observable()
    textObservable.value = text ?? ""
    let onClearSignal = sig_delegate.clearSignal.map { [weak self] in self?.text ?? "" }.filter { $0 != nil }.map { $0! }
    
    let observable = Observable<String>(text ?? "")
    
    
    Signals.merge([textObservable, onClearSignal]).bindTo(observable)
    
    return observable
  }
  
  public var editingSignal: Observable<Bool> {
    let observable = Signals.merge([editingBeginSignal.map { true }, editingEndSignal.map { false }]).observable()
    observable.value = editing
    
    return observable
  }
  
  public var editingBeginSignal: Pipe<Void> {
    return signalForControlEvents(.EditingDidBegin).map { _ in return Void() } as! Pipe<Void>
  }
  
  public var editingEndSignal: Pipe<Void> {
    return signalForControlEvents(.EditingDidEnd).map { _ in return Void() } as! Pipe<Void>
  }
  
  public var returnSignal: Pipe<Void> {
    return signalForControlEvents([.EditingDidEndOnExit]).map { _ in return Void() } as! Pipe<Void>
  }
  
}

private class TextFieldDelegate: NSObject, UITextFieldDelegate {
  
  let clearSignal = Pipe<Void>()
  
  private static var DelegateHandler: Int = 0
  
  @objc private func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    return true
  }
  
  @objc private func textFieldShouldClear(textField: UITextField) -> Bool {
    dispatch_async(dispatch_get_main_queue()) { self.clearSignal.sendNext() }
    
    return true
  }
  
}

private extension UITextField {
  
  var sig_delegate: TextFieldDelegate {
    var delegate = objc_getAssociatedObject(self, &TextFieldDelegate.DelegateHandler) as? TextFieldDelegate
    if (delegate == nil) {
      delegate = TextFieldDelegate()
      self.delegate = delegate
      objc_setAssociatedObject(self, &TextFieldDelegate.DelegateHandler, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    return delegate!
  }
  
}
