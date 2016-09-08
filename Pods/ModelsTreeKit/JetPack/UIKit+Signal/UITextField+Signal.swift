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
    let textSignal = signalForControlEvents(events: .editingChanged).map { ($0 as! UITextField).text! }
    let textObservable = textSignal.observable()
    let onClearSignal = sig_delegate.clearSignal.map { [weak self] in self?.text }.filter { $0 != nil }.map { $0! }
    
    let observable = Observable<String>(value: text)
    Signals.merge([textObservable, onClearSignal]).bindTo(observable: observable)
    
    return observable
  }
  
  public var editingSignal: Observable<Bool> {
    let observable = Observable<Bool>(value: isEditing)
    editingBeginSignal.map { true }.distinctLatest(editingEndSignal.map { true }).map { $0 == true && $1 == nil }.bindTo(observable: observable)
    
    return observable
  }
  
  public var editingBeginSignal: Pipe<Void> {
    return signalForControlEvents(events: .editingDidBegin).map { _ in return Void() } as! Pipe<Void>
  }
  
  public var editingEndSignal: Pipe<Void> {
    return signalForControlEvents(events: .editingDidEnd).map { _ in return Void() } as! Pipe<Void>
  }
  
  public var returnSignal: Pipe<Void> {
    return signalForControlEvents(events: [.editingDidEndOnExit]).map { _ in return Void() } as! Pipe<Void>
  }
  
}

private class TextFieldDelegate: NSObject, UITextFieldDelegate {
 
  let clearSignal = Pipe<Void>()
  
  fileprivate static var DelegateHandler: Int = 0
  
  @objc fileprivate func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return true
  }
  
  @objc fileprivate func textFieldShouldClear(_ textField: UITextField) -> Bool {
    DispatchQueue.main.async {
      self.clearSignal.sendNext()
    }
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
