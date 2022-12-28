# BrowserStack App Live sample project

[BrowserStack](https://www.browserstack.com/) is a cloud-based mobile testing platform that provides the ability to test your applications on real mobile devices. BrowserStack can be used as a part of your Codemagic CI/CD pipeline to test your applications.

## Configuring BrowserStack in Codemagic
Signing up with BrowserStack is required in order to be able to get the **username** and **access token**.

1. Open your Codemagic app settings, and go to the **Environment variables** tab.
2. Enter the desired **_Variable name_**, e.g. `BROWSERSTACK_USERNAME`.
3. Enter the required value as **_Variable value_**.
4. Enter the variable group name, e.g. **_browserstack_credentials_**. Click the button to create the group.
5. Make sure the **Secure** option is selected.
6. Click the **Add** button to add the variable.
7. Repeat the process to add the token as `BROWSERSTACK_ACCESS_TOKEN`

8. Add the variable group to your `codemagic.yaml` file
``` yaml
  environment:
    groups:
      - browserstack_credentials
```

## Submit to App Live
To use **App Live** and test your **.ipa** and **.apk** artifacts directly on real devices rather than simulators, add the following script to your `codemagic.yaml file:

``` yaml
  scripts:
    - name: Submitting app to Browserstack:
      script: | 
        curl -u "$BROWSERSTACK_USERNAME:$BROWSERSTACK_ACCESS_TOKEN" -X POST "https://api-cloud.browserstack.com/app-live/upload" -F "file=@build/ios/ipa/your_app_release.ipa"
```

**Note:** Make sure that you add this cURL request after building the **.ipa** and **.apk**, otherwise you cannot attach their paths to the cURL request.