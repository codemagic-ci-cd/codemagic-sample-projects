Codemagic released the powerful M1 Mac mini for the developers to build and test their apps faster. This document contains tests run on popular open-source native iOS projects to give you an idea about the fast speed in a real-world scenario. 

Each project contains the links to the workflow configuration, and Codemagic builds for M1 Mac mini and Mac Pro workflows to explore the build times yourself.

> The build times are subjective and depend on external factors like the network speed for fetching resources, project size, external third-party dependencies, number of tests, etc.

## [Xcode Benchmark](https://github.com/devMEremenko/XcodeBenchmark)

The first project is the famous `XcodeBenchmark` used to provide an idea about the performance of M1 Mac mini and Mac Pro. It is a framework that includes **42 popular CocoaPods** libraries and **70+ dependencies** in total.

**Test name** | **M1 Mac mini** | **Mac Pro** | **Mac mini**
--- | --- | --- | ---
Running Benchmark Tests | **173s** | 497s | 572s


- [`codemagic.yaml`](https://github.com/nevercode-rudrank/XcodeBenchmark/blob/master/codemagic.yaml)

- M1 Mac mini Workflow [![Codemagic build status](https://api.codemagic.io/apps/6269b3cc6248df946a077233/ios-m1-mac-mini-workflow/status_badge.svg)](https://codemagic.io/app/6269b3cc6248df946a077233/build/62b16e3ee5cce72604e24675)

- Mac Pro Workflow [![Codemagic build status](https://api.codemagic.io/apps/6269b3cc6248df946a077233/ios-mac-pro-workflow/status_badge.svg)](https://codemagic.io/app/6269b3cc6248df946a077233/build/62b16e2d4f03039fc7d8d42d)

- Mac mini Workflow [![Codemagic build status](https://api.codemagic.io/apps/6269b3cc6248df946a077233/ios-mac-mini-workflow/status_badge.svg)](https://codemagic.io/app/6269b3cc6248df946a077233/build/62b16e454f03033493b1f807)


## [Signal iOS](https://github.com/signalapp/Signal-iOS)

**Signal** is a popular free, open-source messaging app for simple private communication with friends. It contains numerous dependencies and hundreds of tests.

**Test name** | **M1 Mac mini** | **Mac Pro** | **Mac mini**
--- | --- | --- | ---
Building and Running Tests with fastlane | **311s** | 685s | 1237s

- [`codemagic.yaml`](https://github.com/nevercode-rudrank/Signal-iOS/blob/master/codemagic.yaml)

- M1 Mac mini Workflow [![Codemagic build status](https://api.codemagic.io/apps/626e67f46248df64e0b79f91/ios-m1-mac-mini-workflow/status_badge.svg)](https://codemagic.io/app/626e67f46248df64e0b79f91/build/62b0b236dc456203b5704023)

- Mac Pro Workflow [![Codemagic build status](https://api.codemagic.io/apps/626e67f46248df64e0b79f91/ios-mac-pro-workflow/status_badge.svg)](https://codemagic.io/app/626e67f46248df64e0b79f91/build/62b0b236dc456203b5704022)

- Mac mini Workflow [![Codemagic build status](https://api.codemagic.io/apps/626e67f46248df64e0b79f91/ios-mac-mini-workflow/status_badge.svg)](https://codemagic.io/app/626e67f46248df64e0b79f91/build/62b0b236dc456203b5704024)

## [Wikipedia iOS](https://github.com/wikimedia/wikipedia-ios)

The official Wikipedia iOS app is open-sourced. It also contains multiple dependencies and hundreds of tests.

**Test name** | **M1 Mac mini** | **Mac Pro** | **Mac mini**
--- | --- | --- | ---
Building Project | **98s** | 186s | 259s
Running Tests | **163s** | 325s | 422s

- [`codemagic.yaml`](https://github.com/nevercode-rudrank/wikipedia-ios/blob/main/codemagic.yaml)

- M1 Mac mini Workflow [![Codemagic build status](https://api.codemagic.io/apps/6267c85aeb4a9a0e7b7eba1b/ios-m1-mac-mini-workflow/status_badge.svg)](https://codemagic.io/app/6267c85aeb4a9a0e7b7eba1b/build/62b0b1a8dc456203b5703f3d) 

- Mac Pro Workflow [![Codemagic build status](https://api.codemagic.io/apps/6267c85aeb4a9a0e7b7eba1b/ios-mac-pro-workflow/status_badge.svg)](https://codemagic.io/app/6267c85aeb4a9a0e7b7eba1b/build/62b0b1a8dc456203b5703f3c)

- Mac mini Workflow [![Codemagic build status](https://api.codemagic.io/apps/6267c85aeb4a9a0e7b7eba1b/ios-mac-mini-workflow/status_badge.svg)](https://codemagic.io/app/6267c85aeb4a9a0e7b7eba1b/build/62b0b1a8dc456203b5703f3e)
