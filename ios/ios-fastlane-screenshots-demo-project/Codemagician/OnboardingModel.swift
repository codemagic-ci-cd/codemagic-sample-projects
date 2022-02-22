//
//  OnboardingModel.swift
//  Codemagician
//
//  Created by Rudrank Riyam on 14/02/22.
//

import Foundation

struct OnboardingModel {
  var title: String
  var description: String
  var image: String
}

extension OnboardingModel {
  static var demo = [
    OnboardingModel(title: "iOS CI/CD with Codemagic", description: "Set up your workflows in a single, easy-to-configure codemagic.yaml file. The file can be committed to version control, and when detected in the repository, will be used to configure the build.", image: "yaml-ios"),
    OnboardingModel(title: "Assure the quality of your app with automated tests for iOS", description: "Codemagic makes it easy to automate the testing of your iOS apps. You can choose to run tests on simulator, or on real devices using Firebase Test Lab, Browser Stack or AWS Device Farm. Codemagic will run automatic tests after every new commit to guarantee the health of your iOS apps.", image: "autotests"),
    OnboardingModel(title: "Use Codemagic CLI tools for code signing and creating an .ipa archive", description: "Codemagic offers a set of utilities known as Codemagic CLI Tools for facilitating the building and code signing of iOS apps built with native tooling, React Native or Flutter. The CLI tools are used for building and code signing during Codemagic builds but can be just as easily used on a local Mac or in other remote machines.", image: "cli-tools"),
    OnboardingModel(title: "Cut CI build times by 50% with App Store Connect Post-Processing Actions", description: "Don’t spend build minutes waiting for the uploaded artifact to become available on App Store Connect. Codemagic handles the App Store Connect operations asynchronously outside the build machine, allowing you to cut build times in half when updating release notes or submitting to Beta Review.", image: "post-processing"),
    OnboardingModel(title: "Get to the market 20% faster with continuous delivery", description: "Codemagic enables you to automatically publish your app to App Store Connect for beta testing with TestFlight or distributing the app to users via App Store. Just set up iOS code signing to publish IPAs to App Store Connect.", image: "market-ios")
  ]
}
