//
//  FavoriteAssembler.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 06/06/21.
//

import Foundation
import Core
import RealmSwift

protocol FavoriteAssembler {
  func resolve() -> FavoriteViewModel
  func resolve() -> FavoriteUseCase
  func resolve() -> FavoriteRepository
}

extension FavoriteAssembler where Self: Assembler {

  func resolve() -> FavoriteViewModel {
    return FavoriteViewModel(favoriteUseCase: resolve())
  }

  func resolve() -> FavoriteUseCase {
    return FavoriteInteractor(repository: resolve())
  }

  func resolve() -> FavoriteRepository {
    let realm = try? Realm()
    let local = DefaultLocalDataSource.shared(realm)
    return DefaultFavoriteRepository(localDataSource: local)
  }
}
