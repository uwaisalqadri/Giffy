//
//  ImageGIFEntity.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation
import RealmSwift

public class ImageGIFEntity: Object, ImageGIF, Codable {
  @objc dynamic public var _original: OriginalEntity?
  public var original: Original {
    _original ?? .init()
  }

  public enum CodingKeys: String, CodingKey {
    case _original = "original"
  }
}

public class OriginalEntity: Object, Original, Codable {
  @objc dynamic public var url: String = ""
  @objc dynamic public var height: String = ""
  @objc dynamic public var width: String = ""

  public enum CodingKeys: String, CodingKey {
    case url
    case height
    case width
  }
}
