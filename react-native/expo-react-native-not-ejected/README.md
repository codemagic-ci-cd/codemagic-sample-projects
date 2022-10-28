# Expo React Native app not ejected sample app. 

This sample project illustrates all of the necessary steps to successfully build and publish a React Native Android and iOS apps with Codemagic when using Expo and without having to eject the app beforehand. It covers the basic steps such as build versioning, code signing and publishing.

You can find a more detailed instruction as well numerous guides to advanced features in our [official documentation](https://docs.codemagic.io/yaml-quick-start/building-a-react-native-app/).

> **Note**: This project is nearly identical to the [React Native Android and iOS](https://github.com/codemagic-ci-cd/codemagic-sample-projects/tree/main/react-native/react-native-demo-project) project. The only differences are a couple of extra steps specific to building Expo projects without ejecting.

## Using Expo without ejecting

To run a build on CI/CD we need to have the `ios` and `android` project folders. If you can't or don’t want to permanently eject Expo from your app, then you can do it on the build server each time you run a build. Follow the steps below to get started.

1. Clone your repository to a temporary new location or create a new branch. in order to eject Expo once and get the `android/app/build.gradle` file.
2. Eject Expo once by running the following command:
```bash
expo eject
```
3. Copy the `android/app/build.gradle` file from the ejected project and add it to your main repository. In our example, we create a `support-files` folder and store the `build.gradle` inside.

4. Follow the steps in [React Native Android and iOS](https://github.com/codemagic-ci-cd/codemagic-sample-projects/tree/main/react-native/react-native-demo-project) guide and whenever it calls for making changes to the `android/app/build.gradle`, apply these changes to the `support-files/build.gradle` file instead.

5. Apply the additional steps listed below to install the expo cli tools on the VM, run the scripts to copy the `build.gradle` file to the correct location and use other tools to adjust iOS settings in the `info.plist` file.


## Setting up the Android package name and iOS bundle identifier
Configure Android package name and iOS bundle identifier by adding the corresponding variables in the `codemagic.yaml` and editing the `app.json` files.

Example of minimal `app.json` file. Add the `android` and/or `ios` keys:
``` json
{
  "expo": {
    "name": "codemagicSample",
    "slug": "codemagicSample",
    "version": "1.0.0",
    "assetBundlePatterns": [
      "**/*"
    ],
    "ios": {
      "bundleIdentifier": "io.codemagic.sample.reactnative"
    },
    "android": {
      "package": "io.codemagic.sample.reactnative"
    }
  }
}
```

### Android

``` yaml
workflows:
  react-native-android:
    # ....
    environment:
      groups:
        # ...
      vars:
        PACKAGE_NAME: "io.codemagic.sample.reactnative"
```

## Expo specific build steps
Add these script steps in addition to the ones described in the general React Native guide.

### Android
Add the following scripts just after the **Install npm dependencies** step:

``` yaml
scripts:
  - name: Install Expo CLI and eject
    script: | 
      npm install -g expo-cli
      expo eject
  - name: Set up app/build.gradle
    script: | 
      mv ./support-files/build.gradle android/app
```

### iOS
Add the following scripts at the start of the scripts section:

``` yaml
scripts:
  - name: Install Expo CLI and eject
    script: | 
      yarn install
      yarn global add expo-cli
      expo eject
  - name: Set Info.plist values
    script: | 
      PLIST=$CM_BUILD_DIR/$XCODE_SCHEME/Info.plist
      PLIST_BUDDY=/usr/libexec/PlistBuddy
      $PLIST_BUDDY -c "Add :ITSAppUsesNonExemptEncryption bool false" $PLIST
  - name: Install CocoaPods dependencies
    script: | 
      cd ios && pod install
```