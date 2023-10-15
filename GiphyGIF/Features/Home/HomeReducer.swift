//
//  HomeReducer.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/9/23.
//

import Foundation
import ComposableArchitecture
import Core
import Giphy
import Common

typealias HomeInteractor = Interactor<
  Int, [Giphy], GetGiphyRepository<
    TrendingRemoteDataSource
  >
>

public struct HomeReducer: Reducer {
  
  private let useCase: HomeInteractor
  private let checkUseCase: CheckFavoriteInteractor
  private let addUseCase: AddFavoriteInteractor
  private let removeUseCase: RemoveFavoriteInteractor
  
  init(useCase: HomeInteractor, checkUseCase: CheckFavoriteInteractor, addUseCase: AddFavoriteInteractor, removeUseCase: RemoveFavoriteInteractor) {
    self.useCase = useCase
    self.checkUseCase = checkUseCase
    self.addUseCase = addUseCase
    self.removeUseCase = removeUseCase
  }
  
  public struct State: Equatable {
    public var list: [Giphy] = []
    public var errorMessage: String = ""
    public var isLoading: Bool = false
    public var isError: Bool = false
    public var isFavorited: Bool = false
  }
  
  public enum Action {
    case checkFavorite(request: String)
    case addFavorite(item: Giphy)
    case removeFavorite(item: Giphy)
    
    case fetch(request: Int)
    case success(response: [Giphy])
    case successCheckFavorite(Bool)
    case failed(error: Error)
    
    case showDetail(item: Giphy)
    case openFavorite
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .fetch(let request):
        state.isLoading = true
        return .run { send in
          do {
            let response = try await self.useCase.execute(request: request)
            await send(.success(response: response))
          } catch {
            await send(.failed(error: error))
          }
        }
      case .success(let data):
        state.list = data
        state.isLoading = false
        return .none
        
      case .failed:
        state.isError = true
        state.isLoading = false
        return .none
        
      case .checkFavorite(let request):
        return .run { send in
          do {
            let response = try await self.checkUseCase.execute(request: request)
            await send(.successCheckFavorite(response))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .addFavorite(let item):
        return .run { send in
          do {
            _ = try await self.addUseCase.execute(request: item)
            await send(.successCheckFavorite(true))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .removeFavorite(let item):
        return .run { send in
          do {
            _ = try await self.removeUseCase.execute(request: item)
            await send(.successCheckFavorite(false))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .successCheckFavorite(let isFavorited):
        state.isFavorited = isFavorited
        return .none
        
      case .showDetail, .openFavorite:
        return .none
      }
    }
  }
}
