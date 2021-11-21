//
//  DummyRemoteDataSource.swift
//  GiphyGIFTests
//
//  Created by Uwais Alqadri on 11/3/21.
//

@testable import GiphyGIF
@testable import Giphy
@testable import Core
import Combine

enum NetworkError: Error {
  case internalServerError
}

struct DummyRemoteDataSource: DataSource {
  typealias Request = Int
  typealias Response = [Giphy]

  func execute(request: Int?) -> AnyPublisher<[Giphy], Error> {
    if request == 10 {
      return createErrorResponse()
    }

    return createDummyArrayResponse()
  }

  private func createDummyArrayResponse() -> AnyPublisher<[Giphy], Error> {
    return Future<[Giphy], Error> { completion in
      let objects = [
        [
          "id": "1082jwjwj2ninw",
          "title": "Funny GIF"
        ]
      ].compactMap({ GiphyEntity(JSON: $0) })
      completion(.success(objects))
    }.compactMap({ $0 })
    .eraseToAnyPublisher()
  }

  private func createErrorResponse() -> AnyPublisher<[Giphy], Error> {
    return Future<[Giphy], Error> { completion in
      completion(.failure(ApiError.networkFailure(error: NetworkError.internalServerError)))
    }.compactMap({ $0 })
    .eraseToAnyPublisher()
  }
}
