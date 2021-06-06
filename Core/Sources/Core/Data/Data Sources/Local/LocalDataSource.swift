//
//  LocalDataSource.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation
import Combine
import RealmSwift

public protocol LocalDataSource {
  func getSavedGiphy() -> AnyPublisher<[GiphyObject], Error>
  func addToSavedGiphy(from giphys: [GiphyObject]) -> AnyPublisher<Bool, Error>
  func getFavoriteGiphys() -> AnyPublisher<[FavGiphyObject], Error>
  func addToFavoriteGiphys(from giphy: FavGiphyObject) -> AnyPublisher<Bool, Error>
  func removeFavoriteGiphy(from idGiphy: String) -> AnyPublisher<Bool, Error>
}

public class DefaultLocalDataSource: NSObject {

  private let realm: Realm?
  public init(realm: Realm?) {
    self.realm = realm
  }

  public static let shared: (Realm?) -> DefaultLocalDataSource = { realmDatabase in
    return DefaultLocalDataSource(realm: realmDatabase)
  }
}

extension DefaultLocalDataSource: LocalDataSource {
  public func getSavedGiphy() -> AnyPublisher<[GiphyObject], Error> {
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

  public func addToSavedGiphy(from giphys: [GiphyObject]) -> AnyPublisher<Bool, Error> {
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

  public func getFavoriteGiphys() -> AnyPublisher<[FavGiphyObject], Error> {
    return Future<[FavGiphyObject], Error> { completion in
      if let realm = self.realm {
        let giphys: Results<FavGiphyObject> = {
          realm.objects(FavGiphyObject.self)
            .sorted(byKeyPath: "title", ascending: true)
        }()
        completion(.success(giphys.toArray(ofType: FavGiphyObject.self)))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  public func addToFavoriteGiphys(from giphy: FavGiphyObject) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let realm = self.realm {
        do {
          try realm.write {
            realm.add(giphy, update: .all)
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

  public func removeFavoriteGiphy(from idGiphy: String) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let realm = self.realm {
        if let giphyObject = {
          realm.objects(FavGiphyObject.self).filter("id = \(idGiphy)")
        }().first {
          do {
            try realm.write {
              realm.delete(giphyObject)
              completion(.success(true))
            }
          } catch {
            completion(.failure(DatabaseError.requestFailed))
          }
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
