# Emerge Tools integration Demo Project (YAML build configuration)

[Emerge Tools](https://www.emergetools.com/) helps you monitor and reduce app, analyze performance and improve app startup time. It provides continuous monitoring to write smaller, better code by profiling binary size on every pull request.

The `codemagic.yaml` in the root of this project contains an example of how to upload the archive to Emerge as part of your Codemagic CI/CD builds. Refer to the `Fastfile` for an example Fastlane script that uses the Emerge [fastlane plugin](https://github.com/EmergeTools/fastlane-plugin-emerge) to upload the archive to the Emerge website for detailed size analysis. Please refer to the Emerge Tools [documentation](https://docs.emergetools.com/docs/fastlane) for further information about configuring Fastlane.   


## Configuring access to Emerge in Codemagic

To get started with [Emerge Tools](https://www.emergetools.com/), you need to create an API key and save it as an environment variable in Codemagic.

1. Obtain an **API key** from your [Emerge Tools profile](https://www.emergetools.com/profile) by clicking the **Create a new API Key** button. 

> :warning: Make sure to save the API key, as you cannot view it again on the site.


2. Open your Codemagic app settings, and go to the **Environment variables** tab.
3. Enter the desired **_Variable name_**, e.g. `EMERGE_API_TOKEN`.
4. Copy and paste the API key string as **_Variable value_**.
5. Enter the variable group name, e.g. **_emergetools_credentials_**. Click the button to create the group.
6. Make sure the **Secure** option is selected.
7. Click the **Add** button to add the variable.

8. Add the variable group to your `codemagic.yaml` file
``` yaml
  environment:
    groups:
      - emergetools_credentials
```

## Emerge Fastlane plugin
Emerge has created a plugin for Fastlane that makes it easy to upload iOS builds. You can add it to your project by running:

``` yaml
  scripts:
    - name: Install Emerge Tools Fastlane plugin
      script: | 
        fastlane add_plugin emerge
```

In the `Fastfile`, create a lane that utilizes the `emerge` plugin to upload the archive. You can refer to the example in this project.

This script checks if the current build is building a pull request. If it is a pull request, it takes the source commit of the build and compares it to the build of the base commit hash. Then, it uploads it to Emerge for processing for the size comparison. Otherwise, it uploads the build to Emerge with the type "main".

## Configuring `codemagic.yaml`

You can upload the iOS build to Emerge Tool as a part of your Codemagic CI/CD workflow to automate the process. Here is an example of the scripts you can add to your `codemagic.yaml` for building the archive and uploading it to Emerge. Don't forget to upload a base build so Emerge can compare the archive's size differences in subsequent pull requests.

``` yaml
scripts:
  - name: Bundle install
    script: | 
      bundle install
  - name: Install Emerge Tools Fastlane plugin
    script: | 
      fastlane add_plugin emerge
  - name: Build ipa for distribution
    script: | 
      xcode-project build-ipa --project "$XCODE_PROJECT" --scheme "$XCODE_SCHEME"
  - name: Upload archive to Emerge Tools
    script: | 
      bundle exec fastlane emerge_app_upload
```

## Artifacts
To gather the .ipa, archive, and debug symbols from your build, add the **artifacts** section to your `codemagic.yaml` as follows:

``` yaml
artifacts:
    - ./*.ipa
    - ./*.xcarchive
    - ./*.dSYM.zip      
```