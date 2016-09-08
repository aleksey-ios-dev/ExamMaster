//
//  TableViewAdapter.swift
//  SessionSwift
//
//  Created by aleksey on 18.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation
import UIKit

public class TableViewAdapter<ObjectType>: NSObject, UITableViewDataSource, UITableViewDelegate {
  
  typealias DataSourceType = ObjectsDataSource<ObjectType>
  
  public var nibNameForObjectMatching: ((ObjectType) -> String)!
  
  public let didSelectCellSignal = Pipe<(cell: UITableViewCell?, object: ObjectType?)>()
  public let willDisplayCellSignal = Pipe<UITableViewCell>()
  public let didEndDisplayingCellSignal = Pipe<UITableViewCell>()
  public let willSetObjectSignal = Pipe<UITableViewCell>()
  public let didSetObjectSignal = Pipe<UITableViewCell>()
  
  private weak var tableView: UITableView!
  private var nibs = [String: UINib]()
  private var dataSource: ObjectsDataSource<ObjectType>!
  private var instances = [String: UITableViewCell]()
  private var identifiersForIndexPaths = [NSIndexPath: String]()
  private var mappings: [String: (ObjectType, UITableViewCell, NSIndexPath) -> Void] = [:]
  
  public init(dataSource: ObjectsDataSource<ObjectType>, tableView: UITableView) {
    super.init()
    
    self.tableView = tableView
    tableView.dataSource = self
    tableView.delegate = self
    
    self.dataSource = dataSource
    
    dataSource.beginUpdatesSignal.subscribeNext { [weak self] in
      self?.tableView.beginUpdates()
      }.put(into: pool)
    
    dataSource.endUpdatesSignal.subscribeNext { [weak self] in
      self?.tableView.endUpdates()
      }.put(into: pool)
    
    dataSource.reloadDataSignal.subscribeNext { [weak self] in
      guard let strongSelf = self else { return }
      UIView.animate(withDuration: 0.1, animations: {
        strongSelf.tableView.alpha = 0},
                     completion: { completed in
                      strongSelf.tableView.reloadData()
                      UIView.animate(withDuration: 0.2, animations: {
                        strongSelf.tableView.alpha = 1
                      })
      })
      }.put(into: pool)
    
    dataSource.didChangeObjectSignal.subscribeNext { [weak self] object, changeType, fromIndexPath, toIndexPath in
      guard let strongSelf = self else { return }
      switch changeType {
      case .Insertion:
        if let toIndexPath = toIndexPath {
          strongSelf.tableView.insertRows(at: [toIndexPath as IndexPath],
                                          with: .fade)
        }
      case .Deletion:
        if let fromIndexPath = fromIndexPath {
          strongSelf.tableView.deleteRows(at: [fromIndexPath as IndexPath],
                                          with: .fade)
        }
      case .Update:
        if let indexPath = toIndexPath {
          strongSelf.tableView.reloadRows(at: [indexPath as IndexPath],
                                          with: .fade)
        }
      case .Move:
        if let fromIndexPath = fromIndexPath, let toIndexPath = toIndexPath {
          strongSelf.tableView.moveRow(at: fromIndexPath as IndexPath,
                                       to: toIndexPath as IndexPath)
        }
      }
      }.put(into: pool)
    
    dataSource.didChangeSectionSignal.subscribeNext { [weak self] changeType, fromIndex, toIndex in
      guard let strongSelf = self else { return }
      switch changeType {
      case .Insertion:
        if let toIndex = toIndex {
          strongSelf.tableView.insertSections(NSIndexSet(index: toIndex) as IndexSet,
                                              with: .fade)
        }
      case .Deletion:
        if let fromIndex = fromIndex {
          strongSelf.tableView.deleteSections(NSIndexSet(index: fromIndex) as IndexSet,
                                              with: .fade)
        }
      default:
        break
      }
      }.put(into: pool)
  }
  
  public func registerCellClass<U: ObjectConsuming>(_ cellClass: U.Type) where U.ObjectType == ObjectType {
    let identifier = String(describing: cellClass)
    let nib = UINib(nibName: identifier, bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: identifier)
    instances[identifier] = nib.instantiate(withOwner: self, options: nil).last as? UITableViewCell
    
    mappings[identifier] = { object, cell, _ in
      if let consumer = cell as? U { consumer.applyObject(object: object) }
    }
  }
  
  //UITableViewDataSource
  
  @objc
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.numberOfObjects(inSection: section)
  }
  
  @objc
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let object = dataSource.object(at: indexPath)
    let identifier = nibNameForObjectMatching(object)
    var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
    identifiersForIndexPaths[indexPath as NSIndexPath] = identifier
    
    if cell == nil {
      cell = (nibs[identifier]!.instantiate(withOwner: nil, options: nil).last as! UITableViewCell)
    }
    
    willSetObjectSignal.sendNext(cell!)
    
    let mapping = mappings[identifier]!
    mapping(object, cell!, indexPath as NSIndexPath)
    
    didSetObjectSignal.sendNext(cell!)
    
    return cell!
  }
  
  @objc
  public func numberOfSections(in tableView: UITableView) -> Int {
    return dataSource.numberOfSections()
  }
  
  // UITableViewDelegate
  
  @objc
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let object = dataSource.object(at: indexPath)
    let identifier = nibNameForObjectMatching(object)
    if let cell = instances[identifier] as? HeightCalculatingCell {
      return cell.height(for: object, width: tableView.frame.size.width)
    }
    return UITableViewAutomaticDimension;
  }
  
  @objc
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    didSelectCellSignal.sendNext((cell: tableView.cellForRow(at: indexPath as IndexPath),
                                  object: dataSource.object(at: indexPath)))
    tableView.deselectRow(at: indexPath as IndexPath, animated: true)
  }
  
  @objc
  public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    willDisplayCellSignal.sendNext(cell)
  }
  
  
  public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    didEndDisplayingCellSignal.sendNext(cell)
  }
  
}
