//
//  AIGenReducer.swift
//  Giffy
//
//  Created by Uwais Alqadri on 06/12/24.
//

import Foundation
import ComposableArchitecture
import Common
import CommonUI

@Reducer
public struct AIGenReducer {
  
  @Router var router
  private let aiGenUseCase: AIGenUseCase
  
  init(aiGenUseCase: AIGenUseCase) {
    self.aiGenUseCase = aiGenUseCase
  }
  
  @ObservableState
  public struct State: Equatable {
    var images: [String] = []
  }
  
  public enum Action {
    case onPrompt(String)
    case success([String])
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onPrompt(string):
        print("TRIGGRED \(string)")
        return .run { send in
          let images = try? await aiGenUseCase.execute(request: string)
          await send(.success(images ?? []))
        }
        
      case let .success(images):
        print("GENERATED \(images)")
        state.images = images
        return .none
      }
    }
  }
}
