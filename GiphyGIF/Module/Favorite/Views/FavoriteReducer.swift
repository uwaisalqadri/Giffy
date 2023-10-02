//
//  FavoriteReducer.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/9/23.
//

import Foundation
import ComposableArchitecture
import Core
import Giphy
import Common

typealias FavoriteInteractor = Interactor<
  String, [Giphy], FavoriteGiphysRepository<
    GiphyLocalDataSource
  >
>

typealias RemoveFavoriteInteractor = Interactor<
  Giphy, Bool, RemoveFavoriteRepository<
    GiphyLocalDataSource
  >
>

public struct FavoriteReducer: Reducer {
  
  private let useCase: FavoriteInteractor
  private let removeUseCase: RemoveFavoriteInteractor
  
  init(useCase: FavoriteInteractor, removeUseCase: RemoveFavoriteInteractor) {
    self.useCase = useCase
    self.removeUseCase = removeUseCase
  }
  
  public struct State: Equatable {
    public var list: [Giphy] = []
    public var errorMessage: String = ""
    public var isLoading: Bool = false
    public var isError: Bool = false
  }
  
  public enum Action {
    case fetch(request: String)
    case removeFavorite(item: Giphy, request: String)
    
    case success(response: [Giphy])
    case failed(error: Error)
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
        
      case .removeFavorite(let item, let request):
        return .run { send in
          do {
            let response = try await self.removeUseCase.execute(request: item)
            await send(.fetch(request: request))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      }
    }
  }
}
