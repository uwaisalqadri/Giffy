//
//  DummyRemoteDataSource.swift
//  GiphyGIFTests
//
//  Created by Uwais Alqadri on 11/3/21.
//

import Combine
import Foundation

enum NetworkError: Error {
  case internalServerError
  case failedSerializable
}
