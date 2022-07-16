//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 7/16/22.
//

import Foundation
import RealmSwift

extension RealmSwift.List where Element: Decodable {
  public convenience init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.singleValueContainer()
    let decodedElements = try container.decode([Element].self)
    self.append(objectsIn: decodedElements)
  }
}

extension RealmSwift.List where Element: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.map { $0 })
  }
}
