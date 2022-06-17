# Katalon integration with Codemagic

**Katalon** is designed to create and reuse automated test scripts for UI without coding.

## Jest, Mocha and Jasmine testing

In order to execute **jest**, **mocha** and **jasmine** tests and upload the test results to **Katalon**, you need to go through the following steps:

**Step 1: Install Katalon TestOps plugin**

```
npm i -s @katalon/testops-jest
```
**Step 2**: Create testops-config.json file in the root directory and the add the following:

```
{
   "apiKey": "KATALON_API_KEY",
   "projectId": "KATALON_PROJECT_ID",
   "reportFolder": "testops-report"
}
```

**KATALON_API_KEY** and **KATALON_PROJECT_ID** can be found under your Katalon account settings.

**Step 3**: Create files accordingly:

For Jest create file named **testops-config.json** and add the following in there:

```
module.exports = {
   "reporters": ["default", "@katalon/testops-jest"]
}
```
For Jest create file named **./tests/setup.js** and add the following in there:

```
import TestOpsJasmineReporter from "@katalon/testops-jasmine";
const reporter = new TestOpsJasmineReporter();
jasmine.getEnv().addReporter(reporter);
```
**Step 4: Run the following commands**:

For Jest:

```
npx jest
```

For Jasmine:

```
npx jasmine
```

For Mocha:

```
npx mocha --reporter @katalon/testops-mocha
```

## Junit reports

In order to execute and collect Junit XML reports, then submit them to the **Katalon** testing enviornment, the following steps must be followed:

1. Execute and assign test reports to a file by **test_report**. More info can be found [here](../yaml-testing/testing/):
 ```
- name: Test
 script: |
     ./gradlew test
 test_report: app/build/test-results/**/*.xml
 ```
 2. Install Katalon Report Uploader docker image to complete the upload process:
 ```
 docker run -t --rm -v $CM_BUILD_DIR/app/build/test-results/testReleaseUnitTest/:/katalon/report -e PASSWORD=$KATALON_API_KEY -e PROJECT_ID=$KATALON_PROJECT_ID -e TYPE=junit -e REPORT_PATH=/katalon/report katalonstudio/report-uploader:0.0.8
 ```

 **$KATALON_API_KEY** and **$KATALON_API_KEY** can be found in your Katalon account under the user settings.
