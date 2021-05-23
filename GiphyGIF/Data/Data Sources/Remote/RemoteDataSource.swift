//
//  RemoteDataSource.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation
import Combine
import Alamofire

protocol RemoteDataSource {
  func getTrendingGiphy() -> AnyPublisher<[GiphyItem], Error>
  func getSearchGiphy(query: String) -> AnyPublisher<[GiphyItem], Error>
}

final class DefaultRemoteDataSource: NSObject {
  static let shared: DefaultRemoteDataSource = DefaultRemoteDataSource()
}

extension DefaultRemoteDataSource: RemoteDataSource {
  func getTrendingGiphy() -> AnyPublisher<[GiphyItem], Error> {
    return Future<[GiphyItem], Error> { completion in
      if let url = URL(string: Constants.baseUrl + getEndpoint(endpoint: .trending, apiKey: Constants.apiKey)) {
        AF.request(url)
          .validate()
          .responseDecodable(of: GiphyResponse.self) { response in
            switch response.result {
            case .success(let value):
              completion(.success(value.data))
            case .failure:
              completion(.failure(URLError.invalidResponse))
            }
          }
      }
    }.eraseToAnyPublisher()
  }

  func getSearchGiphy(query: String) -> AnyPublisher<[GiphyItem], Error> {
    return Future<[GiphyItem], Error> { completion in
      if let url = URL(string: Constants.baseUrl + getEndpoint(endpoint: .search, apiKey: Constants.apiKey, query: query)) {
        AF.request(url)
          .validate()
          .responseDecodable(of: GiphyResponse.self) { response in
            switch response.result {
            case .success(let value):
              completion(.success(value.data))
            case .failure:
              completion(.failure(URLError.invalidResponse))
            }
          }
      }
    }.eraseToAnyPublisher()
  }
}

