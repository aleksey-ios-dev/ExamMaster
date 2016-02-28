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
  
}