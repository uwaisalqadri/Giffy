//
//  DetailPresenter.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/9/23.
//

import Foundation
import ComposableArchitecture
import Core
import Giphy
import Common

typealias AddFavoriteInteractor = Interactor<
  Giphy, Giphy, AddFavoriteRepository<
    GiphyLocalDataSource
  >
>

typealias CheckFavoriteInteractor = Interactor<
  String, Bool, CheckFavoriteRepository<
    GiphyLocalDataSource
  >
>

public struct DetailReducer: Reducer {
  
  private let checkUseCase: CheckFavoriteInteractor
  private let addUseCase: AddFavoriteInteractor
  private let removeUseCase: RemoveFavoriteInteractor
  
  init(checkUseCase: CheckFavoriteInteractor, addUseCase: AddFavoriteInteractor, removeUseCase: RemoveFavoriteInteractor) {
    self.checkUseCase = checkUseCase
    self.addUseCase = addUseCase
    self.removeUseCase = removeUseCase
  }
  
  public struct State: Equatable {
    public init(item: Giphy) {
      self.item = item
    }
    
    public var item: Giphy = .init()
    public var isFavorited: Bool = false
    public var errorMessage: String = ""
    public var isError: Bool = false
  }
  
  public enum Action {
    case checkFavorite(request: String)
    case addFavorite(item: Giphy)
    case removeFavorite(item: Giphy)
    
    case success(isFavorited: Bool)
    case failed(error: Error)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .checkFavorite(let request):
        return .run { send in
          do {
            let response = try await self.checkUseCase.execute(request: request)
            await send(.success(isFavorited: response))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .success(let isFavorited):
        state.isFavorited = isFavorited
        return .none
        
      case .failed:
        state.isFavorited = false
        state.isError = true
        return .none
        
      case .addFavorite(let item):
        return .run { send in
          do {
            let response = try await self.addUseCase.execute(request: item)
            await send(.success(isFavorited: true))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .removeFavorite(let item):
        return .run { send in
          do {
            let response = try await self.removeUseCase.execute(request: item)
            await send(.success(isFavorited: false))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      }
    }
  }
}
