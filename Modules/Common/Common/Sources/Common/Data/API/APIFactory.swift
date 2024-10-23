//
//  APIFactory.swift
//
//
//  Created by Uwais Alqadri on 11/10/24.
//

import Foundation

public protocol APIFactory {
  var path: String { get }
  var parameter: [String: Any] { get }
  var baseURL: String { get }
  
  var composedURL: URL { get }
}

public extension APIFactory {
  var composedURL: URL {
    let params = parameter.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
    let urlString = baseURL.appending(path)
      .appending("?")
      .appending(params)
    return URL(string: urlString) ?? URL.init(fileURLWithPath: "")
  }
}
