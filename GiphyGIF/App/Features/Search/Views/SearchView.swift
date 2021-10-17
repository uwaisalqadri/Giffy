//
//  SearchView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Lottie

struct SearchView: View {

  @ObservedObject var viewModel: SearchViewModel
  @State var searchText = ""

  var body: some View {
    NavigationView {
      ScrollView {
        SearchInput(viewModel: viewModel)
        if !viewModel.loadingState {
          ZStack {
            NotSearchView()
              .padding(.top, 30)
            LazyVStack {
              ForEach(viewModel.giphys) { item in
                SearchItemView(giphy: item)
                  .padding([.leading, .trailing], 10)
              }.padding(.top, 10)
            }
          }
        } else if viewModel.giphys.isEmpty {
          NoResultView()
            .padding(.top, 30)
        } else {
          ActivityIndicator()
            .padding(.top, 10)
        }
      }.navigationTitle("Search")
      .padding(.top, 10)
    }
  }
}

struct SearchInput: View {

  @ObservedObject var viewModel: SearchViewModel

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        TextField("Search giphy..", text: $viewModel.searchText)
          .font(.system(size: 18, weight: .medium))
          .padding(.horizontal, 15)
          .frame(height: 40)
          .background(
            ZStack(alignment: .trailing) {
              RoundedRectangle(cornerRadius: 7)
                .fill(Color(.systemGray6))

              Image(systemName: "magnifyingglass")
                .foregroundColor(Color(.systemGray2))
                .padding(.trailing, 13)
            }
          ).padding(.horizontal, 20)
      }
    }
  }
}

struct NotSearchView: View {
  var body: some View {
    VStack {
      LottieView(fileName: "search-icon", loopMode: .loop)
        .frame(width: 150, height: 150)
        .padding(.bottom, 5)
      Text("Search Something!")
        .font(.system(.subheadline))
        .foregroundColor(.blue)
    }
  }
}

struct NoResultView: View {
  var body: some View {
    VStack {
      LottieView(fileName: "search-no-result", loopMode: .loop)
        .frame(width: 200, height: 200)
        .padding(.bottom, 5)
    }
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    let assembler = AppAssembler()
    SearchView(viewModel: assembler.resolve())
  }
}
