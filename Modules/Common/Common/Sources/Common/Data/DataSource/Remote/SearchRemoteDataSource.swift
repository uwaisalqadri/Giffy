//
//  SearchDataSource.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Core
import Combine

public struct SearchRemoteDataSource: DataSource {
  public typealias Request = String
  public typealias Response = [Giffy]

  public init() {}

  public func execute(request: String?) async throws -> [Giffy] {
    let giphies = try await NetworkService.shared.connect(
      api: GiphyAPI.search(query: request ?? ""),
      responseType: GiphyDataResponse.self
    ).data.compactMap { $0.map() } 

    let tenors = try await NetworkService.shared.connect(
      api: TenorAPI.search(query: request ?? ""),
      responseType: TenorDataResponse.self
    ).results.compactMap { $0.map() }
    
    return combineGiffies(giphies, tenors)
  }
}

func combineGiffies(_ giphies: [Giffy], _ tenors: [Giffy]) -> [Giffy] {
  var allGifs: [Giffy] = []
  let maxLength = max(giphies.count, tenors.count)
  
  for index in 0..<maxLength {
    if index < giphies.count {
      allGifs.append(giphies[index])
    }
    if index < tenors.count {
      allGifs.append(tenors[index])
    }
  }
  return allGifs
}
