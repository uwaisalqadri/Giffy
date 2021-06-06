//
//  FavGiphyObject.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 01/06/21.
//

import Foundation
import RealmSwift

public class FavGiphyObject: Object {
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

  public override class func primaryKey() -> String? {
    return "id"
  }
}
