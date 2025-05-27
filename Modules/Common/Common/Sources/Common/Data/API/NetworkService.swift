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
  
  public func connect<T: Codable>(api: APIFactory, responseType: T.Type) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
      var urlRequest = URLRequest(url: api.composedURL)
      urlRequest.httpMethod = api.method.value
      urlRequest.allHTTPHeaderFields = api.headers
      urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      if let body = api.bodyData {
        urlRequest.httpBody = body
      }
      
      AF.request(urlRequest)
        .validate()
        .prettyPrintedJsonResponse(of: responseType)
        .responseDecodable(of: responseType) { response in
          switch response.result {
          case .success(let data):
            
            print("[NETWORK][\(response.response?.statusCode ?? 0)] \(api)")
            continuation.resume(with: .success(data))
            
          case .failure(let error):
            continuation.resume(with: .failure(error))
            print("[NETWORK][\(response.response?.statusCode ?? 0)] \(error)")
          }
        }
    }
  }
}

extension DataRequest {
  @discardableResult
  func prettyPrintedJsonResponse<T: Codable>(of responseType: T.Type) -> Self {
    return responseDecodable(of: responseType) { response in
      guard case .success(let result) = response.result,
            let data = try? JSONEncoder().encode(result),
            let text = String(data: data, encoding: .utf8) else {
        print("❌ Failed to encode the result to UTF-8 string")
        return
      }
      print("📗 prettyPrinted JSON response: \n \(text)")
    }
  }
}
