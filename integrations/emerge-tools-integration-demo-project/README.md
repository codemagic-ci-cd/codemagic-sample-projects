# Emerge Tools integration Demo Project (YAML build configuration)

The `codemagic.yaml` in the root of this project contains an example of how to upload the archive to Emerge as part of your Codemagic CI/CD builds. Refer to the `Fastfile` for an example Fastlane script that uses the Emerge [fastlane plugin](https://github.com/EmergeTools/fastlane-plugin-emerge) to upload the archive to the Emerge website for detailed size analysis. Please refer to the Emerge Tools [documentation](https://docs.emergetools.com/docs/fastlane) for further information about configuring Fastlane.   

Documentation for YAML builds can be found at the following URL:

https://docs.codemagic.io/getting-started/yaml/

## Environment variables

You need to add the **Emerge API Key** as an environment variable **environment variables** to your workflow for Emerge Tools integration: 

- `EMERGE_API_TOKEN ` - the API Key for authentication with custom integrations.

The environment variable can be added in the Codemagic web app using the 'Environment variables' tab. You can import your variable groups into your `codemagic.yaml`. For example, if you named your variable group 'emerge_credentials', you would import it as follows:

```
workflows:
  workflow-name:
    environment:
      groups:
        - emerge_credentials
```

For further information about using variable groups, please click [here](https://docs.codemagic.io/variables/environment-variable-groups/).

## Emerge Fastlane plugin
The 'Emerge Fastlane plugin' makes it easy to upload iOS builds to Emerge for processing. Add it as a script in your workflow:

```
scripts:
    - fastlane add_plugin emerge
```

## Running your Emerge Fastlane lane
In the `codemagic.yaml`, you should install the dependencies with `bundle install` and then execute the Fastlane lane for uploading the archive to Emerge Tools as follows:

```
scripts:
    - bundle install
    - bundle exec fastlane emerge_app_upload
```

## Artifacts
To gather the .ipa, archive, and debug symbols from your build, add the **artifacts** section to your `codemagic.yaml` as follows:

```
artifacts:
    - ./*.ipa
    - ./*.xcarchive
    - ./*.dSYM.zip      
```