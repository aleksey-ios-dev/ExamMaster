//
//  DashboardViewController.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class DashboardViewController: UIViewController, ModelApplicable {
  
  weak var model: DashboardModel!
  
  @IBOutlet
  private weak var titleLabel: UILabel!
  
  @IBOutlet
  private weak var control: UISegmentedControl!
  
  @IBOutlet
  private weak var switchControl: UISwitch!
  
  @IBOutlet
  private weak var slider: UISlider!
  
  @IBOutlet
  private weak var stepper: UIStepper!

  
  @IBAction func valCh(sender: AnyObject, forEvent event: UIEvent) {
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    control.selectedSegmentIndexSignal.subscribeNext { print($0) }.putInto(pool)
    switchControl.onSignal.subscribeNext { print($0) }.putInto(pool)

    slider.valueChangeSignal.subscribeNext {
      self.switchControl.enabled = $0 > self.slider.maximumValue / 2
    }.putInto(pool)

    control.selectedSegmentIndexSignal.combineNoNull(switchControl.onSignal).map { $0 == 4 && $1 }.subscribeNext {
      self.control.alpha = $0 ? 1 : 0.5
      print("can do: \($0)")
    }.putInto(pool)
    
    slider.reachMaximumSignal.subscribeNext { print("max: \($0)") }.putInto(pool)
    slider.reachMinimumSignal.subscribeNext { print("min: \($0)") }.putInto(pool)
    
    stepper.valueChangeSignal.subscribeNext { print($0) }
    stepper.reachMaximumSignal.subscribeNext { print("max: \($0)") }.putInto(pool)
    stepper.reachMinimumSignal.subscribeNext { print("min: \($0)") }.putInto(pool)

    titleLabel.text = "Hello, " + model.title + "!"
  }
  
  @IBAction
  private func startNewExam(sender: AnyObject?) {
    model.startNewExam()
  }
  
  @IBAction
  private func showMenu(sender: AnyObject?) {
    model.showMenu()
  }

}