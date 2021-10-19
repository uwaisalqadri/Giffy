//
//  NetworkService.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation
import ObjectMapper
import Combine
import Alamofire
import Core

public class NetworkService {
  public static let shared = NetworkService()

  public func connect<T: Mappable>(api: URL, responseType: T.Type) -> AnyPublisher<T, Error> {
    return Future<T, Error> { completion in
      AF.request(api.absoluteString)
        .responseData { (response) in
          switch response.result {
          case .success(let data):
            if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
               let data = json as? [String: Any] {
              let map = Map(mappingType: .fromJSON, JSON: data)
              if let object = responseType.init(map: map) {

                print("[NETWORK][\(response.response?.statusCode ?? 0)] \(api)")
                completion(.success(object))

              } else {
                completion(.failure(ApiError.failedMapping(json: data)))
              }
            } else {
              completion(.failure(ApiError.invalidServerResponse(responseString: "Not a JSON")))
            }
          case .failure(let error):
            completion(.failure(error))
          }
        }
    }.eraseToAnyPublisher()
  }
}
