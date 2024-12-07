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
    apiKey: propertyValue(forKey: .giphy)
  )

  static var tenorConfig = APIConfig(
    baseUrl: "https://g.tenor.com/v1/",
    apiKey: propertyValue(forKey: .tenor)
  )
  
  static var openAIConfig = APIConfig(
    baseUrl: "",
    apiKey: propertyValue(forKey: .openAI)
  )

  static func propertyValue(forKey key: Keys) -> String {
    guard let filePath = Keys.path else {
      fatalError("Don't forget to setup some Keys.plist!")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    let value = plist?.object(forKey: key.rawValue) as? String
    return value ?? ""
  }
}

extension APIConfig {
  /// Enum representation of your local `Keys.plist`
  enum Keys: String {
    case giphy = "GPHYApiKey"
    case tenor = "TNORApiKey"
    case openAI = "OpenAIApiKey"
    
    static var path: String? {
      Bundle.main.path(forResource: "Keys", ofType: "plist")
    }
  }
}
