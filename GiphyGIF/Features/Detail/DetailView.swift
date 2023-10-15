//
//  DetailView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Giphy
import Core
import Common
import ComposableArchitecture
import SDWebImageSwiftUI

struct DetailView: View {
  let store: StoreOf<DetailReducer>
  
  @Environment(\.dismiss) private var dismiss
  @State private var isFavorite = false
  @State private var isShareGIF = false
  @State private var isAnimating = true
  @State private var animateGradient = false
  
  private let screenWidth = UIScreen.main.bounds.width
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationView {
        ZStack(alignment: .bottomTrailing) {
          TabView {
            ForEach([viewStore.state.item, viewStore.state.item, viewStore.state.item], id: \.id) { item in
              GeometryReader { geometry in
                ZStack {
                  LinearGradient(colors: [.Theme.purple, .Theme.red], startPoint: animateGradient ? .topLeading : .bottomTrailing, endPoint: animateGradient ? .bottomTrailing : .topLeading)
                  //                    .onAppear {
                  //                      withAnimation(.easeIn(duration: 2.0).repeatForever(autoreverses: true)) {
                  //                        animateGradient.toggle()
                  //                      }
                  //                    }
                  
                  AnimatedImage(url: URL(string: item.image.url), isAnimating: $isAnimating)
                    .placeholder(content: { Color.randomColor })
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth - 60, height: screenWidth - 60)
                    .cornerRadius(20)
                }
                .frame(width: geometry.frame(in: .global).width, height: geometry.frame(in: .global).height)
                .rotation3DEffect(
                  .init(degrees: getAngle(xOffset: geometry.frame(in: .global).minX)),
                  axis: (x: 0.0, y: 1.0, z: 0.0),
                  anchor: geometry.frame(in: .global).minX > 0 ? .leading : .trailing,
                  perspective: 2.5
                )
              }
            }
          }
          .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .padding(.top, -40)
        .edgesIgnoringSafeArea(.all)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            IconButton(
              iconName: "xmark",
              tint: .Theme.yellow,
              onClick: {
                dismiss()
              }
            )
          }
          
          ToolbarItem(placement: .navigationBarTrailing) {
            IconButton(
              iconName: "square.and.arrow.up.fill",
              tint: .Theme.green,
              onClick: {
                isShareGIF.toggle()
              }
            ).padding(.trailing, 20)
          }
          
          ToolbarItem(placement: .navigationBarTrailing) {
            IconButton(
              iconName: viewStore.state.isFavorited ? "heart.fill" : "heart",
              tint: .Theme.blueSky,
              onClick: {
                if viewStore.state.isFavorited {
                  viewStore.send(.removeFavorite(item: viewStore.state.item))
                } else {
                  viewStore.send(.addFavorite(item: viewStore.state.item))
                }
              }
            )
          }
          
        }
        .sheet(isPresented: $isShareGIF) {
          ShareSheetView(activityItems: viewStore.state.sharedData)
        }
        .onAppear {
          viewStore.send(.checkFavoriteAndDownloadGIF(item: viewStore.state.item))
        }
      }
    }
  }
  
  func getAngle(xOffset: CGFloat) -> Double {
    let angle = xOffset / (screenWidth / 2)
    let rotationDegree: CGFloat = 25
    return Double(angle * rotationDegree)
  }
}

struct ShareSheetView: UIViewControllerRepresentable {
  typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
  
  let activityItems: [Any]
  let applicationActivities: [UIActivity]? = nil
  let excludedActivityTypes: [UIActivity.ActivityType]? = nil
  let callback: Callback? = nil
  
  func makeUIViewController(context: Context) -> UIActivityViewController {
    let controller = UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: applicationActivities)
    controller.excludedActivityTypes = excludedActivityTypes
    controller.completionWithItemsHandler = callback
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    // nothing to do here
  }
}
