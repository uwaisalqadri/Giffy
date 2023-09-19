//
//  Config.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation

struct Config {
  static let baseUrl = "https://api.giphy.com/v1/gifs/"
  
  static var apiKey: String {
    guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
      fatalError("Couldn't find file 'Info.plist'.")
    }
    
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
      fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
    }
    return value
  }
  
}
