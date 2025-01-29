//
//  AddFavoriteInteractor.swift
//  
//
//  Created by Uwais Alqadri on 10/20/21.
//

import Foundation
import Core
import Combine

public struct AddFavoriteInteractor<
  GiphyDataSource: LocalDataSource>: Repository
where
  GiphyDataSource.Response == Giffy,
  GiphyDataSource.Request == String {

  public typealias Request = Giffy
  public typealias Response = Giffy

  private let localDataSource: GiphyDataSource

  public init(localDataSource: GiphyDataSource) {
    self.localDataSource = localDataSource
  }

  public func execute(request: Giffy?) async throws -> Giffy {
    _ = try await localDataSource.add(entity: request!)
    return request!
  }
}
