# app_automate_browserstack_integration



## Getting Started

[BrowserStack](https://www.browserstack.com/) is a cloud web and mobile testing platform that provides developers with the ability to test their websites and mobile applications across on-demand browsers, operating systems and real mobile devices. 


Now it is possible test your applications via **Codemagic** using the real devices offered by **BrowserStack**. For that purpose, you need to go through three steps using REST API endpoints:


1. Upload your app
2. Upload Test Suite
3. Start testing


In order to achive the above-mentioned steps, you need use the curl commands below after generating the respective artifacts:

```
 - name: BrowserStack upload
   script: |      
    APP_URL=$(curl -u "$BROWSERSTACK_USERNAME:$BROWSERSTACK_ACCESS_TOKEN" -X POST "https://api-cloud.browserstack.com/app-automate/upload" -F "file=@android/app/build/outputs/apk/release/app-release.apk" | jq -r '.app_url') 
    TEST_URL=$(curl -u "$BROWSERSTACK_USERNAME:$BROWSERSTACK_ACCESS_TOKEN" -X POST "https://api-cloud.browserstack.com/app-automate/espresso/test-suite" -F "file=@android/app/build/outputs/apk/androidTest/release/app-release-androidTest.apk" | jq -r '.test_url')
    curl -X POST "https://api-cloud.browserstack.com/app-automate/espresso/build" -d '{"devices": ["Google Pixel 3-9.0"], "app": "'"$APP_URL"'", "deviceLogs" : true, "testSuite": "'"$TEST_URL"'"}' -H "Content-Type: application/json" -u "$BROWSERSTACK_USERNAME:$BROWSERSTACK_ACCESS_TOKEN" 
```


**$BROWSERSTACK_USERNAME** and **$BROWSERSTACK_ACCESS_TOKEN** are generated to you automatically after signing up with **BrowserStack** and setting up the enviorment variables in the Codemagic UI will allow them to be used during a build.



In order to upload test suite for android apps, you need to run **./gradlew assembleAndroidTest** and also make sure that **app/build.gradle** file includes Instrumentation runner:

```
  defaultConfig {
     testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
}
```

If you are building your app in release mode, then do not forget to generate a test .apk in release mode by adding the following in  **app/build.gradle**:

```
    testBuildType "release"
```
