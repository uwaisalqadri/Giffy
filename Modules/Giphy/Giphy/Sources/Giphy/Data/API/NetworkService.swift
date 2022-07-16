//
//  NetworkService.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation
import Combine
import Alamofire

public class NetworkService {
  public static let shared = NetworkService()

  public func connect<T: Codable>(api: URL, responseType: T.Type) -> AnyPublisher<T, Error> {
    return Future<T, Error> { completion in
      AF.request(api.absoluteString)
        .responseDecodable(of: responseType) { response in
          switch response.result {
          case .success(let data):

            print("[NETWORK][\(response.response?.statusCode ?? 0)] \(api)")
            completion(.success(data))

          case .failure(let error):
            completion(.failure(error))
            print("[NETWORK][\(response.response?.statusCode ?? 0)] \(error)")
          }
        }
    }.eraseToAnyPublisher()
  }
}
