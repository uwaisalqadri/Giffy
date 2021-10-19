//
//  GiphyLocalDataSource.swift
//  
//
//  Created by Uwais Alqadri on 10/19/21.
//

import Core
import Combine
import RealmSwift

public struct GiphyLocalDataSource: LocalDataSource {
  public typealias Request = String
  public typealias Response = Giphy

  private let realm: Realm? = try? Realm(
    configuration: Realm.Configuration.init(schemaVersion: 1)
  )

  public init() {}

  public func list(request: String?) -> AnyPublisher<[Giphy], Error> {

  }

  public func add(entity: Giphy) -> AnyPublisher<Giphy, Error> {

  }

  public func delete(entity: Giphy) -> AnyPublisher<Giphy, Error> {

  }
}

