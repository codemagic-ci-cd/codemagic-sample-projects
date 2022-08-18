# Appetize and Codemagic integration demo project

[**Appetize**](https://appetize.io/) enables you to run native iOS and Android mobile apps directly in your browser. No downloads, plugins, or extra permissions needed. 

## Getting Started
Before getting started you need to get some tokens and keys.

### Get Appetize Token
All users with admin or developer roles may request an API token after logging in at [account](https://appetize.io/account) page.
After getting your **API_TOKEN** you need to add it to your [environment variables](/variables/environment-variable-groups/#storing-sensitive-valuesfiles) in a group named **appetize** for example.

### Get Your App PublicKey
You have at least to upload your app once to [Appetize](https://appetize.io/upload) manually and then you can get the app *publicKey*.
in your *codemagic.yaml* file add the app key as a variable.

```yaml
    environment:
      groups:
        - appetize # <-- (Includes API_TOKEN)
      vars:
        APP_PUBLIC_KEY: "YOUR_APP_PUBLIC_KEY"
```

## Uploading Android App
The following script will help you achieving the deployment process:

```yaml
- name: Publish APK to Appetize
  script: | 
    apkPath="/build/app/outputs/flutter-apk/app-release.apk"
    echo $(curl --location --request POST 'https://'$API_TOKEN'@api.appetize.io/v1/apps/'$APP_PUBLIC_KEY'' --form 'file=@"'$apkPath'"')
```
Change the value of the `apkPath` to your actual apk path.

## Uploading iOS App
For iOS, you need to upload a `.zip` or `.tar.gz` file containing your compressed `.app` bundle.

### Xcode Build
You can run one of these commands to get your `.app`:
```yaml
- name: Build unsigned .app
  script: | 
    xcodebuild -workspace "ios/Runner.xcworkspace" -scheme "$XCODE_SCHEME" -configuration "Debug" -sdk iphonesimulator -derivedDataPath ios/output
    xcodebuild -project   "ios/Runner.xcodeproj"   -scheme "$XCODE_SCHEME" -configuration "Debug" -sdk iphonesimulator -derivedDataPath ios/output
```

Then you need to zip the generated `.app` folder:

```yaml
- name: zip App.app
  script: | 
    cd ios/output/Build/Products/Debug-iphonesimulator
    zip -r ios_app.zip $XCODE_SCHEME.app
```
Don't forget to set the value of your `XCODE_SCHEME` variable.

### Upload the .zip File
The following script will help you achieving the deployment process:

```yaml
- name: Publish App to Appetize
  script: | 
    zipPath="ios/output/Build/Products/Debug-iphonesimulator/ios_app.zip"
    echo $(curl --location --request POST 'https://'$API_TOKEN'@api.appetize.io/v1/apps/'$APP_PUBLIC_KEY'' --form 'file=@'"$zipPath"'')
```
Change the value of the `zipPath` to your actual apk path.

## Documentation

Check out the official docs from [here](https://docs.codemagic.io/integrations/appetize-integration/).
