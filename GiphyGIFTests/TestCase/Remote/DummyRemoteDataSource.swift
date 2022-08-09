//
//  DummyRemoteDataSource.swift
//  GiphyGIFTests
//
//  Created by Uwais Alqadri on 8/9/22.
//

@testable import GiphyGIF
@testable import Giphy
@testable import Core
import Combine
import Foundation

struct DummyRemoteDataSource: DataSource {
  typealias Request = Int
  typealias Response = [Giphy]

  func execute(request: Int?) -> AnyPublisher<[Giphy], Error> {
    if request == 10 {
      return createErrorResponse()
    }

    let result = createDummyArrayResponse()

    return result
  }

  private func createDummyArrayResponse() -> AnyPublisher<[Giphy], Error> {
    return JSONLoader<GiphyResponse>().load(fileName: "GiphyMockResponse")
      .compactMap { $0.data }
      .eraseToAnyPublisher()
  }

  private func createErrorResponse() -> AnyPublisher<[Giphy], Error> {
    return Future<[Giphy], Error> { completion in
      completion(.failure(ApiError.networkFailure(error: NetworkError.internalServerError)))
    }
    .eraseToAnyPublisher()
  }
}
