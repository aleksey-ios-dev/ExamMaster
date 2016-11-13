//
//  TableViewBehavior.swift
//  ModelsTreeDemo
//
//  Created by Aleksey on 04.11.16.
//  Copyright © 2016 Aleksey Chernish. All rights reserved.
//

import Foundation

public protocol TableViewBehavior: UITableViewDelegate {
  
  weak var tableView: UITableView! { get set }
  
  func cellHeightCalculationUserInfo(forCellAtIndexPath indexPath: NSIndexPath) -> [String: AnyObject]
  func sectionHeaderHeightCalculationUserInfo(forHeaderAtIndex section: Int) -> [String: AnyObject]
  func sectionFooterHeightCalculationUserInfo(forFooterAtIndex section: Int) -> [String: AnyObject]
  
}

public extension TableViewBehavior {
  
  func cellHeightCalculationUserInfo(forCellAtIndexPath indexPath: NSIndexPath) -> [String: AnyObject] {
    return [:]
  }
  
  func sectionHeaderHeightCalculationUserInfo(forHeaderAtIndex section: Int) -> [String: AnyObject] {
    return [:]
  }
  
  func sectionFooterHeightCalculationUserInfo(forFooterAtIndex section: Int) -> [String: AnyObject] {
    return [:]
  }

}
