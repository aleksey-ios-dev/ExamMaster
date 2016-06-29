//
//  Archivable.swift
//  SessionSwift
//
//  Created by aleksey on 24.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

public typealias ArchivationProxy = [String: AnyObject]

public protocol Archivable {
  
  func archivationProxy() -> [String: AnyObject]
  init(archivationProxy: [String: AnyObject])
  
}