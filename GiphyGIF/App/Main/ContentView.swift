//
//  ContentView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import SwiftUI

struct ContentView: View {

  @State var selectedIndex = 0
  let assembler = AppAssembler()

  var body: some View {
    ZStack {
      if selectedIndex == 0 {
        HomeView(viewModel: assembler.resolve())
      } else if selectedIndex == 1 {
        SearchView(viewModel: assembler.resolve())
      } else if selectedIndex == 2 {
        AboutView()
      }

      VStack {
        Spacer()
        tabView.padding(.bottom, 20)
      }
    }
  }

  var tabView: some View {
    HStack {
      Button(action: {
        selectedIndex = 0
      }, label: {
        VStack {
          Image(systemName: "rectangle.3.offgrid.fill")
            .resizable()
            .frame(width: 25, height: 25, alignment: .center)
        }
      }).padding(.leading, 40)

      Button(action: {
        selectedIndex = 1
      }, label: {
        VStack {
          Image(systemName: "rectangle.stack.fill")
            .resizable()
            .frame(width: 25, height: 25, alignment: .center)
        }
      }).padding(.leading, 40)

      Button(action: {
        selectedIndex = 2
      }, label: {
        VStack {
          Image(systemName: "person.fill")
            .resizable()
            .frame(width: 25, height: 25, alignment: .center)
        }
      }).padding(.horizontal, 40)
    }
    .frame(maxWidth: .infinity, minHeight: 80)
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
