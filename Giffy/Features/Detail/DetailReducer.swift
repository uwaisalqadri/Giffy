//
//  DetailPresenter.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/9/23.
//

import Foundation
import ComposableArchitecture
import Common
import CommonUI
import ActivityKit
import SwiftUI

@Reducer
public struct DetailReducer {
  
  private let checkFavoriteUseCase: CheckFavoriteUseCase
  private let addFavoriteUseCase: AddFavoriteUseCase
  private let removeFavoriteUseCase: RemoveFavoriteUseCase
  
  init(
    checkFavoriteUseCase: CheckFavoriteUseCase,
    addFavoriteUseCase: AddFavoriteUseCase,
    removeFavoriteUseCase: RemoveFavoriteUseCase
  ) {
    self.checkFavoriteUseCase = checkFavoriteUseCase
    self.addFavoriteUseCase = addFavoriteUseCase
    self.removeFavoriteUseCase = removeFavoriteUseCase
  }
  
  @ObservableState
  public struct State: Equatable {
    public var items: [Giffy]
    public var item: Giffy
    public init(items: [Giffy]) {
      self.items = items
      self.item = items.first(where: \.isHighlighted)!
    }
    
    public var isFavorited: Bool = false
    public var isLoading: Bool = false
    public var isShareGIF = false
    public var errorMessage: String = ""
    public var isError: Bool = false
    public var downloadedImage: Data?
    public var hearts: [HeartModel] = []
  }
  
  public enum Action {
    case checkFavorite
    case downloaded(data: Data?)
    case addFavorite
    case removeFavorite
    case copyToClipboard
    case onDisappear
    case startLiveActivity(DetailReducer.State)
    case updateHighlight(Giffy)
    case displayHeart(location: CGPoint)
    case takeOffHeart(_ heartId: UUID)

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
            let response = try await checkFavoriteUseCase.execute(request: item.id)
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
        Toaster.success(message: Localizable.labelCopied.tr()).show()
        return .none

      case .success(let isFavorited):
        state.isLoading = false
        state.isFavorited = isFavorited
        return .none
        
      case .failed:
        state.isLoading = false
        state.isFavorited = false
        Toaster.error(message: Localizable.errorCheckFavorite.tr()).show()
        return .none
        
      case .addFavorite:
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        
        let item = state.item
        return .run { send in
          do {
            _ = try await addFavoriteUseCase.execute(request: item)
            await send(.success(isFavorited: true))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .removeFavorite:
        let item = state.item
        return .run { send in
          do {
            _ = try await removeFavoriteUseCase.execute(request: item)
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
        
      case let .displayHeart(location):
        let heart = HeartModel(location: location)
        state.hearts.append(heart)
        
        let heartId = heart.id
        
        return .run { send in
          try await Task.sleep(for: .seconds(1))
          await send(.takeOffHeart(heartId))
        }

      case let .takeOffHeart(heartId):
        state.hearts.removeAll(where: { $0.id == heartId })
        return .none
        
      case .onDisappear:
        Notifications.onDetailDisappear.post()
        return .none
        
      case let .updateHighlight(giffy):
        state.item = giffy
        return .run { send in
          await send(.checkFavorite)
        }
      }
    }
  }
}

enum ShareError: Error {
  case fail
}
