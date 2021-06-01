//
//  DetailAssembler.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 01/06/21.
//

import Foundation
import Core
import RealmSwift

protocol DetailAssembler {
  func resolve() -> DetailViewModel
  func resolve() -> DetailUseCase
  func resolve() -> DetailRepository
}

extension DetailAssembler {
  func resolve() -> DetailViewModel {
    return DetailViewModel(detailUseCase: resolve())
  }

  func resolve() -> DetailUseCase {
    return DetailInteractor(repository: resolve())
  }

  func resolve() -> DetailRepository {
    let realm = try? Realm()
    let local = DefaultLocalDataSource.shared(realm)
    return DefaultDetailRepository(localDataSource: local)
  }
}
