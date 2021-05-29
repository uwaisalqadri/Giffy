//
//  SearchView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI

struct SearchView: View {

  @ObservedObject var viewModel: SearchViewModel
  @State var searchText = ""
  @State var showPlayer = false

  var body: some View {
    NavigationView {
      ScrollView {
        searchInput
        if !viewModel.loadingState {
          ZStack {
            emptyView.padding(.top, 30)
            VStack {
              ForEach(viewModel.giphys) { item in
                SearchItemView(giphy: item)
                  .padding([.leading, .trailing], 10)
                  .sheet(isPresented: $showPlayer) {
                    DetailView(giphy: item)
                  }
                  .onTapGesture {
                    showPlayer = true
                  }
              }.padding(.top, 10)
            }
          }
        } else {
          ActivityIndicator()
            .padding(.top, 10)
        }
      }.navigationTitle("Search")
      .padding(.top, 10)
    }
  }

  var searchInput: some View {
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

  var emptyView: some View {
    VStack {
      Image(systemName: "magnifyingglass")
        .resizable()
        .foregroundColor(.green)
        .frame(width: 40, height: 40)
        .padding(.bottom, 5)

      Text("Search Something!")
        .foregroundColor(.green)
        .font(.system(size: 15, weight: .medium))
    }
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    let assembler = AppAssembler()
    SearchView(viewModel: assembler.resolve())
  }
}
