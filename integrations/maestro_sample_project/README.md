# Maestro and Codemagic integration demo project

This sample project show you a simple test flow that increment the counter multiple times and decrement it.


[**Maestro UI testing framework**](https://mobile.dev/) from `Mobile.dev` lets you test your iOS and Android mobile apps using simple to-create test flows.

Read the full documentation page [here](https://docs.codemagic.io/integrations/maestro-integration/).

## Managing Maestro flows
After you have created your YAML tests flows inside the `.maestro` directory, you need to check the directory into your project repository.

## Installing Maestro CLI
Before you use maestro commands, you need first to simply install the CLI on the building machine using this command in your `codemagic.yaml` file.

```
scripts:
    - name: Download Maestro
      script: curl -Ls "https://get.maestro.mobile.dev" | bash
```


## Uploading to Maestro Cloud

First, you need to build your **Android (.apk) / iOS (.app)** apps, then use the `maestro cloud` command to test your app.

### Android 

See how to build your native android app [here](https://docs.codemagic.io/yaml-quick-start/building-a-native-android-app/) or your Flutter app [here](https://docs.codemagic.io/yaml-quick-start/building-a-flutter-app/).

Add the following script to your `publishing` section:

```
publishing:
    scripts:
    - name: Run tests on Maestro cloud
        script: | 
        export PATH="$PATH":"$HOME/.maestro/bin"
        apkPath="/build/app/outputs/apk/release/app-release.apk"
        maestro cloud \
        --apiKey $MDEV_API_KEY \
        $apkPath \
        .maestro/
```

> **Note:** Don't forget to change the value of the `apkPath` to your actual apk path.

### iOS
For iOS, you need to upload your x86-compatible Simulator `.app` directory.

Here's the script on how you can build it.

```
scripts:
    - name: Build unsigned .app
    script: | 
        xcodebuild \
        -workspace "ios/$XCODE_WORKSPACE" \
        -scheme "$XCODE_SCHEME" \
        -configuration "Debug" \
        -sdk iphonesimulator \
        -derivedDataPath ios/output
```


> **Note:** Don't forget to add the environment variables that holds your XCode workspace name under `$XCODE_WORKSPACE` and the Scheme name under `$XCODE_SCHEME`. See the complete sample project [here](https://github.com/codemagic-ci-cd/codemagic-sample-projects/tree/main/integrations/maestro_integration_demo_project/codemagic.yaml).


If your Codemagic's build has failed at the Maestro cloud step, then your tests have failed. Otherwise, everything went well and you can check out the build page for more details.