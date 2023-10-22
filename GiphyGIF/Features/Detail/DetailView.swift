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
import ActivityKit
import Foundation

struct DetailView: View {
  let store: StoreOf<DetailReducer>
  
  @Environment(\.dismiss) private var dismiss
  @State private var isShareGIF = false
  @State private var isAnimating = true
  
  @State private var activity: Activity<GiphyAttributes>?
  
  private let screenWidth = UIScreen.main.bounds.width
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationView {
        ZStack(alignment: .bottomTrailing) {
          TabView {
            let items = [viewStore.state.item, viewStore.state.item, viewStore.state.item].indexed
            
            ForEach(items, id: \.position) { _, item in
              GeometryReader { geometry in
                ZStack {
                  AnimatedGradientBackground()
                  
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
        .sheet(isPresented: $isShareGIF) {
          ShareSheetView(activityItems: viewStore.state.sharedData)
        }
        .onAppear {
          viewStore.send(.checkFavoriteAndDownloadGIF(item: viewStore.state.item))
        }
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
                  viewStore.send(.startLiveActivity(viewStore.state))
                }
              }
            )
          }
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

struct AnimatedGradientBackground: View {
  
  @State private var shouldAnimate = false
  
  var body: some View {
    LinearGradient(
      colors: [.Theme.purple, .Theme.red],
      startPoint: shouldAnimate ? .topLeading : .bottomTrailing,
      endPoint: shouldAnimate ? .bottomTrailing : .topLeading
    )
    .onAppear {
      let animation = Animation.easeOut(duration: 2.0).repeatForever(autoreverses: true)
      withAnimation(animation) {
        shouldAnimate.toggle()
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        withAnimation(animation) {
          self.shouldAnimate.toggle()
        }
      }
    }
  }
}
