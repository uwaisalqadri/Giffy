//
//  JSONLoader.swift
//  GiphyGIFTests
//
//  Created by Uwais Alqadri on 7/17/22.
//

import Combine
import Foundation

class JSONLoader<T: Codable> {

  func load(fileName: String? = nil) -> AnyPublisher<T, Error> {

    return Future<T, Error> { completion in

      let bundle = Bundle(for: JSONLoader.self)
      let filename: String

      if let name = fileName {
        filename = name
      } else {
        filename = String(describing: T.self)
      }

      guard let path = bundle.path(forResource: filename, ofType: "json"),
            let value = try? String(contentsOfFile: path) else {
              completion(.failure(NetworkError.failedSerializable))
              return
            }

      let jsonData = Data(value.utf8)
      let decoder = JSONDecoder()

      do {
        let codable = try decoder.decode(T.self, from: jsonData)
        completion(.success(codable))
      } catch {
        completion(.failure(NetworkError.failedSerializable))
      }

    }.eraseToAnyPublisher()
  }
}
