//
//  Config.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation

struct APIConfig {
  static let giphyBaseUrl = "https://api.giphy.com/v1/gifs/"
  static let tenorBaseUrl = "https://g.tenor.com/v1/"

  static var giphyApiKey: String {
    let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")!
    let plist = NSDictionary(contentsOfFile: filePath)
    let value = plist?.object(forKey: "GPHYApiKey") as! String
    return value
  }
  
  static var tenorApiKey: String {
    let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")!
    let plist = NSDictionary(contentsOfFile: filePath)
    let value = plist?.object(forKey: "TNORApiKey") as! String
    return value
  }
  
}
