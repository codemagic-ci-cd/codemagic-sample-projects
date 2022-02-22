//
//  OnboardingView.swift
//  Codemagician
//
//  Created by Rudrank Riyam on 14/02/22.
//

import SwiftUI

struct OnboardingView: View {
  var model: OnboardingModel

  var body: some View {
    VStack {
      Text(model.title)
        .font(.system(.title, design: .rounded))
        .bold()
        .multilineTextAlignment(.center)

      Spacer()

      Text(model.description)
        .font(.system(.body, design: .rounded))
        .lineSpacing(2)

      Spacer()

      Image(model.image)
        .resizable()
        .scaledToFit()

      Spacer()
    }
    .padding()
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView(model: .demo.first!)
  }
}
