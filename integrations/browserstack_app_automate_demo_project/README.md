# BrowserStack App Automate sample project

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

## App Automate

In order to use BrowserStack **App Automate** service through Codemagic, you need to add scripts to your `codemagic.yaml` file to perform these three steps using REST API endpoints:
1. Upload your app
2. Upload test suite
3. Start testing

In order to upload test suites for android apps, you need to run `./gradlew assembleAndroidTest` in your build script. Make sure that your **app/build.gradle** file includes **Instrumentation Runner**:

``` Groovy
  defaultConfig {
     testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
}
```


If you are building your app in **release mode**, then you also need to build your test suite .apk in release mode by adding the following in app/build.gradle:

``` Groovy
    testBuildType "release"
```

Your `codemagic.yaml` file will look similar to this:
``` yaml
  scripts:
    - name: Build Android Test release
      script: | 
        cd android # change folder if necessary 
        ./gradlew assembleAndroidTest
    - name: BrowserStack upload
      script: | 
        APP_URL=$(curl -u "$BROWSERSTACK_USERNAME:$BROWSERSTACK_ACCESS_TOKEN" \
          -X POST "https://api-cloud.browserstack.com/app-automate/upload" \
          -F "file=@android/app/build/outputs/apk/release/app-release.apk" \ 
          | jq -r '.app_url') 
    
        TEST_URL=$(curl -u "$BROWSERSTACK_USERNAME:$BROWSERSTACK_ACCESS_TOKEN" \
          -X POST "https://api-cloud.browserstack.com/app-automate/espresso/test-suite" \
          -F "file=@android/app/build/outputs/apk/androidTest/release/app-release-androidTest.apk" \
           | jq -r '.test_url')
     
        curl -X POST "https://api-cloud.browserstack.com/app-automate/espresso/build" \
          -d '{"devices": ["Google Pixel 3-9.0"], "app": "'"$APP_URL"'", "deviceLogs" : true, "testSuite": "'"$TEST_URL"'"}' \
           -H "Content-Type: application/json" -u "$BROWSERSTACK_USERNAME:$BROWSERSTACK_ACCESS_TOKEN" 
```
