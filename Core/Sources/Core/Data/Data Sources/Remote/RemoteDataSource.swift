//
//  RemoteDataSource.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation
import Combine
import Alamofire

public protocol RemoteDataSource {
  func getTrendingGiphy() -> AnyPublisher<[GiphyItem], Error>
  func getSearchGiphy(query: String) -> AnyPublisher<[GiphyItem], Error>
  func getRandomGiphy() -> AnyPublisher<[GiphyItem], Error>
}

public class DefaultRemoteDataSource: NSObject {

  public override init() {}

  public static let shared: DefaultRemoteDataSource = DefaultRemoteDataSource()

}

extension DefaultRemoteDataSource: RemoteDataSource {

  public func getTrendingGiphy() -> AnyPublisher<[GiphyItem], Error> {
    return Future<[GiphyItem], Error> { completion in
      if let url = URL(string: Constants.baseUrl + getEndpoint(endpoint: .trending)) {
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

  public func getSearchGiphy(query: String) -> AnyPublisher<[GiphyItem], Error> {
    return Future<[GiphyItem], Error> { completion in
      if let url = URL(string: Constants.baseUrl + getEndpoint(endpoint: .search, query: query)) {
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

  public func getRandomGiphy() -> AnyPublisher<[GiphyItem], Error> {
    return Future<[GiphyItem], Error> { completion in
      if let url = URL(string: Constants.baseUrl + getEndpoint(endpoint: .random)) {
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
