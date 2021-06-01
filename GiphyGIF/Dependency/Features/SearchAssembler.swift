//
//  SearchAssembler.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import Foundation
import Core

protocol SearchAssembler {
  func resolve() -> SearchViewModel
  func resolve() -> SearchUseCase
  func resolve() -> SearchRepository
}

extension SearchAssembler {
  func resolve() -> SearchViewModel {
    return SearchViewModel(searchUseCase: resolve())
  }

  func resolve() -> SearchUseCase {
    return SearchInteractor(repository: resolve())
  }

  func resolve() -> SearchRepository {
    let remote = DefaultRemoteDataSource.shared
    return DefaultSearchRepository(remoteDataSource: remote)
  }

}
