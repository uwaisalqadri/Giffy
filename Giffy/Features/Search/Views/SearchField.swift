//
//  SearchField.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 28/4/24.
//

import SwiftUI
import CommonUI

struct SearchField: View {

  @State private var query = ""
  var onQueryChange: ((String) -> Void)?

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        TextField("", text: $query, prompt: Text(SearchString.labelSearchDesc.localized).foregroundColor(.gray))
          .font(.HelveticaNeue.s1SubtitleSemibold)
          .tint(.gray)
          .foregroundColor(.black)
          .frame(height: UIDevice.isIpad ? 60 : 40)
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .padding(.leading, 13)
          .padding(.trailing, 30)
          .onChange(of: query) { text in
            onQueryChange?(text)
          }
        
        if !query.isEmpty {
          Button(action: {
            query = ""
          }) {
            Image(systemName: "xmark.circle.fill")
              .resizable()
              .frame(width: 14, height: 14)
              .tint(.init(uiColor: .darkGray))
          }.padding(.trailing, 12)
        }
        
        Button(action: {
          onQueryChange?(query)
        }) {
          Image(systemName: "magnifyingglass")
            .resizable()
            .foregroundColor(.white)
            .frame(width: 20, height: 20)
            .background(
              LinearGradient(
                gradient: Gradient(
                  colors: [.Theme.red, .Theme.purple]
                ),
                startPoint: .bottomTrailing,
                endPoint: .topLeading
              )
              .frame(width: 40, height: 40)
              .cornerRadius(5, corners: [.topRight, .bottomRight])
            )
            .padding(.trailing, 10)
        }
      }
      .background(Color.white)
      .cornerRadius(5)
    }
  }
}
