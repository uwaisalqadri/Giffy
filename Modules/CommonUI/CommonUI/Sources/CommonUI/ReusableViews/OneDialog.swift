//
//  OneDialog.swift
//  Giffy
//
//  Created by Uwais Alqadri on 28/12/24.
//

import SwiftUI

private enum DialogConstants {
  static let radius: CGFloat = 40
  static let indicatorHeight: CGFloat = 6
  static let indicatorWidth: CGFloat = 60
  static let snapRatio: CGFloat = 0.25
  static let minHeightRatio: CGFloat = 2
}

public struct OneDialog<Content: View>: View {
  @Binding var isOpen: Bool
  
  var maxHeight: CGFloat
  let minHeight: CGFloat
  let shouldDismissOnTapOutside: Bool
  let content: Content
  
  @GestureState private var translation: CGFloat = 0
  
  private var offset: CGFloat {
    isOpen ? 0 : minHeight
  }
  
  init(
    isOpen: Binding<Bool>,
    maxHeight: CGFloat = UIScreen.main.bounds.height,
    shouldDismissOnTapOutside: Bool,
    @ViewBuilder content: () -> Content
  ) {
    self.minHeight = maxHeight * DialogConstants.minHeightRatio
    self.maxHeight = maxHeight
    self.shouldDismissOnTapOutside = shouldDismissOnTapOutside
    self.content = content()
    self._isOpen = isOpen
  }
  
  public var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        content
      }
      .frame(width: geometry.size.width, alignment: .top)
      .background(
        Blur(style: .systemUltraThinMaterialLight, interactive: false)
      )
      .clipShape(.rect(cornerRadius: DialogConstants.radius))
      .frame(height: geometry.size.height, alignment: .bottom)
      .offset(y: max(offset + translation, 0))
      .animation(.interactiveSpring(duration: 0.5), value: isOpen)
      .gesture(
        DragGesture().updating($translation) { value, state, _ in
          state = value.translation.height
        }.onEnded { value in
          if shouldDismissOnTapOutside {
            let snapDistance = geometry.size.height * DialogConstants.snapRatio
            guard abs(value.translation.height) > snapDistance else {
              return
            }
            
            isOpen = value.translation.height < 0
          }
        }
      )
      .onTapGesture {
        if shouldDismissOnTapOutside {
          isOpen.toggle()
        }
      }
      .environment(\.dismissDialog, { isOpen.toggle() })
    }
  }
}

struct DialogModifier<DialogContent: View>: ViewModifier {
  var shouldDismissOnTapOutside = false
  @Binding var isShown: Bool
  @ViewBuilder let dialogContent: () -> DialogContent
  
  func body(content: Content) -> some View {
    ZStack {
      content
        .onTapGesture {
          if shouldDismissOnTapOutside {
            isShown = false
          }
        }
        .animation(.default, value: isShown)
      
      OneDialog(
        isOpen: $isShown,
        shouldDismissOnTapOutside: false,
        content: dialogContent
      )
      .foregroundColor(.white)
      .padding(8)
      .padding(.horizontal, 20)
//      .edgesRespectingSafeArea(.bottom)
    }
  }
}

public struct DismissDialogKey: EnvironmentKey {
  public static var defaultValue: () -> Void = {}
}

public extension EnvironmentValues {
  var dismissDialog: () -> Void {
    get { self[DismissDialogKey.self] }
    set { self[DismissDialogKey.self] = newValue }
  }
}

public extension View {
  func showDialog<DialogContent: View>(
    shouldDismissOnTapOutside: Bool = false,
    isShowing: Binding<Bool>,
    @ViewBuilder dialogContent: @escaping () -> DialogContent
  ) -> some View {
    modifier(
      DialogModifier(
        shouldDismissOnTapOutside: shouldDismissOnTapOutside,
        isShown: isShowing,
        dialogContent: dialogContent
      )
    )
  }
}
