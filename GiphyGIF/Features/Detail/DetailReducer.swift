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
import ActivityKit

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
    @BindingState public var isFavorited: Bool = false
    @BindingState public var isLoading: Bool = false
    public var errorMessage: String = ""
    public var sharedDatas = [Data]()
    public var isError: Bool = false
  }
  
  public enum Action {
    case checkFavoriteAndDownloadGIF(item: Giphy)
    case addFavorite(item: Giphy)
    case removeFavorite(item: Giphy)
    case downloadedGIF(sharedDatas: [Data])
    case startLiveActivity(DetailReducer.State)
    
    case success(isFavorited: Bool)
    case failed(error: Error)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .checkFavoriteAndDownloadGIF(let item):
        state.isLoading = true
        return .run { send in
          do {
            let response = try await self.checkUseCase.execute(request: item.id)
            await send(.success(isFavorited: response))

            guard let imageURL = URL(string: item.image.url) else { return }
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            await send(.downloadedGIF(sharedDatas: [data]))

          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .downloadedGIF(let sharedDatas):
        state.sharedDatas = sharedDatas
        state.isLoading = false
        if let data = sharedDatas.first {
          data.copyGifClipboard()
        }
        return .none

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
            _ = try await self.addUseCase.execute(request: item)
            await send(.success(isFavorited: true))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .removeFavorite(let item):
        return .run { send in
          do {
            _ = try await self.removeUseCase.execute(request: item)
            await send(.success(isFavorited: false))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .startLiveActivity(let state):
        return .run { _ in
          let attributes = GiphyAttributes(title: state.item.title)
          let attributeState = GiphyAttributes.FavoriteState.init(isFavorited: state.isFavorited)
          
          let activity = try? Activity<GiphyAttributes>.request(attributes: attributes, contentState: attributeState)
          
          try await Task.sleep(nanoseconds: 3_000_000_000)
          await activity?.end(using: attributeState, dismissalPolicy: .immediate)
        }
      }
    }
  }
}
