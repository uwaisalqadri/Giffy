//
//  ContentView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import SwiftUI
import Common

struct ContentView: View {

  @State var currentTab = 0

  var body: some View {
    NavigationView {
      ZStack {
        switch currentTab {
        case 0:
          HomeView(presenter: Injection.shared.resolve(), router: Injection.shared.resolve())
        case 1:
          SearchView(presenter: Injection.shared.resolve(), router: Injection.shared.resolve())
        case 2:
          AboutView()
        default:
          EmptyView()
        }

        VStack {
          Spacer()
          tabView.padding(.bottom, 20)
        }
      }
    }
  }

  var tabView: some View {
    HStack(spacing: 30) {
      Button(action: {
        currentTab = 0
      }) {
        VStack {
          Image(systemName: "rectangle.3.offgrid")
            .resizable()
            .foregroundColor(.green)
            .frame(width: 25, height: 25, alignment: .center)
            .padding(5)
        }
      }

      Button(action: {
        currentTab = 1
      }) {
        VStack {
          Image(systemName: "rectangle.stack")
            .resizable()
            .foregroundColor(.yellow)
            .frame(width: 25, height: 25, alignment: .center)
            .padding(5)
        }
      }

      Button(action: {
        currentTab = 2
      }) {
        VStack {
          Image(systemName: "person")
            .resizable()
            .foregroundColor(.purple)
            .frame(width: 25, height: 25, alignment: .center)
            .padding(5)
        }
      }
    }
    .frame(maxWidth: Common.isIpad ? 300 : .infinity, minHeight: 80)
    .background(
      Blur(style: .systemUltraThinMaterialDark)
        .cornerRadius(15, corners: [.allCorners])
    )
    .padding(.horizontal, 70)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
