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
    String, [Giphy], GiphyRepository<
      SearchRemoteDataSource
    >
  >
>

struct SearchView: View {

  @ObservedObject var presenter: SearchPresenter
  @State var searchText = ""

  var body: some View {
    NavigationView {
      ScrollView {
        SearchInput(presenter: presenter)
        if !presenter.isLoading {
          ZStack {
            NotSearchView()
              .padding(.top, 30)
            LazyVStack {
              ForEach(0..<10) { item in
//                _ = print(item)
                Text("\(item)")
                  .foregroundColor(.white)
                  .onAppear {
                    print(item)
                  }
              }
//              ForEach(presenter.list.indices, id: \.self) { item in
//                SearchItemView(giphy: item)
//                  .padding([.leading, .trailing], 10)
//              }
            }.padding(.top, 10)
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
        presenter.getList(request: "Naruto")
      }
    }
  }


  struct SearchInput: View {

    @ObservedObject var presenter: SearchPresenter

    var body: some View {
      VStack(alignment: .leading) {
        //        HStack {
        //          TextField("Search giphy..", text: $presenter.searchText)
        //            .font(.system(size: 18, weight: .medium))
        //            .padding(.horizontal, 15)
        //            .frame(height: 40)
        //            .background(
        //              ZStack(alignment: .trailing) {
        //                RoundedRectangle(cornerRadius: 7)
        //                  .fill(Color(.systemGray6))
        //
        //                Image(systemName: "magnifyingglass")
        //                  .foregroundColor(Color(.systemGray2))
        //                  .padding(.trailing, 13)
        //              }
        //            ).padding(.horizontal, 20)
        //        }
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
}
