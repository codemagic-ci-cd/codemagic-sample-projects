# Kobiton integration with Codemagic

[**Kobiton**](https://kobiton.com/) is a mobile testing platform that accelerates delivery and testing of mobile apps by offering manual and automated testing on real devices, in cloud & on-premises.

## Configure Kobiton access

Once you [sign up](https://kobiton.com/) with Kobiton, make note of your **username** and **API access token**. You need to combine these to get the `base64` encoded authentication string formated as:

`username:api_token`

You can encode these credentials in the **macOS Terminal** using:

```bash
echo -n '<username>:<api_token>' | openssl base64
```

Alternatively, use an [online tool](https://mixedanalytics.com/knowledge-base/api-connector-encode-credentials-to-base-64/) to base64 encode this string. 

1. Open your Codemagic app settings, and go to the **Environment variables** tab.
2. Enter the desired **_Variable name_**, e.g. `KOBITON_CREDENTIALS`.
3. Copy and paste the `base64` encoded authentication string as **_Variable value_**.
4. Enter the variable group name, e.g. **_kobiton_credentials_**. Click the button to create the group.
5. Make sure the **Secure** option is selected.
6. Click the **Add** button to add the variable.

7. Add the variable group to your `codemagic.yaml` file
```yaml
  environment:
    groups:
      - kobiton_credentials
```


## Configure your project

**Kobiton** offers to test your generated binaries **(.ipa, .apk, .aab and zip)** on real devices by automating them. To get started, you need to inject the following capabilities into your project’s test scripts such as Appium:
### Android
```java
    String kobitonServerUrl = "https://nihalnevercode:c0eb5ab4-3f3f-43c0-9325-1ea473349ca8@api.kobiton.com/wd/hub";
    DesiredCapabilities capabilities = new DesiredCapabilities();

    // The generated session will be visible to you only. 
    capabilities.setCapability("sessionName", "Automation test session");
    capabilities.setCapability("sessionDescription", "");
    capabilities.setCapability("deviceOrientation", "portrait");
    capabilities.setCapability("captureScreenshots", true);
    capabilities.setCapability("useConfiguration", "");
    capabilities.setCapability("autoWebview", true);
    capabilities.setCapability("browserName", "chrome");
    capabilities.setCapability("deviceGroup", "KOBITON");

    // For deviceName, platformVersion Kobiton supports wildcard
    // character *, with 3 formats: *text, text* and *text*
    // If there is no *, Kobiton will match the exact text provided
    capabilities.setCapability("deviceName", "Galaxy S21 Ultra 5G");
    capabilities.setCapability("platformVersion", "12");
    capabilities.setCapability("platformName", "Android");
```

### iOS
``` java
    String kobitonServerUrl = "https://nihalnevercode:c0eb5ab4-3f3f-43c0-9325-1ea473349ca8@api.kobiton.com/wd/hub";
    DesiredCapabilities capabilities = new DesiredCapabilities();
    
    // The generated session will be visible to you only. 
    capabilities.setCapability("sessionName", "Automation test session");
    capabilities.setCapability("sessionDescription", "");
    capabilities.setCapability("deviceOrientation", "portrait");
    capabilities.setCapability("browserName", "safari");
    capabilities.setCapability("deviceGroup", "KOBITON");
    
    // For deviceName, platformVersion Kobiton supports wildcard
    // character *, with 3 formats: *text, text* and *text*
    // If there is no *, Kobiton will match the exact text provided
    capabilities.setCapability("deviceName", "iPad Air 2 (Wi-Fi)");
    capabilities.setCapability("platformVersion", "15.3.1");
    capabilities.setCapability("platformName", "iOS"); 
```

These capabitlies will allow Kobiton to detect which platform you want to execute your test scripts with. Each device specific capabilities for Java can be found in the **Kobiton devices list** by clicking **device settings** and then **Automation Settings**.


## Upload apps to Kobiton

The process of uploading your artifacts to **Kobiton** requires the following steps:
- Set the `APP_URL` and `APP_PATH` to upload to AWS S3 bucket
- Upload artifacts to AWS S3
- Upload to Kobiton environment
- \[Optional\] Get the URL in Codemagic Logs to be directed to test details

To perform these steps, add the required scripts to your `codemagic.yaml` file:

```yaml
  scripts:
    - name: Set the app URL and PATH
      script: | 
        CURL_RESULT=$(curl -X POST https://api.kobiton.com/v1/apps/uploadUrl \ 
          -H 'Authorization: Basic $KOBITON_CREDENTIALS' \ 
          -H 'Content-Type: application/json' \ 
          -d '{"filename": "your_desired_binary_name.ipa"}' | jq -r)

        APP_URL=$(jq -r '.url' <<<"$CURL_RESULT")
        APP_PATH=$(jq -r '.appPath' <<<"$CURL_RESULT") 
    - name: Upload artifacts to AWS
      script: | 
        curl -X PUT “$APP_URL” \
          -H 'content-type: application/octet-stream' \
          -H 'x-amz-tagging: unsaved=true' \
          -T "build/ios/ipa/kobition_integration.ipa"
    - name: Upload to Kobiton
      script: | 
        curl -X POST https://api.kobiton.com/v1/apps \
          -H 'Authorization:  Basic $KOBITON_CREDENTIALS' \
          -H 'Content-Type: application/json' \
          -H 'Accept: application/json' \
          -d '{"appPath": “’”$APP_PATH”’”}’
    - name: Get URL for logs
      script: | 
        curl -X POST https://api.kobiton.com/v1/revisitPlans/create \
          -H 'Authorization: Basic $KOBITON_CREDENTIALS' \
          -H 'Content-Type: application/json' \
          -H 'Accept: application/json'
        # Response should be formated as:
        # {"testRunId":123168,"testRunDetailLink":"https://portal.kobiton.com/plans/123168/executions"}
```


> **Note:** The above example uploads an `.ipa` to Kobiton. Adjust the paths and file names if you are building on Android or using a different artifact type.


After a successful upload, you should get **appId** and **versionId** in the Codemagic logs. After the whole process, check your App section in the Kobiton UI and you should see your uploaded binary there.