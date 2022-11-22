# Ionic with Capacitor sample project

This sample project illustrates all of the necessary steps to successfully build and publish Ionic + Capacitor Android and iOS apps with Codemagic. It covers the basic steps such as build versioning, code signing and publishing.

You can find a more detailed instruction as well numerous guides to advanced features in our [official documentation](https://docs.codemagic.io/yaml-quick-start/building-an-ionic-app/).

> **Note**: This app was created using the `npx @capacitor/cli create` command which comes with a very minimal shell for building an app.
For the production projects, you will likely want to create an app using your framework's tooling (such as `create-react-app`), and then *add* capacitor to *that* project (using `npx @capacitor/cli init`).

### Running this example

To run the provided example, can use serve command:

```bash
npx cap serve
```


## Adding the app to Codemagic
The apps you have available on Codemagic are listed on the Applications page. Click **Add application** to add a new app.

1. If you have more than one team configured in Codemagic, select the team you wish to add the app to.
2. Connect the repository where the source code is hosted. Detailed instructions that cover some advanced options are available [here](https://docs.codemagic.io/getting-started/adding-apps/).
3. Select the repository from the list of available repositories. Select the appropriate project type.
4. Click **Finish: Add application**

## Creating codemagic.yaml
Codemagic uses a YAML configuration file to configure the CI/CD workflow. The name of the file must be `codemagic.yaml` and it must be located in the root directory of the repository. This sample project includes a `codemagic.yaml` file covering all of the steps outlined below. You can update the file with your own information and reuse it to build your own projects.

## Code signing - Android
All applications have to be digitally signed before they are made available to the public to confirm their author and guarantee that the code has not been altered or corrupted since it was signed.

### Generating a keystore
If you don't have one yet, you can create a keystore for signing your release builds with the Java Keytool utility by running the following command:

```bash
keytool -genkey -v -keystore codemagic.keystore -storetype JKS \
        -keyalg RSA -keysize 2048 -validity 10000 -alias codemagic
```

Keytool then prompts you to enter your personal details for creating the certificate, as well as provide passwords for the keystore and the key. It then generates the keystore as a file called **codemagic.keystore** in the directory you're in. The key is valid for 10,000 days.

### Uploading a keystore

1. Open your Codemagic Team settings, and go to  **codemagic.yaml settings** > **Code signing identities**.
2. Open **Android keystores** tab.
3. Upload the keystore file by clicking on **Choose a file** or by dragging it into the indicated frame.
4. Enter the **Keystore password**, **Key alias** and **Key password** values as indicated.
5. Enter the keystore **Reference name**. This is a unique name used to reference the file in `codemagic.yaml`
6. Click the **Add keystore** button to add the keystore.

For each of the added keystore, its common name, issuer, and expiration date are displayed.

> **Note**: The uploaded keystore cannot be downloaded from Codemagic. It   is crucial that you independently store a copy of the keystore file as all subsequent builds released to Google Play should be signed with the same keystore.
However, keep the keystore file private and do not check it into a public repository.

### Referencing keystores in codemagic.yaml

To tell Codemagic to fetch the uploaded keystores from the **Code signing identities** section during the build, list the reference of the uploaded keystore under the `android_signing` field.

Add the following code to the `environment` section of your `codemagic.yaml` file:

```yaml
workflows:
  android-workflow:
    name: Android Workflow
    # ....
    environment:
      android_signing:
        - keystore_reference
```

Default environment variables are assigned by Codemagic for the values on the build machine:

- Keystore path: `CM_KEYSTORE_PATH`
- Keystore password: `CM_KEYSTORE_PASSWORD`
- Key alias: `CM_KEY_ALIAS`
- Key alias password: `CM_KEY_PASSWORD`

### Signing Android apps using Gradle

To sign your Android app, simply modify your **`android/app/build.gradle`** as follows:

```groovy
...
  android {
      ...
      defaultConfig { ... }
      signingConfigs {
          release {
              if (System.getenv()["CI"]) { // CI=true is exported by Codemagic
                  storeFile file(System.getenv()["CM_KEYSTORE_PATH"])
                  storePassword System.getenv()["CM_KEYSTORE_PASSWORD"]
                  keyAlias System.getenv()["CM_KEY_ALIAS"]
                  keyPassword System.getenv()["CM_KEY_PASSWORD"]
              } else {
                  keyAlias keystoreProperties['keyAlias']
                  keyPassword keystoreProperties['keyPassword']
                  storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
                  storePassword keystoreProperties['storePassword']
              }
          }
      }
      buildTypes {
          release {
              ...
              signingConfig signingConfigs.release
          }
      }
  }
  ...
```

## Code signing - iOS

### Creating the App Store Connect API key
Signing iOS applications requires [Apple Developer Program](https://developer.apple.com/programs/enroll/) membership.

It is recommended to create a dedicated App Store Connect API key for Codemagic in [App Store Connect](https://appstoreconnect.apple.com/access/api). To do so:

1. Log in to App Store Connect and navigate to **Users and Access > Keys**.
2. Click on the + sign to generate a new API key.
3. Enter the name for the key and select an access level. We recommend choosing `App Manager` access rights, read more about Apple Developer Program role permissions [here](https://help.apple.com/app-store-connect/#/deve5f9a89d7).
4. Click **Generate**.
5. As soon as the key is generated, you can see it added to the list of active keys. Click **Download API Key** to save the private key for later. Note that the key can only be downloaded once.

### Adding the App Store Connect API key to Codemagic

1. Open your Codemagic Team settings, and go to **Team integrations** > **Developer Portal** > **Manage keys**.
2. Click the **Add key** button.
3. Enter the `App Store Connect API key name`. This is a human readable name for the key that will be used to refer to the key later in application settings.
4. Enter the `Issuer ID` and `Key ID` values.
5. Click on **Choose a .p8 file** or drag the file to upload the App Store Connect API key downloaded earlier.
6. Click **Save**.

### Adding the code signing certificate

Codemagic lets you upload code signing certificates as PKCS#12 archives containing both the certificate and the private key which is needed to use it. When uploading, Codemagic will ask you to provide the certificate password (if the certificate is password-protected) along with a unique **Reference name**, which can then be used in the `codemagic.yaml` configuration to fetch the specific file.

1. Open your Codemagic Team settings, and go to  **codemagic.yaml settings** > **Code signing identities**.
2. Open **iOS certificates** tab.
3. Upload the certificate file by clicking on **Choose a .p12 or .pem file** or by dragging it into the indicated frame.
4. Enter the **Certificate password** and choose a **Reference name**.
5. Click **Add certificate**


> **Note:** If you do not yet have a Signing certificate, you can have Codemagic create a new certificate automatically or fetch a previously created one. Please check the [iOS code signing](https://docs.codemagic.io/yaml-code-signing/signing-ios/#adding-the-code-signing-certificate) documentation for details.


### Adding the provisioning profile

Codemagic allows you to upload a provisioning profile to be used for the application or to fetch a profile from the Apple Developer Portal.

The profile's type, team, bundle id, and expiration date are displayed for each profile added to Code signing identities. Furthermore, Codemagic will let you know whether a matching code signing certificate is available in Code signing identities (a green checkmark in the **Certificate** field) or not.

You can upload provisioning profiles with the `.mobileprovision` extension, providing a unique **Reference name** is required for each uploaded profile.

1. Open your Codemagic Team settings, and go to  **codemagic.yaml settings** > **Code signing identities**.
2. Open **iOS provisioning profiles** tab.
3. Upload the provisioning profile file by clicking on **Choose a .mobileprovision file** or by dragging it into the indicated frame.
4. Enter the **Reference name** for the profile.
5. Click **Add profile**.


### Referencing certificates and profiles in codemagic.yaml
To fetch all uploaded signing files matching a specific distribution type and bundle identifier during the build, define the `distribution_type` and `bundle_identifier` fields in your `codemagic.yaml` configuration. Note that it is necessary to configure **both** of the fields.

``` yaml
workflows:
  ios-workflow:
    name: iOS Workflow 
    # ....
    environment:
      ios_signing:
        distribution_type: app_store # or: ad_hoc | development | enterprise
        bundle_identifier: com.example.id
```

> **Note:** If you are publishing to the **App Store** or you are using **TestFlight**  to distribute your app to test users, set the `distribution_type` to `app_store`. 
When using a **third party app distribution service** such as Firebase App Distribution, set the `distribution_type` to `ad_hoc`

### Using provisioning profiles

To apply the profiles to your project during the build, add the following script before your build scripts:

``` yaml
  scripts:
    # ... your dependencies installation
    
    - name: Set up code signing settings on Xcode project
      script: xcode-project use-profiles
    
    # ... your build commands
```

## Configure scripts to build the app
Add the following scripts to your `codemagic.yaml` file in order to prepare the build environment and start the actual build process.
In this step, you can also define the build artifacts you are interested in. These files will be available for download when the build finishes. For more information about artifacts, see [here](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/#artifacts).

### Android
``` yaml
  scripts:
    - name: Install npm dependencies for Ionic Capacitor project
      script: | 
        npm install
    - name: Set up local.properties
      script: | 
        echo "sdk.dir=$ANDROID_SDK_ROOT" > "$CM_BUILD_DIR/android/local.properties"
    - name: Update dependencies and copy web assets to native project
      script: | 
        # if you don't need to update native dependencies, use this:
        # npx cap copy

        # to update native dependencies, use this command:
        npx cap sync
    - name: Build Android release
      script: | 
        cd android
        ./gradlew assembleRelease
  artifacts:
    - android/app/build/outputs/**/*.apk
```

### iOS
``` yaml
  environment:
    vars:
      XCODE_WORKSPACE: "platforms/ios/YOUR_APP.xcworkspace"
      XCODE_SCHEME: "YOUR_SCHEME"
  scripts:
    - name: Install npm dependencies for Ionic Capacitor project
      script: | 
        npm install
    - name: Cocoapods installation
        script: | 
          cd ios/App && pod install
    - name: Update dependencies and copy web assets to native project
      script: | 
        # if you don't need to update native dependencies, use this:
        # npx cap copy
        #
        # to update native dependencies, use this command:
        npx cap sync
    - name: Set up code signing settings on Xcode project
      script: | 
        xcode-project use-profiles
    - name: Build ipa for distribution
      script: | 
          cd ios/App
          xcode-project build-ipa --workspace "$XCODE_WORKSPACE" --scheme "$XCODE_SCHEME"
    artifacts:
      - build/ios/ipa/*.ipa
      - /tmp/xcodebuild_logs/*.log
      - $HOME/Library/Developer/Xcode/DerivedData/**/Build/**/*.app
      - $HOME/Library/Developer/Xcode/DerivedData/**/Build/**/*.dSYM
```

## Build versioning
If you are going to publish your app to Google Play or App Store, each uploaded artifact must have a new version. Codemagic allows you to easily automate this process and increment the version numbers for each build. For more information and details, see [here](https://docs.codemagic.io/knowledge-codemagic/build-versioning/).

### Android
The prerequisite is a valid **Google Cloud Service Account**. Please follow these steps:
1. Go to [this guide](https://docs.codemagic.io/knowledge-base/google-services-authentication) and complete the steps in the **Google Play** section.
2. Skip to the **Creating a service account** section in the same guide and complete those steps also.
3. You now have a `JSON` file with the credentials.
4. Open Codemagic UI and create a new Environment variable `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS`.
5. Paste the content of the downloaded `JSON` file in the **_Value_** field, set the group name (e.g. **google_play**) and make sure the **Secure** option is checked.
6. Add the **google_play** variable group to the `codemagic.yaml` as well as define the `PACKAGE_NAME` and the `GOOGLE_PLAY_TRACK`:

``` yaml
  environment:
    groups:
      - google_play
    vars:
      PACKAGE_NAME: "io.codemagic.ionicsample"
      GOOGLE_PLAY_TRACK: alpha
```
7. Modify the build script to calculate the build number and use it as gradlew arguments.

``` yaml
scripts:
  # ....
  - name: Build Android release
    script: | 
      LATEST_BUILD_NUMBER=$(google-play get-latest-build-number --package-name "$PACKAGE_NAME")
      if [ -z LATEST_BUILD_NUMBER ]; then
        # fallback in case no build number was found from Google Play.
        # Alternatively, you can `exit 1` to fail the build
        # BUILD_NUMBER is a Codemagic built-in variable tracking the number
        # of times this workflow has been built
          UPDATED_BUILD_NUMBER=$BUILD_NUMBER
      else
          UPDATED_BUILD_NUMBER=$(($LATEST_BUILD_NUMBER + 1))
      fi
      cd android
      ./gradlew bundleRelease \
          -PversionCode=$UPDATED_BUILD_NUMBER \
          -PversionName=1.0.$UPDATED_BUILD_NUMBER
```
8. Modify the `android/app/build.gradle` file to get the build number values and apply them:
``` groovy

// get version code from the specified property argument `-PversionCode` during the build call
def getMyVersionCode = { ->
    return project.hasProperty('versionCode') ? versionCode.toInteger() : -1
}

// get version name from the specified property argument `-PversionName` during the build call
def getMyVersionName = { ->
    return project.hasProperty('versionName') ? versionName : "1.0"
}

....
android {
    ....
    defaultConfig {
        ...
        versionCode getMyVersionCode()
        versionName getMyVersionName()
```

### iOS
In order to get the latest build number from App Store or TestFlight, you will need the App Store credentials as well as the **Application Apple ID**. This is an automatically generated ID assigned to your app and it can be found under **General > App Information > Apple ID** under your application in App Store Connect.

1. Add the **Application Apple ID** to the `codemagic.yaml` as a variable
2. Add the script to get the latest build number using `app-store-connect` and configure the new build number using `agvtool`.
3. Your `codemagic.yaml` will look like this:
``` yaml
workflows:
  ios-workflow:
    name: iOS Workflow
    integrations:
      app_store_connect: <App Store Connect API key name>
    environment:
      vars:
        APP_ID: 1555555551
    scripts:
      - name: Increment build number
        script: | 
          #!/bin/sh
          cd $CM_BUILD_DIR
          LATEST_BUILD_NUMBER=$(app-store-connect get-latest-app-store-build-number "$APP_ID")
          agvtool new-version -all $(($LATEST_BUILD_NUMBER + 1))
      - name: Build ipa for distribution
      script: | 
        # build command
```

## Publishing
Codemagic offers a wide array of options for app publishing and the list of partners and integrations is continuously growing. For the most up-to-date information, check the guides in the **Configuration > Publishing** section of these docs.
To get more details on the publishing options presented in this guide, please check the [Email publishing](https://docs.codemagic.io/yaml-notification/email/), [App Store Connect](https://docs.codemagic.io/yaml-publishing/app-store-connect/) and the [Google Play Store](https://docs.codemagic.io/yaml-publishing/google-play/) publishing docs.

### Email publishing
If the build finishes successfully, release notes (if passed), and the generated artifacts will be published to the provided email address(es). If the build fails, an email with a link to build logs will be sent.

If you don’t want to receive an email notification on build success or failure, you can set `success` to `false` or `failure` to `false` accordingly.
``` yaml
workflows:
  sample-workflow-id:
    environment: 
      # ...
    scripts: 
      # ...
    publishing: 
      email:
        recipients:
          - user_1@example.com
          - user_2@example.com
        notify:
          success: true
          failure: false
```
### Publishing to Google Play

Configuring Google Play publishing is simple as you only need to provide credentials and choose the desired track. If the app is in `draft` status, please also include the `submit_as_draft: true` or promote the app status in Google Play.
``` yaml
kmm-android:
  # ... 
  publishing:
    google_play:
      credentials: $GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
      track: internal
      submit_as_draft: true
```

### Publishing to App Store
Codemagic enables you to automatically publish your iOS or macOS app to [App Store Connect](https://appstoreconnect.apple.com/) for beta testing with [TestFlight](https://developer.apple.com/testflight/) or distributing the app to users via App Store. Codemagic uses the **App Store Connect API key** for authenticating communication with Apple's services. You can read more about generating an API key from Apple's [documentation page](https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api).

Please note that:

1. for App Store Connect publishing, the provided key needs to have [App Manager permission](https://help.apple.com/app-store-connect/#/deve5f9a89d7),
2. and in order to submit your iOS application to App Store Connect, it must be code signed with a distribution [certificate](https://developer.apple.com/support/certificates/).

The following snippet demonstrates how to authenticate with and upload the IPA to App Store Connect, submit the build to beta tester groups in TestFlight and configure releasing the app to App Store. See additional configuration options for App Store Connect publishing [here](https://github.com/codemagic-ci-cd/cli-tools/blob/master/docs/app-store-connect/publish.md).

> **Note:** Please note that you will need to create an **app record** in App Store Connect before you can automate publishing with Codemagic. It is recommended to upload the very first version of the app manually. Suppose you have set up an **app record** but have not manually uploaded the app's first version. In that case, manual configuration of the settings must be done on App Store Connect after the build is complete, such as uploading the required screenshots and providing the values for the privacy policy URL and application category.

``` yaml
# Integration section is required to make use of the keys stored in 
# Codemagic UI under Apple Developer Portal integration.
integrations:
  app_store_connect: <App Store Connect API key name>

publishing:
  app_store_connect:
    # Use referenced App Store Connect API key to authenticate binary upload
    auth: integration 

    # Configuration related to TestFlight (optional)

    # Optional boolean, defaults to false. Whether or not to submit the uploaded
    # build to TestFlight beta review. Required for distributing to beta groups.
    # Note: This action is performed during post-processing.
    submit_to_testflight: true 

    # Specify the names of beta tester groups that will get access to the build 
    # once it has passed beta review.
    beta_groups: 
      - group name 1
      - group name 2
    
    # Configuration related to App Store (optional)

    # Optional boolean, defaults to false. Whether or not to submit the uploaded
    # build to App Store review. Note: This action is performed during post-processing.
    submit_to_app_store: true
    
    # Optional, defaults to MANUAL. Supported values: MANUAL, AFTER_APPROVAL or SCHEDULED
    release_type: SCHEDULED

    # Optional. Timezone-aware ISO8601 timestamp with hour precision when scheduling
    # the release. This can be only used when release type is set to SCHEDULED.
    # It cannot be set to a date in the past.
    earliest_release_date: 2021-12-01T14:00:00+00:00 
    
    # Optional. The name of the person or entity that owns the exclusive rights
    # to your app, preceded by the year the rights were obtained.
    copyright: 2021 Nevercode Ltd
```

## Conclusion
Having followed all of the above steps, you now have a working `codemagic.yaml` file that allows you to build, code sign, automatically version, and publish your project using Codemagic CI/CD.
Save your work, commit the changes to the repository, open the app in the Codemagic UI and start the build to see it in action.


## Next steps
While this basic workflow configuration is incredibly useful, it is certainly not the end of the road and there are numerous advanced actions that Codemagic can help you with.

We encourage you to investigate [Running tests with Codemagic](https://docs.codemagic.io/yaml-testing/testing/) to get you started with testing, as well as additional guides such as the one on running tests on [Firebase Test Lab](https://docs.codemagic.io/yaml-testing/firebase-test-lab/) or [Registering iOS test devices](https://docs.codemagic.io/testing/ios-provisioning/).

Documentation on [using codemagic.yaml](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/) teaches you to configure additional options such as [changing the instance type](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/#instance-type) on which to build, speeding up builds by configuring [Caching options](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/#cache), or configuring builds to be [automatically triggered](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/#triggering) on repository events.


