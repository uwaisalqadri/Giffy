//
//  SearchView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Lottie
import Core
import Giphy

typealias SearchPresenter = GetListPresenter<
  String, Giphy, Interactor<
    String, [Giphy], SearchGiphyRepository<
      SearchRemoteDataSource
    >
  >
>

struct SearchView: View {

  @ObservedObject var presenter: SearchPresenter
  @State var searchText = ""

  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        SearchInput(presenter: presenter)
        if !presenter.isLoading {
          ZStack {
            NotSearchView()
              .padding(.top, 30)
            LazyVStack {
              ForEach(Array(presenter.list.enumerated()), id: \.offset) { index, item in
                SearchItemView(giphy: item)
                  .padding(.horizontal, 10)
              }
            }.padding(.top, 20)
          }
        } else if presenter.list.isEmpty {
          NoResultView()
            .padding(.top, 30)
        } else {
          ActivityIndicator()
            .padding(.top, 10)
        }
      }
      .navigationTitle("Search")
      .padding(.top, 10)
      .onAppear {
        presenter.getList(request: "Hello")
      }
    }
  }
}

struct SearchInput: View {

  @State var presenter: SearchPresenter
  @State var query = ""

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "magnifyingglass")
          .resizable()
          .foregroundColor(.white)
          .frame(width: 20, height: 20)
          .padding(.leading, 30)

        TextField("Search Giphy...", text: $query, onCommit: {
          presenter.getList(request: query)
        })
          .foregroundColor(.white)
          .font(.system(size: 16))
          .frame(height: 40)
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .padding(.leading, 13)
          .padding(.trailing, 30)
          .onChange(of: query) { text in
            presenter.getList(request: text)
          }

      }.background(Color.init(.systemGray6))
      .cornerRadius(20)
      .padding(.horizontal, 20)
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
    SearchView(presenter: Injection.shared.resolve())
  }
}
