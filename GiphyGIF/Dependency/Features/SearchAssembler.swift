//
//  SearchAssembler.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import Foundation

protocol SearchAssembler {
  func resolve() -> SearchView
  func resolve() -> SearchViewModel
  func resolve() -> SearchUseCase
  func resolve() -> SearchRepository
  func resolve() -> RemoteDataSource
}

extension SearchAssembler where Self: Assembler {
  func resolve() -> SearchView {
    return SearchView(viewModel: resolve())
  }

  func resolve() -> SearchViewModel {
    return SearchViewModel(searchUseCase: resolve())
  }

  func resolve() -> SearchUseCase {
    return SearchInteractor(repository: resolve())
  }

  func resolve() -> SearchRepository {
    return DefaultSearchRepository(remoteDataSource: resolve())
  }

  func resolve() -> RemoteDataSource {
    return DefaultRemoteDataSource()
  }
}
