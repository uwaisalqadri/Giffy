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
import Common

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
  var router: FavoriteRouter

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      SearchInput { query in
        presenter.getList(request: query)
      }

      if !presenter.isLoading {
        if !presenter.list.isEmpty {
          ZStack {
            LazyVStack {
              ForEach(Array(presenter.list.enumerated()), id: \.offset) { _, item in
                SearchRow(giphy: item, router: Injection.shared.resolve())
                  .padding(.horizontal, 20)
                  .padding(.bottom, 20)
              }
            }.padding(.top, 20)
          }
        } else {
          SearchEmptyView()
            .padding(.top, 30)
        }
      } else {
        ActivityIndicator()
          .padding(.top, 10)
      }
    }.navigationTitle("search".localized())
      .navigationBarItems(
        trailing: NavigationLink(destination: router.routeFavorite()) {
          Image(systemName: "heart.fill")
            .resizable()
            .foregroundColor(.red)
            .frame(width: 20, height: 18)
        }
      )
      .navigationViewStyle(StackNavigationViewStyle())
      .padding(.top, 10)
      .onAppear {
        presenter.getList(request: "Hello")
      }
  }
}

struct SearchInput: View {

  @State var query = ""
  var onQueryChange: ((String) -> Void)?

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "magnifyingglass")
          .resizable()
          .foregroundColor(.white)
          .frame(width: 20, height: 20)
          .padding(.leading, 30)

        TextField("search_desc".localized(), text: $query, onCommit: {
          onQueryChange?(query)
        })
          .foregroundColor(.white)
          .font(.system(size: Common.isIpad ? 20 : 16))
          .frame(height: Common.isIpad ? 60 : 40)
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .padding(.leading, 13)
          .padding(.trailing, 30)
          .onChange(of: query) { text in
            onQueryChange?(text)
          }

      }.background(Color.init(.systemGray6))
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
  }
}

struct SearchEmptyView: View {
  var body: some View {
    VStack {
      LottieView(fileName: "search_empty", bundle: Common.loadBundle(), loopMode: .loop)
        .frame(width: 200, height: 200)
        .padding(.bottom, 5)

      Text("searching_giphy".localized())
        .padding(.horizontal, 40)
    }
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView(presenter: Injection.shared.resolve(), router: Injection.shared.resolve())
  }
}
