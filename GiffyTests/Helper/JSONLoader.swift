//
//  JSONLoader.swift
//  GiphyGIFTests
//
//  Created by Uwais Alqadri on 7/17/22.
//

import Combine
import Foundation

class JSONLoader<T: Codable> {
  
  func load(fileName: String? = nil) async throws -> T {
    return try await withCheckedThrowingContinuation { promise in
      
      let bundle = Bundle(for: JSONLoader.self)
      let filename: String
      
      if let name = fileName {
        filename = name
      } else {
        filename = String(describing: T.self)
      }
      
      guard let path = bundle.path(forResource: filename, ofType: "json"),
            let value = try? String(contentsOfFile: path) else {
        promise.resume(throwing: NetworkError.failedSerializable)
        return
      }
      
      let jsonData = Data(value.utf8)
      let decoder = JSONDecoder()
      
      do {
        let codable = try decoder.decode(T.self, from: jsonData)
        promise.resume(returning: codable)
      } catch {
        promise.resume(throwing: NetworkError.failedSerializable)
      }
      
    }
  }
}
