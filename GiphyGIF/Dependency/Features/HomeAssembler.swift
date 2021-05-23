//
//  HomeAssembler.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import SwiftUI

protocol HomeAssembler {
  func resolve() -> HomeView
  func resolve() -> HomeViewModel
  func resolve() -> HomeUseCase
  func resolve() -> HomeRepository
  func resolve() -> RemoteDataSource
}

extension HomeAssembler where Self: Assembler {
  func resolve() -> HomeView {
    return HomeView()
  }

  func resolve() -> HomeViewModel {
    return HomeViewModel(homeUseCase: resolve())
  }

  func resolve() -> HomeUseCase {
    return HomeInteractor(repository: resolve())
  }

  func resolve() -> HomeRepository {
    return DefaultHomeRepository(remoteDataSource: resolve())
  }
}
