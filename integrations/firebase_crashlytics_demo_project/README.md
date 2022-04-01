# firebase crashlytics demo project


## Getting Started

In order to generate debug symbols, Firebase Crashlytics SDK must be installed using the following command line:

```
flutter pub add firebase_crashlytics
```

Or as an alternative it could be added in the **pubspec.yaml**:

```
dependencies:
  flutter:
    sdk: flutter
  firebase_crashlytics: ^2.5.2
```

As soon as your build finishes successfully, debug symbols are generated, however if they need them to be present in the **Codemagic UI**, then the following path needs to be configured in **codemagic.yaml** under the artifacts section:
```
 - $HOME/Library/Developer/Xcode/DerivedData/**/Build/**/*.dSYM
```
More information about **codemagic.yaml** can be found [here](https://docs.codemagic.io/yaml/yaml-getting-started/)

With the help of the following bash script that needs to be present under a post-publishing script (a script that needs to be run after building your artifacts binaries), **dSYM** files are found and uploaded to Firebase Crashlytics:

  ```bash
  echo "Find build artifacts"
  dsymPath=$(find $CM_BUILD_DIR/build/ios/archive/Runner.xcarchive -name "*.dSYM" | head -1)
  if [[ -z ${dsymPath} ]]
  then
    echo "No debug symbols were found, skip publishing to Firebase Crashlytics"
  else
    echo "Publishing debug symbols from $dsymPath to Firebase Crashlytics"
    ls -d -- ios/Pods/*
    $CM_BUILD_DIR/ios/Pods/FirebaseCrashlytics/upload-symbols -gsp ios/Runner/GoogleService-Info.plist -p ios $dsymPath
  fi
  ```
