//
//  LocalDataSource.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation
import Combine
import RealmSwift

protocol LocalDataSource {
  func getSavedGiphy() -> AnyPublisher<[GiphyObject], Error>
  func addToSavedGiphy(from giphys: [GiphyObject]) -> AnyPublisher<Bool, Error>
  func getFavoriteGiphys() -> AnyPublisher<[GiphyObject], Error>
  func updateFavoriteGiphy(by idGiphy: String) -> AnyPublisher<GiphyObject, Error>
}

class DefaultLocalDataSource: NSObject {

  private let realm: Realm?
  private init(realm: Realm?) {
    self.realm = realm
  }

  static let shared: (Realm?) -> DefaultLocalDataSource = {
    realmDatabase in return DefaultLocalDataSource(realm: realmDatabase)
  }

}

extension DefaultLocalDataSource: LocalDataSource {
  func getSavedGiphy() -> AnyPublisher<[GiphyObject], Error> {
    return Future<[GiphyObject], Error> { completion in
      if let realm = self.realm {
        let giphys: Results<GiphyObject> = {
          realm.objects(GiphyObject.self)
            .sorted(byKeyPath: "title", ascending: true)
        }()
        completion(.success(giphys.toArray(ofType: GiphyObject.self)))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func addToSavedGiphy(from giphys: [GiphyObject]) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let realm = self.realm {
        do {
          try realm.write {
            for giphy in giphys {
              realm.add(giphy, update: .all)
            }
            completion(.success(true))
          }
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func getFavoriteGiphys() -> AnyPublisher<[GiphyObject], Error> {
    return Future<[GiphyObject], Error> { completion in
      if let realm = self.realm {
        let giphys = {
          realm.objects(GiphyObject.self)
            .filter("favorite = \(true)")
            .sorted(byKeyPath: "title", ascending: true)
        }()
        completion(.success(giphys.toArray(ofType: GiphyObject.self)))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func updateFavoriteGiphy(
    by idGiphy: String
  ) -> AnyPublisher<GiphyObject, Error> {
    return Future<GiphyObject, Error> { completion in
      if let realm = self.realm, let GiphyObject = {
        realm.objects(GiphyObject.self).filter("id = '\(idGiphy)'")
      }().first {
        do {
          try realm.write {
            GiphyObject.setValue(!GiphyObject.favorite, forKey: "favorite")
          }
          completion(.success(GiphyObject))
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }
}

extension Results {
  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for index in 0 ..< count {
      if let result = self[index] as? T {
        array.append(result)
      }
    }
    return array
  }
}
