Codemagic defaults to powerful M1 Mac minis for developers to build and test their apps faster. 

This document contains builds of popular open-source Flutter projects on Codemagic M1 builders to give you an idea of the build speeds in real-world scenarios. 

Each project contains the links to the workflow configuration, and Codemagic builds for M1 Mac mini  to explore the build times for yourself.

> The build times are **indicative only** and depend on external factors such as the network speed when fetching resources, specifics of running tests, etc.


## [Flutter Wonderous App](https://github.com/gskinnerTeam/flutter-wonderous-app)

The first project is the showcase `Flutter Wonderous App` from the team at GSkinner. 

With approximately 18k lines of Dart code and 38 direct package dependencies it provides an example of a substantially sized Flutter app.

**Task** | **M1 Mac mini**
--- | ---
flutter build appbundle --debug | **101s**
flutter build ios --debug --no-codesign | **53s**

* [codemagic.yaml](https://github.com/maks/flutter-wonderous-app/blob/benchmarking/codemagic.yaml)
* M1 Mac mini Workflow [![Codemagic build status](https://api.codemagic.io/apps/63acf28a11b04117f53c4373/default-workflow/status_badge.svg)](https://codemagic.io/apps/63acf28a11b04117f53c4373/default-workflow/latest_build)