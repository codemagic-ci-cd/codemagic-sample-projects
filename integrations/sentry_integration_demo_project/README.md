# sentry integration



## Getting Started

[Sentry](https://www.browserstack.com/) is open-source error tracking that helps developers to monitor, fix crashes in real time.

**dSYM** files store the debug symbols for your app. It contains mapping information to decode a stack-trace into readable format. The purpose of dSYM is to replace symbols in the crash logs with the specific methods so it will be readable and helpful for debugging the crash. In order to generate debug symbols, Sentry SDK must be installed using the following command line:

```
npm install --save @sentry/react-native
```
As soon as your build finishes successfully, debug symbols are generated. However, if you want them to be displayed in the **Codemagic UI** on the build page, then the following path needs to be configured in **codemagic.yaml** under the artifacts section:

```
 - $HOME/Library/Developer/Xcode/DerivedData/**/Build/**/*.dSYM
```
More information about **codemagic.yaml** can be found [here](https://docs.codemagic.io/yaml/yaml-getting-started/)

Generated **dSYM** files will be uploaded to Sentry using the following bash script in a post-build script(after building your binaries) under the publishing section:

```bash
 publishing:
    scripts:
      - name: Sntry Upload
        script: | 
            echo "Find build artifacts"
            dsymPath=$(find $CM_BUILD_DIR/build/ios/xcarchive/*.xcarchive -name "*.dSYM" | head -1)
            if [[ -z ${dsymPath} ]]
            then
            echo "No debug symbols were found, skip publishing to Sentry"
            else
            echo "Publishing debug symbols from $dsymPath to Sentry"
            sentry-cli --auth-token $SENTRY_ACCESS_TOKEN upload-dif --org $SENTRY_ORGANIZATION_NAME --project $SENTRY_PROJECT_NAME $dsymPath
            fi
```
Environment variables' $SENTRY_ACCESS_TOKEN, $SENTRY_ORGANIZATION_NAME and $SENTRY_PROJECT_NAME values need to be fetched from your Sentry account after signing up.
