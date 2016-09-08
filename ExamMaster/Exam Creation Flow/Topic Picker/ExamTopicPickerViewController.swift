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

class ExamTopicPickerViewController: UITableViewController, ModelApplicable {
  
  weak var model: ExamTopicPickerModel! {
    didSet {
      title = model.title
      
      model.progressSignal.subscribeNext { inProgress in
        if inProgress { SVProgressHUD.show() }
        else { SVProgressHUD.dismiss() }
        }.owned(by: self)
    }
  }
  
  private var adapter: TableViewAdapter<String>!
  private var dataSource: ListDataSource<String, String>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = ListDataSource(list: model)
    adapter = TableViewAdapter(dataSource: dataSource, tableView: tableView)
    
    adapter.registerCellClass(ItemCell.self)
    adapter.nibNameForObjectMatching = { _ in return String(describing: ItemCell.self) }
    
    adapter.didSelectCellSignal.subscribeNext { [weak self] _, object in
      self?.model.select(topic: object!)
      }.owned(by: self)
    
    model.fetchTopics()
  }
  
}
