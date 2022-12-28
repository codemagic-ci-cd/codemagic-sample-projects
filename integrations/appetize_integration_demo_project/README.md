# Appetize and Codemagic integration demo project

[**Appetize**](https://appetize.io/) enables you to run native iOS and Android mobile apps directly in your browser. No downloads, plugins, or extra permissions needed. 

## Configure Appetize access

Before getting started you will need to generate an **Appetize API token** and a **public key** for your app.

#### Get Appetize token
All users with admin or developer roles may request an **API token** after logging in to your Appetize [account](https://appetize.io/account) page.
After getting your **API_TOKEN** you need to add it to your [environment variables](https://docs.codemagic.io/variables/environment-variable-groups/#storing-sensitive-valuesfiles) in a group named **appetize** for example.

#### Get the public key for your app 
To get a **public key** for your app, **you first have to upload your app manually** at least once to [Appetize](https://appetize.io/upload). After that, you can get the app **publicKey** and add it as an environment variable.

#### Configure environment variables

1. Open your Codemagic app settings, and go to the **Environment variables** tab.
2. Enter the desired **_Variable name_**, e.g. `APPETIZE_API_TOKEN`.
3. Enter the desired variable value as **_Variable value_**.
4. Enter the variable group name, e.g. **_appetize_credentials_**. Click the button to create the group.
5. Make sure the **Secure** option is selected.
6. Click the **Add** button to add the variable.
7. Repeat the steps to add the `APPETIZE_APP_PUBLIC_KEY`.

8. Add the variable group to your `codemagic.yaml` file
``` yaml
  environment:
    groups:
      - appetize_credentials
```

## Uploading to Appetize

After you have uploaded your app to Appetize manually once and configured the app public key, you can configure automatic publishing in your `codemagic.yaml`.

### Android
Add the following script to your `publishing` section:
``` yaml
  publishing:
    scripts:
      - name: Publish APK to Appetize
        script: | 
          apkPath="/build/app/outputs/flutter-apk/app-release.apk"
          echo $(curl --location --request POST 'https://'$API_TOKEN'@api.appetize.io/v1/apps/'$APP_PUBLIC_KEY'' --form 'file=@"'$apkPath'"')
```

Don't forget to change the value of the `apkPath` to your actual apk path.

### iOS
For iOS, you need to upload a `.zip` or `.tar.gz` file containing your compressed `.app` bundle. The whole process will consist of:
- building the app
- creating a `.zip` archive
- publishing to Appetize

``` yaml
  scripts:
    - name: Build unsigned .app
      script: | 
        xcodebuild -workspace "ios/Runner.xcworkspace" \
          -scheme "$XCODE_SCHEME" \
          -configuration "Debug" \
          -sdk iphonesimulator \
          -derivedDataPath ios/output
        # If you are building a project instead of a workspace:
        # xcodebuild -project "ios/Runner.xcodeproj" \
        #   -scheme "$XCODE_SCHEME" \
        #   -configuration "Debug" \
        #   -sdk iphonesimulator \
        #   -derivedDataPath ios/output
    - name: Create a .zip archive
      script: | 
        cd ios/output/Build/Products/Debug-iphonesimulator
        zip -r ios_app.zip $XCODE_SCHEME.app
  artifacts:
    - ios/output/Build/Products/Debug-iphonesimulator/*.zip
  publishing:
    scripts:
      - name: Publish App to Appetize
        script: | 
          zipPath="ios/output/Build/Products/Debug-iphonesimulator/ios_app.zip"
          echo $(curl --location --request POST "https://$API_TOKEN@api.appetize.io/v1/apps/$APP_PUBLIC_KEY" --form "file=@$zipPath")
```

Don't forget to change the value of the `zipPath` to your actual apk path.
