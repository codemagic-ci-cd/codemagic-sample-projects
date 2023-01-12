# pCloudy integration with Codemagic

[pCloudy](https://www.pcloudy.com/) is a cloud-based mobile testing platform that provides the ability to test your apps on a wide-ranging list of real iOS and Android mobile devices and tablets.

## Configure pCloudy access

Signing up with pCloudy is required in order to be able to get the **username** and **access token**. You can sign up for free [here](https://www.pcloudy.com/).

1. Open your Codemagic app settings, and go to the **Environment variables** tab.
2. Enter the desired **_Variable name_**, e.g. `PCLOUDY_USERNAME`.
3. Enter the desired variable value as **_Variable value_**.
4. Enter the variable group name, e.g. **_pcloudy_credentials_**. Click the button to create the group.
5. Make sure the **Secure** option is selected.
6. Click the **Add** button to add the variable.
7. Repeat the steps to add the `PCLOUDY_API_TOKEN`.

8. Add the variable group to your `codemagic.yaml` file
```yaml
  environment:
    groups:
      - pcloudy_credentials
```

## Uploading artefacts to pCloudy

To upload your **.ipa**, **.apk** or **.aab** to pCloudy, add the following script after the build step in your `codemagic.yaml`:

```yaml
  scripts:
    - name: pCloudy upload
      script: | 
        APP_TOKEN=$(curl -u "$PCLOUDY_USERNAME:$PCLOUDY_API_TOKEN" \
          https://device.pcloudy.com/api/access | jq -r '.[].token')             
        curl -X POST -F "file=@android/app/build/outputs/apk/release/app-release.apk" \
          -F "source_type=raw" \
          -F "token=$APP_TOKEN" \
          -F "filter=all" https://device.pcloudy.com/api/upload_file
```

To also upload test suites for android apps, add the `./gradlew assembleAndroidTest` command to build tests and add another cURL command to upload:

```yaml
  scripts:
    - name: pCloudy upload
      script: | 
        APP_TOKEN=$(curl -u "$PCLOUDY_USERNAME:$PCLOUDY_API_TOKEN" \
          https://device.pcloudy.com/api/access | jq -r '.[].token')             
        curl -X POST -F "file=@android/app/build/outputs/apk/release/app-release.apk" \
          -F "source_type=raw" \
          -F "token=$APP_TOKEN" \
          -F "filter=all" https://device.pcloudy.com/api/upload_file

        # Tests
        curl -X POST -F "file=@android/app/build/outputs/apk/androidTest/release/app-release-androidTest.apk" \ 
          -F "source_type=raw" \
          -F "token=$APP_TOKEN" \
          -F "filter=all" https://device.pcloudy.com/api/upload_file
```
