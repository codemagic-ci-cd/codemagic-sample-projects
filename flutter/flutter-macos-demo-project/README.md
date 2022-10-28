# Flutter macOS Demo Project

This sample project illustrates all of the necessary steps to successfully build and publish a Flutter macOS apps with Codemagic. It covers the basic steps such as build versioning, code signing and publishing.

You can find a more detailed instruction as well numerous guides to advanced features in our [official documentation](https://docs.codemagic.io/yaml-quick-start/building-a-flutter-app/).

## Adding the app to Codemagic
The apps you have available on Codemagic are listed on the Applications page. Click **Add application** to add a new app.

1. If you have more than one team configured in Codemagic, select the team you wish to add the app to.
2. Connect the repository where the source code is hosted. Detailed instructions that cover some advanced options are available [here](https://docs.codemagic.io/getting-started/adding-apps/).
3. Select the repository from the list of available repositories. Select the appropriate project type.
4. Click **Finish: Add apllication**

## Creating codemagic.yaml
Codemagic uses a yaml configuration file to configure the CI/CD workflow. The name of the file must be `codemagic.yaml` and it must be located in the root directory of the repository. This sample projects includes a `codemagic.yaml` file covering all of the steps outlined below. You can update the file with your own information and reuse it to build your own projects.

## Code signing

### Creating the App Store Connect API key
Signing iOS applications requires [Apple Developer Program](https://developer.apple.com/programs/enroll/) membership.

It is recommended to create a dedicated App Store Connect API key for Codemagic in [App Store Connect](https://appstoreconnect.apple.com/access/api). To do so:

1. Log in to App Store Connect and navigate to **Users and Access > Keys**.
2. Click on the + sign to generate a new API key.
3. Enter the name for the key and select an access level. We recommend choosing `App Manager` access rights, read more about Apple Developer Program role permissions [here](https://help.apple.com/app-store-connect/#/deve5f9a89d7).
4. Click **Generate**.
5. As soon as the key is generated, you can see it added to the list of active keys. Click **Download API Key** to save the private key for later. Note that the key can only be downloaded once.

### Adding the App Store Connect API key to Codemagic

1. Open your Codemagic Team settings, go to **Team integrations** > **Developer Portal** > **Manage keys**.
2. Click the **Add key** button.
3. Enter the `App Store Connect API key name`. This is a human readable name for the key that will be used to refer to the key later in application settings.
4. Enter the `Issuer ID` and `Key ID` values.
5. Click on **Choose a .p8 file** or drag the file to upload the App Store Connect API key downloaded earlier.
6. Click **Save**.

### Automatic vs Manual code signing

Signing macOS apps requires a `Signing certificate` (App Store **development** or **distribution** certificate in `.p12` format) and a `Provisioning profile`. In **Manual code signing** you save these files as Codemagic `Environment variables` and manually reference them in the appropriate build steps.

In **Automatic code signing**, Codemagic takes care of Certificate and Provisioning profile management for you. Based on the `certificate private key` that you provide, Codemagic will automatically fetch the correct certificate from the App Store or create a new one if necessary.

#### Certificate types
There are several certificate types you can choose to sign your macOS app, depending on the distribution method you plan to use.

- `MAC_APP_DEVELOPMENT` certificate allows you to build your app for internal testing and debugging.
- `MAC_APP_DISTRIBUTION` certificate is used to sign a Mac app before submitting it to the Mac App Store
- `MAC_INSTALLER_DISTRIBUTION` is used to sign and submit a Mac Installer Package to the Mac App Store
- `DEVELOPER_ID_APPLICATION` is used to sign a Mac app before distributing it outside the Mac App Store
- `DEVELOPER_ID_INSTALLER` is used to sign a Mac Installer Package before distributing it outside the Mac App Store

For example, in order to publish to Mac App Store, the application must be signed with a `Mac App Distribution` certificate using a `Mac App Store` provisioning profile. If you want to create a `.pkg` Installer pacakge, you must use a `Mac Installer Distribution` certificate.
#### Obtaining the certificate private key

To enable Codemagic to automatically fetch or create the correct signing certificate on your behalf, you need to provide the corresponding `certificate private key`. You then have to save that key as a Codemagic environment variable.

You can create a new 2048 bit RSA key by running the command below in your terminal:
```bash
ssh-keygen -t rsa -b 2048 -m PEM -f ~/Desktop/mac_distribution_private_key -q -N ""
```
This new private key will be used to create a new Mac App Distribution certificate in your Apple Developer Program account if there isn't one that already matches this private key.

If you already have a private key, follow these steps:
1. On the Mac which created the iOS distribution certificate, open the **Keychain Access**, located in the **Applications and Utilities** folder.
2. Select the appropriate certificate entry.
3. Right-click on it to select "Export."
4. In the export prompt window that appears, make sure the file format is set to **Personal Information Exchange (.p12)**"**.
5. Give the file a name such as "MAC_DISTRIBUTION", choose a location and click **Save**.
6. On the next prompt, leave the password empty and click **OK**.
7. Use the following `openssl` command to export the private key:

```bash
openssl pkcs12 -in MAC_DISTRIBUTION.p12 -nodes -nocerts | openssl rsa -out mac_distribution_private_key
```

8. When prompted for the import password, just press enter. The private key will be written to a file called **mac_distribution_private_key** in the directory where you ran the command.


### Configuring environment variables
1. Open your Codemagic app settings, and go to the **Environment variables** tab.
2. Enter `CERTIFICATE_PRIVATE_KEY` as the **_Variable name_**.
3. Open the file `mac_distribution_private_key` with a text editor and copy the **entire contents** of the file, including the `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----` tags. Alternatively, you can run the following command on the file:
{{< highlight bash "style=rrt">}}
  cat mac_distribution_private_key | pbcopy
{{< /highlight >}}
4. Paste into the **_Variable value_** field.
5. Enter a variable group name, e.g. **_appstore_credentials_**. Click the button to create the group.
6. Make sure the **Secure** option is selected so that the variable can be protected by encryption.
7. Click the **Add** button to add the variable.
8. Run the following command on the **App Store Connect API key** file that you downloaded earlier (in our example saved as `codemagic_api_key.p8`) to copy its content to clipboard:
```bash
cat codemagic_api_key.p8 | pbcopy
```

9. Create a new Environment variable `APP_STORE_CONNECT_PRIVATE_KEY` and paste the value from clipboard.
10. Create variable `APP_STORE_CONNECT_KEY_IDENTIFIER`. The value is the **Key ID** field from **App Store Connect > Users and Access > Keys**.
11. Create variable `APP_STORE_CONNECT_ISSUER_ID`. The value is the **Issuer ID** field from **App Store Connect > Users and Access > Keys**.

> **Tip**: Store all the of these variables in the same group so they can be imported to codemagic.yaml workflow at once. 

Environment variables have to be added to the workflow either individually or as a group. Modify your `codemagic.yaml` file by adding the following:
```yaml
workflows:
  macos-workflow:
    name: macOS Workflow
    environment:
      groups:
        - appstore_credentials
```

### Automatic code signing
To code sign the app, add the following commands in the scripts section of the configuration file, after all the dependencies are installed, right before the build commands. 

```yaml
    scripts:
      - name: Set up keychain to be used for code signing using Codemagic CLI 'keychain' command
        script: keychain initialize
      - name: Fetch signing files
        script: | 
          app-store-connect fetch-signing-files "$BUNDLE_ID" \
            --platform MAC_OS \
            --type MAC_APP_STORE \
            --create
      - name: Fetch Mac Installer Distribution certificates
        script: |  
            app-store-connect list-certificates --type MAC_APP_DISTRIBUTION --save || \
            app-store-connect create-certificate --type MAC_APP_DISTRIBUTION --save
      - name: Set up signing certificate
        script: keychain add-certificates
      - name: Set up code signing settings on Xcode project
        script: xcode-project use-profiles
```

Instead of specifying the exact bundle ID, you can use `"$(xcode-project detect-bundle-id)"`.

Based on the specified bundle ID and [provisioning profile type](https://github.com/codemagic-ci-cd/cli-tools/blob/master/docs/app-store-connect/fetch-signing-files.md#--typeios_app_adhoc--ios_app_development--ios_app_inhouse--ios_app_store--mac_app_development--mac_app_direct--mac_app_store--mac_catalyst_app_development--mac_catalyst_app_direct--mac_catalyst_app_store--tvos_app_adhoc--tvos_app_development--tvos_app_inhouse--tvos_app_store), Codemagic will fetch or create the relevant provisioning profile and certificate to code sign the build.

### Creating the Installer package

To package your application into an `.pkg` Installer package and sign it with the `Mac Installer Distribution` certificate, use the following script:

```yaml
  scripts:
    - name: Package application
      script: | 
      set -x
    
      # Command to find the path to your generated app, may be different
      APP_NAME=$(find $(pwd) -name "*.app")  
      cd $(dirname "$APP_NAME")
    
      PACKAGE_NAME=$(basename "$APP_NAME" .app).pkg
      xcrun productbuild --component "$APP_NAME" /Applications/ unsigned.pkg  # Create and unsigned package

      # Find the installer certificate commmon name in keychain
      INSTALLER_CERT_NAME=$(keychain list-certificates \
        | jq '.[]
        | select(.common_name
        | contains("Mac Developer Installer"))
        | .common_name' \
        | xargs)
      
      xcrun productsign --sign "$INSTALLER_CERT_NAME" unsigned.pkg "$PACKAGE_NAME" # Sign the package
    
      rm -f unsigned.pkg                                                       # Optionally remove the not needed unsigned package
```

> **Note**: Don't forget to specify the path to your generated package in the [artifacts section](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/#artifacts).

### Notarizing macOS applications

Notarization is a process where Apple verifies your application to make sure it has a Developer ID code signature and does not contain malicious content. All apps distributed outside the Mac App Store have to be notarized.

Notarizing an app during the Codemagic build process is possible using the **altool** command as follows:

```bash
xcrun altool --notarize-app -f <file> --primary-bundle-id <bundle_id>
           {-u <username> [-p <password>] | --apiKey <api_key> --apiIssuer <issuer_id>}
           [--asc-provider <name> | --team-id <id> | --asc-public-id <id>]
```


## Configure scripts to build the app
Add the following scripts to your `codemagic.yaml` file in order to prepare the build environment and start the actual build process.
In this step you can also define the build artifacts you are interested in. These files will be available for download when the build finishes. For more information about artifacts, see [here](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/).

``` yaml
  scripts:
    
    # ... code signing scripts

    - name: Get Flutter packages
      script: | 
          flutter packages pub get
    - name: Install pods
      script: | 
        find . -name "Podfile" -execdir pod install \;
    - name: Build Flutter macOS
      script: | 
          flutter config --enable-macos-desktop && \
          flutter build macos --release
    
    # ... create package scripts
        
    artifacts:
      - build/macos/**/*.pkg
```

## Publishing
Codemagic offers a wide array of options for app publishing and the list of partners and integrations is continuously growing. For the most up-to-date information, check the guides in the **Configuration > Publishing** section of these docs.
To get more details on the publishing options presented in this guide, please check the [Email publishing](https://docs.codemagic.io/yaml-notification/email/) and the [App Store Connect](https://docs.codemagic.io/yaml-publishing/app-store-connect/) publishing docs.

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

### Publishing to App Store
Codemagic enables you to automatically publish your iOS or macOS app to [App Store Connect](https://appstoreconnect.apple.com/) for beta testing with [TestFlight](https://developer.apple.com/testflight/) or distributing the app to users via App Store. Codemagic uses the **App Store Connect API key** for authenticating communication with Apple's services. You can read more about generating an API key from Apple's [documentation page](https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api).

Please note that:

1. for App Store Connect publishing, the provided key needs to have [App Manager permission](https://help.apple.com/app-store-connect/#/deve5f9a89d7),
2. and in order to submit your iOS application to App Store Connect, it must be code signed with a distribution [certificate](https://developer.apple.com/support/certificates/).

The following snippet demonstrates how to authenticate with and upload the IPA to App Store Connect, submit the build to beta tester groups in TestFlight and configure releasing the app to App Store. See additional configuration options for App Store Connect publishing [here](https://github.com/codemagic-ci-cd/cli-tools/blob/master/docs/app-store-connect/publish.md).

> **Note:** Please note that you will need to create an **app record** in App Store Connect before you can automate publishing with Codemagic. It is recommended to upload the very first version of the app manually. Suppose you have set up an **app record** but have not manually uploaded the app's first version. In that case, manual configuration of the settings must be done on App Store Connect after the build is complete, such as uploading the required screenshots and providing the values for the privacy policy URL and application category.



``` yaml
publishing:
  app_store_connect:
    # Contents of the API key saved as a secure environment variable:
    api_key: $APP_STORE_CONNECT_PRIVATE_KEY 
    
    # Alphanumeric value that identifies the API key, 
    # can also reference environment variable such as $APP_STORE_CONNECT_KEY_IDENTIFIER
    key_id: 3MD7788D9K 

    # Alphanumeric value that identifies who created the API key,
    # can also reference environment variable such as $APP_STORE_CONNECT_ISSUER_ID
    issuer_id: 21d78e2f-b8ad-...
    
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
Having followed all of the above steps, you now have a working `codemagic.yaml` file that allows you to build, code sign, automatically version and publish your project using Codemagic CI/CD.
Save your work, commit the changes to the repository, open the app in the Codemagic UI and start the build to see it in action.


## Next steps
While this basic workflow configuration is incredibly useful, it is certainly not the end of the road and there are numerous advanced actions that Codemagic can help you with.

We encourage you to investigate [Running tests with Codemagic](https://docs.codemagic.io/yaml-testing/testing/) to get you started with testing, as well as additional guides such as the one on running tests on [Firebase Test Lab](https://docs.codemagic.io/yaml-testing/firebase-test-lab/) or [Registering iOS test devices](https://docs.codemagic.io/testing/ios-provisioning/).

Documentation on [using codemagic.yaml](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/) teaches you to configure additional options such as [changing the instance type](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/#instance-type) on which to build, speeding up builds by configuring [Caching options](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/#cache), or configuring builds to be [automatically triggered](https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/#triggering) on repository events.