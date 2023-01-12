# LambdaTest integration sample project

[**LambdaTest**](https://www.lambdatest.com/) is a cloud-based mobile testing platform that provides the ability to test your applications on real mobile devices. LambdaTest can be used as a part of your Codemagic CI/CD pipeline to test your applications.

**LambdaTest** offers two testing environments: **Real Time** and **App Automation**. Applications can be submitted to both testing environments through Codemagic using a cURL request.



## Configure LambdaTest in Codemagic

Registering with LambdaTest is required in order to be able to get the username and access token. You can sign up for free [here](https://www.lambdatest.com/).

The `LAMBDATEST_AUTH` environment variable is a `base64` encoded string which consists of the **username** you log into LambdaTest with and the LambdaTest API token you created: 

`username:api_token`

You can encode these credentials in the **macOS Terminal** using:

```bash
echo -n '<username>:<api_token>' | openssl base64
```

Alternatively, use an [online tool](https://mixedanalytics.com/knowledge-base/api-connector-encode-credentials-to-base-64/) to base64 encode this string. 

This value is used in the Authorization header used in cURL requests to the LambdaTest API.

1. Open your Codemagic app settings, and go to the **Environment variables** tab.
2. Enter the desired **_Variable name_**, e.g. `LAMBDATEST_AUTH`.
3. Copy and paste the `base64` encoded authentication string as **_Variable value_**.
4. Enter the variable group name, e.g. **_lambdatest_credentials_**. Click the button to create the group.
5. Make sure the **Secure** option is selected.
6. Click the **Add** button to add the variable.

7. Add the variable group to your `codemagic.yaml` file
```yaml
  environment:
    groups:
      - lambdatest_credentials
```


## LambdaTest Real Time

You can test your **.ipa** and **.apk** directly on real devices by submitting them to the **LambdaTest** environment via a cURL request:

```yaml
  scripts:
    - name: Submitting app to LambdaTest:
      script: | 
        curl --location --request POST 'https://manual-api.lambdatest.com/app/upload/realDevice' \ 
          --header 'Authorization: Basic $LAMBDATEST_AUTH' --form 'name="lambda1"' \ 
          --form 'appFile=@"app/build/outputs/apk/release/app-release.apk"'
```

As soon as your **.ipa** and **.apk** are successfully built, they will appear in the **LambdaTest UI** under **Real Device => Real Time**. Any preferred devices can be selected for testing with **Real Time**. 


## LambdaTest App Automation

In order to see your tests being uploaded to the **App Automation**, tests need to be included in your project. As soon as tests are detected, they will be automatically uploaded to the **App Automation** section and all the results can be viewed there. However, in order to enable it, some capabilities must be injected into your project's test scripts:

### Android

```java
    DesiredCapabilities capabilities = new DesiredCapabilities();
    capabilities.setCapability("platformName", "Android");
    capabilities.setCapability("deviceName", "Google Pixel 3");
    capabilities.setCapability("isRealMobile", true);
    capabilities.setCapability("platformVersion","10");
    capabilities.setCapability("app","lt://APP100202151634649275590734");
    capabilities.setCapability("deviceOrientation", "PORTRAIT");
    capabilities.setCapability("console",true);
    capabilities.setCapability("network",true);
    capabilities.setCapability("visual",true);
```

### iOS
```yaml
    DesiredCapabilities capabilities = new DesiredCapabilities();
    capabilities.setCapability("platformName", "iOS");
    capabilities.setCapability("deviceName", "iPhone 10");
    capabilities.setCapability("isRealMobile", true);
    capabilities.setCapability("platformVersion","10");
    capabilities.setCapability("app","lt://APP100202151634649275590734");
    capabilities.setCapability("deviceOrientation", "PORTRAIT");
    capabilities.setCapability("console",true);
    capabilities.setCapability("network",true);
    capabilities.setCapability("visual",true);
```

These capabitlies will allow **LambdaTest** to detect which platform you want to you execute your test scripts with. In these capabilities, the main part is **app URL** which is generated in the response of the cURL request:

```bash
{"app_id":"APP10020171164383758036593","name":"lambda1","type":"android","app_url":"lt://APP10020171444643838005433352"}
```



