//
//  AIGenerateOption.swift
//
//
//  Created by Uwais Alqadri on 10/11/24.
//

import Foundation

public enum GPT4VisionPromptPhase {
  case initial
  case prompting
  case success(String)
  case failure(Error)
}

public enum AIGenerateOption: String, Identifiable, Hashable, CaseIterable {
  public var id: Self { self }
  
  case textPrompt = "Text Prompt"
  case gpt4Vision = "GPT-4 Vision"
}
