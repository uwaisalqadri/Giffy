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
    return Future<[Giphy], Error> { completion in
      let keyword = request ?? ""
      if let realm = realm {
        let all = realm.objects(GiphyEntity.self)
          .sorted(byKeyPath: "title")
        var giphys = [GiphyEntity]()
        all.forEach { giphy in
          let searchableValue = [
            giphy.title,
            giphy.username,
            giphy.type
          ]
          if (!keyword.isEmpty &&
                searchableValue.joined(separator: " ").lowercased()
                .contains(keyword.lowercased())) ||
              keyword.isEmpty {
            giphys.append(giphy)
          }
        }
        completion(.success(giphys))
      } else {
        completion(.success([]))
      }
    }.eraseToAnyPublisher()
  }

  public func add(entity: Giphy) -> AnyPublisher<Giphy, Error> {
    return Future<Giphy, Error> { completion in
      if let realm = realm,
         let object = entity as? GiphyEntity {
        do {
          try realm.write {
            realm.add(object, update: .all)
          }
          object.isFavorite = true
          completion(.success(object))
        } catch {
          completion(.failure(error))
        }
      }
    }.eraseToAnyPublisher()
  }

  public func delete(entity: Giphy) -> AnyPublisher<Giphy, Error> {
    return Future<Giphy, Error> { completion in
      if let realm = realm,
         let object = savedMovie(with: entity.identifier) {
        do {
          try realm.write {
            realm.delete(object)
          }
          object.isFavorite = false
          completion(.success(object))
        } catch {
          completion(.failure(error))
        }
      }
    }.eraseToAnyPublisher()
  }


  public func get(entityId: Int) -> AnyPublisher<Giphy, Error> {
    print("GET FUNC DATA")
    return Future<Giphy, Error> { completion in
      if let object = savedMovie(with: String(entityId)) {
        completion(.success(object))
        print("GET LOCAL DATA", object)
      }
    }.eraseToAnyPublisher()
  }

  private func savedMovie(with giphyId: String) -> GiphyEntity? {
    let giphy = realm?.object(ofType: GiphyEntity.self, forPrimaryKey: giphyId)
    return giphy
  }
}

