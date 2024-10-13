//
//  DetailPresenter.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/9/23.
//

import Foundation
import ComposableArchitecture
import Core
import Common
import CommonUI
import ActivityKit

typealias AddFavoriteInteractor = Interactor<
  Giffy, Giffy, AddFavoriteRepository<
    GiphyLocalDataSource
  >
>

typealias CheckFavoriteInteractor = Interactor<
  String, Bool, CheckFavoriteRepository<
    GiphyLocalDataSource
  >
>

@Reducer
public struct DetailReducer {
  
  private let checkUseCase: CheckFavoriteInteractor
  private let addUseCase: AddFavoriteInteractor
  private let removeUseCase: RemoveFavoriteInteractor
  
  init(
    checkUseCase: CheckFavoriteInteractor,
    addUseCase: AddFavoriteInteractor,
    removeUseCase: RemoveFavoriteInteractor
  ) {
    self.checkUseCase = checkUseCase
    self.addUseCase = addUseCase
    self.removeUseCase = removeUseCase
  }
  
  @ObservableState
  public struct State: Equatable {
    public let item: Giffy
    public init(item: Giffy) {
      self.item = item
    }
    
    public var isFavorited: Bool = false
    public var isLoading: Bool = false
    public var isShareGIF = false
    public var errorMessage: String = ""
    public var isError: Bool = false
    public var downloadedImage: Data?
  }
  
  public enum Action {
    case checkFavorite
    case downloaded(data: Data?)
    case addFavorite
    case removeFavorite
    case copyToClipboard
    case startLiveActivity(DetailReducer.State)

    case success(isFavorited: Bool)
    case failed(error: Error)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .checkFavorite:
        state.isLoading = true
        let item = state.item
        return .run { send in
          do {
            let response = try await self.checkUseCase.execute(request: item.id)
            await send(.success(isFavorited: response))
          } catch {
            await send(.failed(error: error))
          }
        }

      case let .downloaded(data):
        state.isLoading = false
        state.downloadedImage = data
        return .none

      case .copyToClipboard:
        guard let data = state.downloadedImage else { return .none }
        data.copyGifClipboard()
        state.isShareGIF = true
        Toaster.success(message: "Copied").show()
        return .none

      case .success(let isFavorited):
        state.isFavorited = isFavorited
        return .none
        
      case .failed:
        state.isFavorited = false
        state.isError = true
        return .none
        
      case .addFavorite:
        let item = state.item
        return .run { send in
          do {
            _ = try await self.addUseCase.execute(request: item)
            await send(.success(isFavorited: true))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .removeFavorite:
        let item = state.item
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

enum ShareError: Error {
  case fail
}
