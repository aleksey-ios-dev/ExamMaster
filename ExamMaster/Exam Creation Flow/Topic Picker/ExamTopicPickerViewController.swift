//
//  ExamTopicPickerViewController.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

import Foundation
import ModelsTreeKit

class ExamTopicPickerViewController: UITableViewController {
  
  weak var model: ExamTopicPickerModel! {
    didSet {
      model.applyRepresentation(self)
      title = model.title
      
      model.progressSignal.subscribeNext { inProgress in
        if inProgress { SVProgressHUD.show() }
        else { SVProgressHUD.dismiss() }
      }.putInto(pool)
      
      model.errorSignal.subscribeNext { [weak self] error in
        self?.showAlertForError(error)
      }.putInto(pool)
    }
  }
  
  private var adapter: TableViewAdapter<String>!
  private var dataSource: ListDataSource<String, String>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = ListDataSource(list: model)
    adapter = TableViewAdapter(dataSource: dataSource, tableView: tableView)
    
    adapter.registerCellClass(ItemCell)
    adapter.nibNameForObjectMatching = { _ in return String(ItemCell) }
    
    adapter.didSelectCellSignal.subscribeNext { [weak self] _, object in
      self?.model.selectTopic(object!)
    }.putInto(pool)
    
    model.fetchTopics()
  }
  
  func showAlertForError(error: Error) {
    let controller = UIAlertController(title: "Error", message: error.localizedDescription(), preferredStyle: .Alert)
    let action = UIAlertAction(title: "ok", style: .Cancel) { _ in
      controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    controller.addAction(action)
    
    presentViewController(controller, animated: true, completion: nil)
  }
  
}