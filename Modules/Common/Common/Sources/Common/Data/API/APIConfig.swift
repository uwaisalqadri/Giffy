//
//  Config.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation

struct APIConfig {
  var baseUrl: String
  var apiKey: String

  static var giphyConfig = APIConfig(
    baseUrl: "https://api.giphy.com/v1/gifs/",
    apiKey: getPropertyValue(for: "GPHYApiKey")
  )

  static var tenorConfig = APIConfig(
    baseUrl: "https://g.tenor.com/v1/",
    apiKey: getPropertyValue(for: "TNORApiKey")
  )

  static func getPropertyValue(for key: String) -> String {
    let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")!
    let plist = NSDictionary(contentsOfFile: filePath)
    let value = plist?.object(forKey: key) as? String
    return value ?? ""
  }
}
