//
//  TabReducer.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 8/10/23.
//

import SwiftUI
import Common
import ComposableArchitecture

public enum Tabs: Int, CaseIterable {
  case search
  case home
  case sticker
  case aiGen

  var iconName: String {
    switch self {
    case .search:
      return "rectangle.3.offgrid"
    case .home:
      return "rectangle.stack"
    case .sticker:
      return "square.on.square"
    case .aiGen:
      return "sparkles"
    }
  }
  
  var iconColor: Color {
    switch self {
    case .search:
      return .Theme.green
    case .home:
      return .Theme.blueSky
    case .sticker:
      return .Theme.purple
    case .aiGen:
      return .Theme.yellow
    }
  }
}

@Reducer
struct MainTabReducer {
  struct State: Equatable {
    var selectedTab: Tabs = .search
    var home: HomeReducer.State = .init()
    var search: SearchReducer.State = .init()
    var sticker: StickerReducer.State = .init()
    var aiGen: AIGenReducer.State = .init()
  }
  
  @CasePathable
  enum Action: CasePathable {
    case home(HomeReducer.Action)
    case search(SearchReducer.Action)
    case sticker(StickerReducer.Action)
    case aiGen(AIGenReducer.Action)
    case selectedTabChanged(Tabs)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .selectedTabChanged(tab):
        state.selectedTab = tab
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        return .none
      default:
        return .none
      }
    }

    Scope(state: \.home, action: \.home) {
      HomeReducer(useCase: Injection.resolve())
    }

    Scope(state: \.search, action: \.search) {
      SearchReducer(useCase: Injection.resolve())
    }
    
    Scope(state: \.sticker, action: \.sticker) {
      StickerReducer(backgroundRemovalUseCase: Injection.resolve())
    }
    
    Scope(state: \.aiGen, action: \.aiGen) {
      AIGenReducer(aiGenUseCase: Injection.resolve())
    }
  }
}
