This sample project illustrates all of the necessary steps to successfully build and publish a Unity Android and iOS apps with Codemagic. It covers the basic steps such as build versioning, code signing and publishing.

You can find more detailed instructions as well numerous guides to advanced features in our [official documentation](https://docs.codemagic.io/yaml-quick-start/building-a-unity-app/).

## Unity licensing requirements

Building Unity apps in a cloud CI/CD environment requires a Unity **Plus** or a **Pro** license. Your license is used to activate Unity on the Codemagic build server so the iOS and Android projects can be exported.  The license is returned during the publishing step of the workflow which is always run **except if the build is cancelled**.

You can use [Unity dashboard](https://id.unity.com/en/serials) to check the number of free seats on your license or to manually return a seat if neccessary.

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

## Configuring Unity license

Each Unity build will have to activate a valid Unity Plus or a Unity Pro license using your **Unity email**, **Unity serial number** and the **Unity password**.

1. You can add these as global environment variables for your personal account by navigating to **Teams > Personal Account** or team by navigating to **Teams > Your Team Name** and then clicking on **Global variables and secrets**. Likewise, you can add the environment variables at the application level by clicking the **Environment variables** tab.

2. Enter `UNITY_EMAIL` as the **_Variable name_**.
3. Enter the email address used with your Unity ID as **_Variable value_**.
4. Enter the variable group name, e.g. **_unity_credentials_**. Click the button to create the group.
5. Make sure the **Secure** option is selected.
6. Click the **Add** button to add the variable.
7. Repeat the steps to also add `UNITY_SERIAL` and `UNITY_PASSWORD` variables.
8. Add the **unity_credentials** variable group to the `codemagic.yaml`:
``` yaml
  environment:
    groups:
      - unity_credentials
```

> **Note:** The `UNITY_HOME` environment variable is already set on the build machines. 
On the macOS Unity base image `UNITY_HOME` is set to `/Applications/Unity/Hub/Editor/2020.3.28f1/Unity.app`.

## Activating and deactivating the license
### Activation
To activate a Unity license on the build machine, add the following step at the top of your `scripts:` section in `codemagic.yaml`:
``` yaml
  scripts:
    - name: Activate Unity license
      script: | 
        $UNITY_BIN -batchmode -quit -logFile \
          -serial ${UNITY_SERIAL?} \
          -username ${UNITY_EMAIL?} \
          -password ${UNITY_PASSWORD?}
```

> **Note**: When using Codemagic Windows instance types, Unity activation is performed in the same command that build the app.

### Deactivation - Mac (M1 silicon)
To deactivate a Unity license on the build machine, add the following script step in the `publishing:` section in `codemagic.yaml`:
``` yaml
  publishing:
    scripts:
      - name: Deactivate Unity License
        script: | 
          /Applications/Unity\ Hub.app/Contents/Frameworks/UnityLicensingClient_V1.app/Contents/MacOS/Unity.Licensing.Client \
            --return-ulf \
            --username ${UNITY_EMAIL?} \
            --password ${UNITY_PASSWORD?}
```

### Deactivation - Mac (Intel) and Linux
To deactivate a Unity license on the build machine, add the following script step in the `publishing:` section in `codemagic.yaml`:
``` yaml
  publishing:
    scripts:
      - name: Deactivate Unity License
      script: | 
        $UNITY_BIN -batchmode -quit -returnlicense -nographics
```

### Deactivation - Windows
``` yaml
  publishing:
    scripts:
      - name: Deactivate Unity License
        script: | 
          cmd.exe /c "$env:UNITY_HOME\\Unity.exe" -batchmode -quit -returnlicense -nographics
```

> **Note:** If a build is manually cancelled before reaching the publishing section, the license WILL NOT BE RETURNED automatically. This may cause future builds to fail if there are no free license seats available.
Visit [Unity dashboard](https://id.unity.com/en/subscriptions) to manually deactivate license.

## Creating a build script

You need to create additional build script to allow building and codesigning Unity projects in headless mode. The script is located in `/Assets/Editor/Build.cs` and you can use it as-is in your projects.

## Configuring Unity project settings

Depending on the target platform, you will need to configure some settings in your Unity project.

### Android
Google recommends that Android applications be published to Google Play using the application bundle (.aab). You should configure the following settings in Unity before building the application bundle:

#### Project settings
1. Open Unity and click **File > Build Settings**.
2. Make sure Android is selected in the **Platform** section.
3. Check the **Build App Bundle (Google Play)** checkbox.
4. Make sure that **Export Project** is **NOT** checked.
5. Click on the **Player Settings** button.
6. Expand **Other Settings** and check the **Override Default Package Name** checkbox.
7. Enter the package name for your app, e.g. "com.domain.yourappname".
8. Set the **Version number**.
9. Put any integer value in the **Bundle Version Code**. This will be overriden by the build script.
10. Set the **Minimum API Level** and **Target API Level** to `Android 11.0 (API level 30)` which is required for publishing application bundles.
11. In the **Configuration** section set **Scripting Backend** to `IL2CPP`.
12. In the **Target Architectures** section check **ARMv7** and **ARM64** to support 64-bit architectures so the app is compliant with the Google Play 64-bit requirement.

#### Add a custom base Gradle template
You will need to add custom Gradle templates so your Android builds work with Codemagic.  

1. Open Unity and **File > Build Settings**.
2. Make sure **Android** is selected in the **Platform** section.
3. Click on the **Player Settings**.
4. Expand the **Publishing Settings**.
5. Check the **Custom Base Gradle Template**.
6. Close the project settings and build settings.

#### Modify the base Gradle template
1. In the project explorer expand **Assets > Plugins > Android**.
2. Double click on **baseProjectTemplate.gradle**.
3. Replace the entire file contents with the content of the `Assets/Plugins/Android/baseProjectTemplate.gradle` file from this sample project.

### iOS
#### Set the iOS bundle identifier
You should set the bundle id of your iOS application before building the Xcode project. 

1. Open Unity and **File > Build Settings**.
2. Make sure **iOS** is selected and click on the **Player Settings** button.
3. Expand the **Other Settings** section.
4. In the **Identification** section check the **Override Default Bundle Identifier** option.
5. Set the **Bundle Identifier** to match the identifier name you have used in your Apple Developer Program account.

## Build versioning
If you are going to publish your app to Google Play or App Store, each uploaded artifact must have a new version. Codemagic allows you to easily automate this process and increment the version numbers for each build. For more information and details, see [here](https://docs.codemagic.io/knowledge-codemagic/build-versioning/).

### Android
One very useful method of calculating the code version is to use Codemagic command line tools to get the latest build number from Google Play and increment it by one. You can then save this as the `NEW_BUILD_NUMBER` environment variable that is already expected by the `/Assets/Editor/Build.cs` build script.

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
      PACKAGE_NAME: "io.codemagic.unitysample"
      GOOGLE_PLAY_TRACK: alpha
```
7. Modify the build script to fetch the latest build number from Google Play, increment it and pass it as command line argument to the build command
``` yaml
  scripts:
    - name: Set the build number
      script: | 
        export NEW_BUILD_NUMBER=$(($(google-play get-latest-build-number \
          --package-name "$PACKAGE_NAME" \
          --tracks="$GOOGLE_PLAY_TRACK") + 1))
```

### iOS
In order to get the latest build number from App Store or TestFlight, you will need the App Store credentials as well as the **Application Apple ID**. This is an automatically generated ID assigned to your app and it can be found under **General > App Information > Apple ID** under your application in App Store Connect.

1. Add the **Application Apple ID** to the `codemagic.yaml` as a variable
2. Add the script to get the latest build number using `app-store-connect`, increment it and pass it as command line argument to the build command:
``` yaml
workflows:
  ios-workflow:
    name: iOS Workflow
    integrations:
      app_store_connect: <App Store Connect API key name>
    environment:
      ios_signing:
        distribution_type: app_store
        bundle_identifier: io.codemagic.unitysample
      vars:
        APP_ID: 1555555551
    scripts:
      - name: Set the build number
        script: | 
          BUILD_NUMBER=($(app-store-connect get-latest-app-store-build-number "$APP_ID") + 1)
          cd ios
          agvtool new-version -all $BUILD_NUMBER
```

## Building the app
Add the following scripts to your `codemagic.yaml` file in order to prepare the build environment and start the actual build process.
In this step, you can also define the build artifacts you are interested in. These files will be available for download when the build finishes. For more information about artifacts, see [here](https://docs.codemagic.io/yaml/yaml-getting-started/#artifacts).

### Android
``` yaml
  environment:
    #...
    vars:
      UNITY_BIN: $UNITY_HOME/Contents/MacOS/Unity
  scripts:
    - name: Activate Unity license
      script: #...
    - name: Set the build number
      script: #... 
    - name: Build the project
      script: | 
        $UNITY_BIN -batchmode \
          -quit \
          -logFile \
          -projectPath . \
          -executeMethod BuildScript.BuildAndroid \
          -nographics
    artifacts:
      - android/*.aab
```

### iOS
``` yaml
  environment:
    #...
    vars:
      UNITY_BIN: $UNITY_HOME/Contents/MacOS/Unity
      UNITY_IOS_DIR: ios
      XCODE_PROJECT: "Unity-iPhone.xcodeproj"
      XCODE_SCHEME: "Unity-iPhone"
  scripts:
    - name: Activate Unity license
      script: #...
    - name: Generate the Xcode project from Unity
      script: | 
        $UNITY_BIN -batchmode \
          -quit \
          -logFile \
          -projectPath . \
          -executeMethod BuildScript.BuildIos \
          -nographics
    - name: Set up code signing settings on Xcode project
      script: | 
        xcode-project use-profiles
    - name: Set the build number
      script: #...
    - name: Build the project
      script: | 
        xcode-project build-ipa --project "$UNITY_IOS_DIR/$XCODE_PROJECT" --scheme "$XCODE_SCHEME"
    artifacts:
     - build/ios/ipa/*.ipa
      - $HOME/Library/Developer/Xcode/DerivedData/**/Build/**/*.dSYM
```

> **Note**: If you are using Pod files and Xcode workspace, replace the **Build the project** step by this (don't forget to configure the `XCODE_WORKSPACE` variable):
``` yaml
    - name: Install pods
      script: | 
        pod install
    - name: Build the project
      script: | 
        xcode-project build-ipa \
          --workspace "$UNITY_IOS_DIR/$XCODE_WORKSPACE" \
          --scheme "$XCODE_SCHEME"
```

### Windows
``` yaml
  scripts:
    - name: Activate & Build Unity Using a Command Prompt
      script: | 
        cmd.exe /c "$env:UNITY_HOME\\Unity.exe" ^
          -batchmode -quit -logFile ^
          -projectPath . ^
          -executeMethod BuildScript.BuildWindows ^
          -nographics ^
          -serial $env:UNITY_SERIAL ^
          -username $env:UNITY_EMAIL ^
          -password $env:UNITY_PASSWORD
    - name: Export Unity
      script: | 
        cd windows
        7z a -r release.zip ./*
    artifacts:
      - windows/*.zip
```

### MacOS
``` yaml
  environment:
    #...
    vars:
      UNITY_BIN: $UNITY_HOME/Contents/MacOS/Unity
      UNITY_MAC_DIR: mac
      BUNDLE_ID: "io.codemagic.unitysample"
  scripts:
    - name: Set up keychain
      script: | 
        keychain initialize
    - name: Fetch signing files
      script: | 
        app-store-connect fetch-signing-files "$BUNDLE_ID" \
          --type MAC_APP_STORE \
          --platform MAC_OS \
          --create
    - name: Fetch Mac Installer Distribution certificates
      script: | 
        app-store-connect list-certificates --type MAC_INSTALLER_DISTRIBUTION --save || \
        app-store-connect create-certificate --type MAC_INSTALLER_DISTRIBUTION --save 
    - name: Add certs to keychain
      script: | 
        keychain add-certificates
    - name: Set up code signing settings on Xcode project
      script: | 
        xcode-project use-profiles
    - name: Activate License
      script: #...
    - name: Build the project
      script: | 
        $UNITY_BIN -batchmode -quit -logFile \
          -projectPath . \
          -executeMethod BuildScript.BuildMac \
          -nographics
    - name: Package macOS application
      script: | 
        set -x
        #
        # Command to find the path to your generated app
        APP_NAME=$(find $(pwd) -name "*.app")
        cd $(dirname "$APP_NAME")
        PACKAGE_NAME=$(basename "$APP_NAME" .app).pkg
        #
        # Create an unsigned package
        xcrun productbuild \
          --component "$APP_NAME" \
          /Applications/ unsigned.pkg
        #
        # Find the installer certificate commmon name in keychain
        INSTALLER_CERT_NAME=$(keychain list-certificates \
            | jq '.[]
              | select(.common_name
              | contains("Mac Developer Installer"))
              | .common_name' \
            | xargs)
        #
        # Sign the package
        xcrun productsign \
          --sign "$INSTALLER_CERT_NAME" \
          unsigned.pkg "$PACKAGE_NAME"
        #
        # Optionally remove the not needed unsigned package
        rm -f unsigned.pkg
    artifacts:
      - $UNITY_MAC_DIR/*.app
      - $UNITY_MAC_DIR/*.pkg
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
react-native-android:
  # ... 
  publishing:
    # ...
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

#### App Store post processing

When publishing your app to TestFlight or the App Store, you will be asked if your app uses encryption. 

You can automate your answer to this question by setting the key `ITSAppUsesNonExemptEncryption` in your app's `Info.plist` file and set the value to `NO` if the app doesn't use encryption. 

For more details about complying with encryption export regulations, please see [here](https://developer.apple.com/documentation/security/complying_with_encryption_export_regulations).

A Unity post-processing script can be used to set values in the `Info.plist` of the Xcode project. You can find the script in `/Assets/Editor/PostProcessing.cs`.

## Caching
You can speed up your build by caching the Library folder, read more about caching [here](https://docs.codemagic.io/yaml/yaml-getting-started/#cache).
``` yaml
    cache:
      cache_paths:
        - $CM_BUILD_DIR/Library
```

## Conclusion
Having followed all of the above steps, you now have a working `codemagic.yaml` file that allows you to build, code sign, automatically version, and publish your project using Codemagic CI/CD.
Save your work, commit the changes to the repository, open the app in the Codemagic UI and start the build to see it in action.


## Next steps
While this basic workflow configuration is incredibly useful, it is certainly not the end of the road and there are numerous advanced actions that Codemagic can help you with.

We encourage you to investigate [Running tests with Codemagic](https://docs.codemagic.io/yaml-testing/testing/) to get you started with testing, as well as additional guides such as the one on running tests on [Firebase Test Lab](https://docs.codemagic.io/yaml-testing/firebase-test-lab/) or [Registering iOS test devices](https://docs.codemagic.io/testing/ios-provisioning/).

Documentation on [using codemagic.yaml](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/) teaches you to configure additional options such as [changing the instance type](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/#instance-type) on which to build, speeding up builds by configuring [Caching options](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/#cache), or configuring builds to be [automatically triggered](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/#triggering) on repository events.