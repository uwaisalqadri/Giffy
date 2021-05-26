//
//  GiphyObject.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 25/05/21.
//

import Foundation
import RealmSwift


class GiphyObject: Object {
  @objc dynamic var type: String = ""
  @objc dynamic var id: String = ""
  @objc dynamic var url: String = ""
  @objc dynamic var embedUrl: String = ""
  @objc dynamic var rating: String = ""
  @objc dynamic var username: String = ""
  @objc dynamic var title: String = ""
  @objc dynamic var trendingDateTime: String = ""
  @objc dynamic var imageUrl: String = ""
  @objc dynamic var height: String = ""
  @objc dynamic var width: String = ""
  @objc dynamic var favorite: Bool = false

  override class func primaryKey() -> String? {
    return "id"
  }
}
