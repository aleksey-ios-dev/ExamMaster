//
// Created by aleksey on 05.11.15.
// Copyright (c) 2015 aleksey chernish. All rights reserved.
//

import Foundation

public struct StaticObjectsSection<U> {
  
  var title: String?
  var objects: [U]
  
  public init(title: String?, objects: [U]) {
    self.title = title
    self.objects = objects
  }
  
}

public class StaticDataSource<ObjectType> : ObjectsDataSource<ObjectType> {
  
  public override init() { }
  
  public var sections: [StaticObjectsSection<ObjectType>] = [] {
    didSet { reloadDataSignal.sendNext() }
  }
  
  override func numberOfSections() -> Int {
    return sections.count
  }
  
  override func numberOfObjects(inSection section: Int) -> Int {
    return sections[section].objects.count
  }
  
  override func object(at indexPath: IndexPath) -> ObjectType {
    return sections[indexPath.section].objects[indexPath.row]
  }
  
}
