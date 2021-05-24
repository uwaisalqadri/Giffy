//
//  HomeAssembler.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation

protocol HomeAssembler {
  func resolve() -> HomeViewModel
  func resolve() -> HomeUseCase
  func resolve() -> HomeRepository
}

extension HomeAssembler {
  func resolve() -> HomeViewModel {
    return HomeViewModel(homeUseCase: resolve())
  }

  func resolve() -> HomeUseCase {
    return HomeInteractor(repository: resolve())
  }

  func resolve() -> HomeRepository {
    let remoteDataSource = DefaultRemoteDataSource.shared
    return DefaultHomeRepository(remoteDataSource: remoteDataSource)
  }
}
