//
//  TimerAttributes.swift
//  
//
//  Created by Uwais Alqadri on 22/10/23.
//

import ActivityKit
import Foundation

public struct GiphyAttributes: ActivityAttributes {
  public typealias FavoriteState = ContentState
  
  public struct ContentState: Codable & Hashable {
    public var isFavorited: Bool
    
    public init(isFavorited: Bool) {
      self.isFavorited = isFavorited
    }
  }
  
  public var title: String
  
  public init(title: String) {
    self.title = title
  }
}
