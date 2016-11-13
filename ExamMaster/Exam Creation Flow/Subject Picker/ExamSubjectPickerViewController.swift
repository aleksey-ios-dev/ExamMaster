//
//  ExamSubjectPickerViewController.swift
//  ExamMaster
//
//  Created by aleksey on 28.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class ExamSubjectPickerViewController: UITableViewController, ModelApplicable {
  
  weak var model: ExamSubjectPickerModel! {
    didSet {
      title = model.title
      
      model.progressSignal.subscribeNext { inProgress in
        if inProgress { SVProgressHUD.show() }
        else { SVProgressHUD.dismiss() }
      }.ownedBy(self)
    }
  }
  
  private var adapter: TableViewAdapter<String>!
  private var dataSource: UnorderedListDataAdapter<String, String>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = UnorderedListDataAdapter(list: model)
    dataSource.groupContentsSortingCriteria = { $0 < $1 }
    
    adapter = TableViewAdapter(dataSource: dataSource, tableView: tableView)
    adapter.registerCellClass(ItemCell)
    adapter.nibNameForObjectMatching = { _ in return String(ItemCell) }
    
    adapter.didSelectCell.subscribeNext { [ weak self] _, _, subject in
      self?.model.selectSubject(subject)
    }.ownedBy(self)
    
    model.fetchSubjects()
    
  }
  
}