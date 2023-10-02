//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 28/9/23.
//

import SwiftUI

public extension NavigationLink {
  init<T, ItemDestination: View>(
    destination: @escaping (T) -> ItemDestination,
    item: Binding<T?>,
    label: () -> Label
  ) where Destination == AnyView {
    let isActive = Binding(
      get: {
        item.wrappedValue != nil
      },
      set: { active in
        guard !active else { return }
        item.wrappedValue = nil
      }
    )
    
    let itemDestination = {
      AnyView(Unwrap(item.wrappedValue, content: destination))
    }
    
    self.init(isActive: isActive, destination: itemDestination, label: label)
  }
}

public struct Unwrap<T, V: View>: View {
  private let t: T?
  private let content: (T) -> V
  
  public init(_ t: T?, @ViewBuilder content: @escaping (T) -> V) {
    self.t = t
    self.content = content
  }
  
  public var body: some View {
    if let t = t {
      content(t)
    }
  }
}
