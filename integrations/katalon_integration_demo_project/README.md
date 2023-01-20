# Katalon integration with Codemagic

[**Katalon**](https://katalon.com/) is designed to create and reuse automated test scripts for UI without coding.
## Configure Katalon access

In order to create a project and retrive API key that are used when uploading test to the Katalon testing environment, you need to sign up with Katalon.

1. Open your Codemagic app settings, and go to the **Environment variables** tab.
2. Enter the desired **_Variable name_**, e.g. `KATALON_API_KEY`.
3. Enter the API key string as **_Variable value_**.
4. Enter the variable group name, e.g. **_katalon_credentials_**. Click the button to create the group.
5. Make sure the **Secure** option is selected.
6. Click the **Add** button to add the variable.
7. Repeat the steps to add the `KATALON_PROJECT_ID`.

8. Add the variable group to your `codemagic.yaml` file
```yaml
  environment:
    groups:
      - katalon_credentials
```

9. Katalon requires that you create a `testops-config.json` file in your project root. In order to avoid exposing your API key in the repository, add a script to create the required file during build time.

```yaml
  scripts:
    - name: Create testops-config for Katalon
      script: | 
        cat >> "testops-config.json" << EOF 
          {                                 
            "apiKey": "$KATALON_API_KEY",   
            "projectId": "$KATALON_PROJECT_ID", 
            "reportFolder": "testops-report"    
          }
EOF
```

## Jest, Mocha and Jasmine testing

In order to execute **jest**, **mocha** and **jasmine** tests and upload the test results to **Katalon**, you need to go through the following steps:

#### Install Katalon TestOps plugin

```yaml
  scripts:
    - name: Create testops-config for Katalon
      script: | 
        npm i -s @katalon/testops-jest
```

#### Create files for Jest

For Jest, add the following to the `testops-config.json` file created earlier (add these lines to the **Create testops-config for Katalon** script):

```json
  module.exports = {
    "reporters": ["default", "@katalon/testops-jest"]
  }
```


For Jest, also create a file named `./tests/setup.js` with the following content:

```javascript
  import TestOpsJasmineReporter from "@katalon/testops-jasmine";
  const reporter = new TestOpsJasmineReporter();
  jasmine.getEnv().addReporter(reporter);
```


#### Run the appropriate command

##### Jest
```yaml
  scripts:
    - name: Run Katalon command
      script: npx jest
```

##### Jasmine
```yaml
  scripts:
    - name: Run Katalon command
      script: npx jasmine
```

##### Mocha
```yaml
  scripts:
    - name: Run Katalon command
      script: npx mocha --reporter @katalon/testops-mocha
```


## Junit reports

In order to collect Junit XML reports and submit them to **Katalon**, add the following steps to your scripts section of `codemagic.yaml`:

1. Execute and save test reports to a file by using **test_report** flag. More info about **test_report** flag can be found [here](https://docs.codemagic.io/yaml-testing/testing/):
 
2. Install Katalon Report Uploader docker image and complete the upload process

```yaml
  scripts:
    - name: Generate test report
      script: | 
        ./gradlew test
      test_report: app/build/test-results/**/*.xml
    - name: Upload to Katalon
      script: | 
        docker run -t --rm \
          -v $CM_BUILD_DIR/app/build/test-results/testReleaseUnitTest/:/katalon/report \
          -e PASSWORD=$KATALON_API_KEY \
          -e PROJECT_ID=$KATALON_PROJECT_ID\
          -e TYPE=junit \
          -e REPORT_PATH=/katalon/report katalonstudio/report-uploader:0.0.8
```