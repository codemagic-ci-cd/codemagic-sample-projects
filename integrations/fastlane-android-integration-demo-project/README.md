# Fastlane integration Android Demo Project (YAML build configuration)

The codemagic.yaml in the root of this project contains an example of how to run a Fastlane lane as part of your Codemagic CI/CD builds. Refer to the Fastfile for an exmaple Fastlane script that increments the app version code, builds the android app and then publish to Play store. Please refer to the Fastlane [documentation](https://docs.fastlane.tools/) for further information about configuring Fastlane.   

Documentation for YAML builds can be found at the following URL:

https://docs.codemagic.io/getting-started/yaml/

## Environment variables

For signing the app, upload your keystore to your team [Code Signing Identities](../yaml-code-signing/code-signing-identities/).


Or you can save the keystore file, keystore password (if keystore is password-protected), key alias and key alias password (if key alias is password-protected) to the respective environment variables in the **Environment variables** section in Codemagic UI. Click **Secure** to encrypt the values. Note that binary files (i.e. keystore) have to be [`base64 encoded`](../variables/environment-variable-groups/#storing-sensitive-valuesfiles) locally before they can be saved to environment variables and decoded during the build.

```yaml
 environment:
      groups:
        - keystore_credentials
      # Add the above mentioned group environment variables in Codemagic UI (either in Application/Team variables)
        # CM_KEYSTORE_PATH 
        # CM_KEYSTORE
        # CM_KEYSTORE_PASSWORD
        # CM_KEY_PASSWORD
        # CM_KEY_ALIAS
```

### Publishing to Google Play Store

For publishing to Google Play Store you will need to [set up a service account in Google Play Console](../knowledge-base/google-play-api/) and save the contents of the `JSON` key file as a [secure environment variable](../variables/environment-variable-groups/#storing-sensitive-valuesfiles) in application or team settings under the name `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` in the `google_play` group.


Environment variables can be added in the Codemagic web app using the 'Environment variables' tab. You can then and import your variable groups into your codemagic.yaml. For example, if you named your variable group 'google_play', you would import it as follows:

```
workflows:
  workflow-name:
    environment:
      groups:
        - google_play
```

For further information about using variable groups please click [here](../variables/environment-variable-groups/).

## Running your Fastlane lane

In the codemagic.yaml you should install your depenpendencies with `bundle install` and then execute the Fastlane lane with `bundle exec fastlane <lane_name>` as follows:

```
      scripts:
        - bundle install
        - bundle exec fastlane release
```

If you need to use a specific version of bundler as defined in the Gemfile.lock file, you should install it with `gem install bundler:<version>` as follows:

```
      scripts:
        - gem install bundler:2.2.27
        - bundle install
        - bundle exec fastlane release
       
```

## Artifacts

To gather the .apk and .aab from your build, add an the **artifacts** section to your codemagic.yaml as follows:

```
      artifacts:
      - app/build/outputs/**/**/*.aab
      - app/build/outputs/**/**/*.apk      
```