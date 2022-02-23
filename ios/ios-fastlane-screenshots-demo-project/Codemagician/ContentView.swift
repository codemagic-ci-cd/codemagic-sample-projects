//
//  ContentView.swift
//  Codemagician
//
//  Created by Rudrank Riyam on 04/02/22.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      ForEach(OnboardingModel.demo, id: \.title) { model in
        OnboardingView(model: model)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .always))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
