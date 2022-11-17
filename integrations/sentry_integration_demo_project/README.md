# Integrating Codemagic with Sentry

[**Sentry**](https://sentry.io/from/crashlytics/) is a crash reporting platform that provides you with real-time insight into production deployments with info to reproduce and fix crashes.

This sample project shows how to upload your **dSYM** files to Sentry directly from your workflow.

## Configure access to Sentry

In order to configure them correctly, a Sentry access token (`SENTRY_ACCESS_TOKEN`) is required which can be found in your Sentry account after signing up. After getting the necessary token along with your organization name (`SENTRY_ORGANIZATION_NAME`) and project name (`SENTRY_PROJECT_NAME`), add them as environment variables in Codemagic.

1. Open your Codemagic app settings, and go to the **Environment variables** tab.
2. Enter the desired **_Variable name_**, e.g. `SENTRY_ACCESS_TOKEN`.
3. Copy and paste the API token string as **_Variable value_**.
4. Enter the variable group name, e.g. **_sentry_credentials_**. Click the button to create the group.
5. Make sure the **Secure** option is selected.
6. Click the **Add** button to add the variable.
7. Repeat the steps to also add `SENTRY_ORGANIZATION_NAME` and `SENTRY_PROJECT_NAME` variables.

8. Add the variable group to your `codemagic.yaml` file
```yaml
  environment:
    groups:
      - sentry_credentials
```

## Install Sentry dependency

To generate debug symbols with **Sentry**, a platform-specific dependency needs to be installed. **Sentry** provides different ways of installing the Sentry dependency according to which platform your app is built with. More information can be found in the **Sentry** documentation [here](https://docs.sentry.io/).

The following example installs the dependency for React Native apps:

```yaml
  scripts:
    - name: Install Sentry dependency
      script: | 
        npm install --save @sentry/react-native
```

## Specify artifacts path

As soon as your build finishes successfully, debug symbols are generated. However, if you want them to be displayed in the Codemagic UI build page, the following path needs to be configured in **codemagic.yaml** under the artifacts section:

```yaml
  artifacts:
    - $HOME/Library/Developer/Xcode/DerivedData/**/Build/**/*.dSYM
```

## Publish to Sentry

In order to upload the dSYM files to Sentry, add the following script to your **codemagic.yaml** configuration file or to your post-publish script in the Flutter workflow editor: 

```yaml
  scripts:
    - name: Install Sentry dependency
      script: | 
        echo "Find build artifacts"
        dsymPath=$(find $CM_BUILD_DIR/build/ios/xcarchive/*.xcarchive -name "*.dSYM" | head -1)
        if [[ -z ${dsymPath} ]]
          then
            echo "No debug symbols were found, skip publishing to Sentry"
          else
            echo "Publishing debug symbols from $dsymPath to Sentry"
            sentry-cli --auth-token $SENTRY_ACCESS_TOKEN upload-dif \
              --org $SENTRY_ORGANIZATION_NAME \
              --project $SENTRY_PROJECT_NAME $dsymPath
        fi
```

The above-mentioned **dsymPath** is React Native and Native iOS specific and it could change depending on what platform the app is built. For example, Flutter apps should use:

```yaml
dsymPath=$(find $CM_BUILD_DIR/build/ios/archive/Runner.xcarchive -name "*.dSYM" | head -1)
```

If necessary, you can use remote access to the build machine to find the correct path. More information can be found [here](https://docs.codemagic.io/troubleshooting/accessing-builder-machine-via-ssh/).
