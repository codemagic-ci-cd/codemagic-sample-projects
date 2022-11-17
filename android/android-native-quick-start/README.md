This sample project illustrates all of the necessary steps to successfully build and publish a native Android app with Codemagic. It covers the basic steps such as build versioning, code signing and publishing.

You can find more detailed instructions as well numerous guides to advanced features in our [official documentation](https://docs.codemagic.io/yaml-quick-start/building-a-native-android-app/).


## Adding the app to Codemagic
The apps you have available on Codemagic are listed on the Applications page. Click **Add application** to add a new app.

1. If you have more than one team configured in Codemagic, select the team you wish to add the app to.
2. Connect the repository where the source code is hosted. Detailed instructions that cover some advanced options are available [here](https://docs.codemagic.io/getting-started/adding-apps/).
3. Select the repository from the list of available repositories. Select the appropriate project type.
4. Click **Finish: Add application**

## Creating codemagic.yaml
Codemagic uses a YAML configuration file to configure the CI/CD workflow. The name of the file must be `codemagic.yaml` and it must be located in the root directory of the repository. This sample project includes a `codemagic.yaml` file covering all of the steps outlined below. You can update the file with your own information and reuse it to build your own projects.


## Code signing

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



## Configure scripts to build the app
Add the following scripts to your `codemagic.yaml` file in order to prepare the build environment and start the actual build process.
In this step, you can also define the build artifacts you are interested in. These files will be available for download when the build finishes. For more information about artifacts, see [here](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/).


``` yaml
scripts:
    # ....
  - name: Set Android SDK location
    script: | 
      echo "sdk.dir=$ANDROID_SDK_ROOT" > "$CM_BUILD_DIR/local.properties"
  - name: Build Android release
    script: | 
      ./gradlew bundleRelease # -> to create the .aab
      # gradlew assembleRelease # -> to create the .apk

artifacts:
  - android/app/build/outputs/**/*.aab
```


## Build versioning

If you are going to publish your app to Google Play, each uploaded artifact must have a new version. Codemagic allows you to easily automate this process and increment the version numbers for each build. For more information and details, see [here](https://docs.codemagic.io/knowledge-codemagic/build-versioning/).

The prerequisite is a valid **Google Cloud Service Account**. Please follow these steps:
1. Go to [this guide](https://docs.codemagic.io/knowledge-base/google-services-authentication) and complete the steps in the **Google Play** section.
2. Skip to the **Creating a service account** section in the same guide and complete those steps also.
3. You now have a `JSON` file with the credentials.
4. Open Codemagic UI and create a new Environment variable `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS`.
5. Paste the content of the downloaded `JSON` file in the **_Value_** field, set the group name (e.g. **google_play**) and make sure the **Secure** option is checked.
6. Add the **google_play** variable group to the `codemagic.yaml`

``` yaml
  environment:
    groups:
      - google_play
```
7. Modify the build script to calculate the build number and use it as gradlew arguments.

``` yaml
scripts:
    # ....
  - name: Build Android release
    script: | 
      LATEST_GOOGLE_PLAY_BUILD_NUMBER=$(google-play get-latest-build-number --package-name "$PACKAGE_NAME")
      if [ -z LATEST_BUILD_NUMBER ]; then
        # fallback in case no build number was found from Google Play.
        # Alternatively, you can `exit 1` to fail the build
        # BUILD_NUMBER is a Codemagic built-in variable tracking the number
        # of times this workflow has been built
          UPDATED_BUILD_NUMBER=$BUILD_NUMBER
      else
          UPDATED_BUILD_NUMBER=$(($LATEST_GOOGLE_PLAY_BUILD_NUMBER + 1))
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


## Publishing

Codemagic offers a wide array of options for app publishing and the list of partners and integrations is continuously growing. For the most up-to-date information, check the guides in the **Configuration > Publishing** section of these docs.
To get more details on the publishing options presented in this guide, please check the [Email publishing](https://docs.codemagic.io/yaml-notification/email/) and the [Google Play Store](https://docs.codemagic.io/yaml-publishing/google-play/) publishing docs.

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

## Conclusion
Having followed all of the above steps, you now have a working `codemagic.yaml` file that allows you to build, code sign, automatically version, and publish your project using Codemagic CI/CD.
Save your work, commit the changes to the repository, open the app in the Codemagic UI and start the build to see it in action.


## Next steps
While this basic workflow configuration is incredibly useful, it is certainly not the end of the road and there are numerous advanced actions that Codemagic can help you with.

We encourage you to investigate [Running tests with Codemagic](https://docs.codemagic.io/yaml-testing/testing/) to get you started with testing, as well as additional guides such as the one on running tests on [Firebase Test Lab](https://docs.codemagic.io/yaml-testing/firebase-test-lab/) or [Registering iOS test devices](https://docs.codemagic.io/testing/ios-provisioning/).

Documentation on [using codemagic.yaml](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/) teaches you to configure additional options such as [changing the instance type](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/#instance-type) on which to build, speeding up builds by configuring [Caching options](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/#cache), or configuring builds to be [automatically triggered](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/#triggering) on repository events.
