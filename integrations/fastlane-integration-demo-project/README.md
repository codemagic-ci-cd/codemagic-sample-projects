# Fastlane integration Demo Project (YAML build configuration)

The codemagic.yaml in the root of this project contains an example of how to run a Fastlane lane as part of your Codemagic CI/CD builds. Refer to the Fastfile for an exmaple Fastlane script that increments the project build number, builds the iOS app and then deploys to TestFlight. Please refer to the Fastlane [documentation](https://docs.fastlane.tools/) for further information about configuring Fastlane.   

Documentation for YAML builds can be found at the following URL:

https://docs.codemagic.io/getting-started/yaml/

## Environment variables

Five **environment variables**  need to be added to your workflow for Fastlane integration: 

- `MATCH_PASSWORD` - the password used to encrypt/decrypt the repository used to store your distrbution certificates and provisioning profiles.
- `MATCH_KEYCHAIN` - an arbritrary name to use for the keychain on the build server e.g "codemagic_keychain"
- `APP_STORE_CONNECT_PRIVATE_KEY` - the App Store Connect API. Copy the entire contents of the .p8 file and paste into the environment variable value field.
- `APP_STORE_CONNECT_KEY_IDENTIFIER` - the key identifier of your App Store Connect API key.
- `APP_STORE_CONNECT_ISSUER_ID` - the issuer of your App Store Connect API key.

Environment variables can be added in the Codemagic web app using the 'Environment variables' tab. You can then and import your variable groups into your codemagic.yaml. For example, if you named your variable group 'fastlane', you would import it as follows:

```
workflows:
  workflow-name:
    environment:
      groups:
        - fastlane
```

For further information about using variable groups please click [here](https://docs.codemagic.io/variables/environment-variable-groups/).

## Cocoapods

If you are using dependencies from Cocoapods it might be necessary to include the cocoapods gem in your Gemfile to prevent scope conflict issues. 

```
gem "fastlane"
gem "cocoapods"
```