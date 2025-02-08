//
//  Array.swift
//  
//
//  Created by Uwais Alqadri on 21/10/23.
//

import Foundation

extension Array {
  public var indexed: [(position: Int, item: Element)] {
    return self.enumerated().map { ($0, $1) }
  }
}

extension Array {
  public func asyncMap<T>(_ transform: @escaping (Element) async throws -> T) async throws -> [T] {
    try await withThrowingTaskGroup(of: T?.self) { group in
      for element in self {
        group.addTask {
          try await transform(element)
        }
      }
      var results = [T]()
      for try await result in group {
        if let result = result { results.append(result) }
      }
      return results
    }
  }
}
