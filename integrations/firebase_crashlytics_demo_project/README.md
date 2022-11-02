# Uploading dSYM artifacts to Firebase Crashlytics

**dSYM** files store the debug symbols for your app. They contain mapping information to decode a stack-trace into a readable format. The purpose of **dSYM** is to replace symbols in the crash logs with the specific methods so it will be readable and helpful for debugging the crash. 

This sample project shows how to upload your **dSYM** files to Firebase Crashlytics using Codemagic. This particular project is built using Flutter but the same steps can be applied to other types of applications with minimal changes. To get a more detailed guide of basic project steps such as building, build versioning, code signing and publishing in general, please see the [Flutter Android and iOS](https://github.com/codemagic-ci-cd/codemagic-sample-projects/tree/main/flutter/flutter-android-and-ios-yaml-demo-project) project or the corresponding sample project for your platform from [our repository](https://github.com/codemagic-ci-cd/codemagic-sample-projects/tree/main/integrations/firebase_crashlytics_demo_project).
## Getting Started

In order to generate debug symbols, Firebase Crashlytics must be installed using the following script in your `codemagic.yaml`:


```yaml
  scripts:
    - name: Install Firebase Crashlytics
      script: | 
        flutter pub add firebase_crashlytics
```

Alternatively, **firebase_crashlytics: ^2.5.2** could be added in the **pubspec.yaml** file under **dependencies**:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_crashlytics: ^2.5.2
```

## Getting the dSYM file

As soon as your build finishes successfully, debug symbols are generated. However, if you want them to be displayed in the Codemagic UI on the build page, then the following path needs to be configured in `codemagic.yaml` under the artifacts section:

```yaml
  artifacts:
    - $HOME/Library/Developer/Xcode/DerivedData/**/Build/**/*.dSYM
```

## Uploading to Firebase Crashlytics

### Flutter

In order to upload the dSYM files to Firebase Crashlytics, add the following script to your `codemagic.yaml` configuration file or to your post-publish script in the Flutter workflow editor: 

```yaml
publishing:
  scripts:
    - name: Upload debug symbols to Firebase Crashlytics
      script: | 
        echo "Find build artifacts"
        dsymPath=$(find $CM_BUILD_DIR/build/ios/archive/Runner.xcarchive -name "*.dSYM" | head -1)
        if [[ -z ${dsymPath} ]]
        then
          echo "No debug symbols were found, skip publishing to Firebase Crashlytics"
        else
          echo "Publishing debug symbols from $dsymPath to Firebase Crashlytics"
          ls -d -- ios/Pods/*
          $CM_BUILD_DIR/ios/Pods/FirebaseCrashlytics/upload-symbols \
            -gsp ios/Runner/GoogleService-Info.plist -p ios $dsymPath
        fi
```

### Others

The above-mentioned **dsymPath** is Flutter specific and it could change depending on what platform the app is built. E.g., for React Native or Native iOS applications you might use:

```yaml
dsymPath=$(find $CM_BUILD_DIR/build/ios/xcarchive/*.xcarchive -name "*.dSYM" | head -1)
```

If necessary, you can use remote access to the build machine to find the correct path. More information can be found [here](https://docs.codemagic.io/troubleshooting/accessing-builder-machine-via-ssh).


## iOS apps using SwiftPackageManager (SPM)

For Native iOS apps, in the case of using SwiftPackageManager (SPM) instead of CocoaPods, the following script needs to be added in a post-publishing script:

```yaml
  scripts:
    - name: Upload debug symbols to Firebase Crashlytics
      script: | 
        echo "Find build artifacts"
        dsymPath=$(find build/ios/xcarchive/* | head -1)
        echo "dsyms expected in:"
        ls -d -- $dsymPath/dSYMs/*
        dsymFile=$(find $dsymPath/dSYMs -name "*.dSYM" | head -1) 
        if [[ -z ${dsymFile} ]]
          then
            echo "No debug symbols were found, skip publishing to Firebase Crashlytics"
          else
            echo "Publishing debug symbols in $dsymFile to Firebase Crashlytics"
            echo $dsymFile
            ls -d -- $CM_BUILD_DIR/*
            $HOME/Library/Developer/Xcode/DerivedData/**/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols \
              -gsp $CM_BUILD_DIR/<PATH_TO_YOUR_GoogleService-Info.plist> -p ios $dsymFile
        fi
```