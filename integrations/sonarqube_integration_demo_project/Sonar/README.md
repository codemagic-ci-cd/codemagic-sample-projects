# Integrating SonarQube with Codemagic (iOS)

This project illustrates how to integrate [SonarQube](https://www.sonarqube.org/) with Codemagic. The same steps apply if you are integrating with their cloud based [Sonar Cloud](https://sonarcloud.io/).

## [Optional] Create a SonarCloud account

If you are integrating with SonarCloud, you will first need to configure your app:

### Add your app to SonarCloud

1. Log into SonarCloud [here](https://sonarcloud.io/sessions/new)
2. Enter an organization key and click on **Continue**.
3. Choose the Free plan and click on **Create Organization**.
4. Click on **My Account**.
5. Under the Security tab, generate a token by entering a name and clicking on **Generate**.
6. Copy the token so you can use it as an environment variable in your Codemagic workflow.
7. Click on the “+” button in the top-right corner, and select **Analyze a new project** to add a new project.
8. Select the project and click on **Set Up**.
9. Wait for the initial analysis to complete, then modify the **Last analysis method**.
10. **Turn off** the SonarCloud Automatic Analysis.

You can now upload code analysis reports to SonarCloud from your CI/CD pipeline.


## Configuring access credentials

There are three **environment variables** that need to be added to your workflow for the SonarCloud integration: `SONAR_TOKEN`, `SONAR_PROJECT_KEY`, and `SONAR_ORG_KEY`.

- `SONAR_TOKEN` is the token you created when setting up your account
- `SONAR_PROJECT_KEY` can be obtained from your project settings once it has been added to SonarCloud
- `SONAR_ORG_KEY` is also obtained from your SonarCloud project settings

1. Open your Codemagic app settings, and go to the **Environment variables** tab.
2. Enter the desired **_Variable name_**, e.g. `SONAR_TOKEN`.
3. Enter the required value as **_Variable value_**.
4. Enter the variable group name, e.g. **_sonarcloud_credentials_**. Click the button to create the group.
5. Make sure the **Secure** option is selected.
6. Click the **Add** button to add the variable.
7. Repeat the process to add all of the required variables.

8. Add the **sonarcloud_credentials** group in your `codemagic.yaml` file

```yaml
  environment:
    groups:
      - sonarcloud_credentials
```

## Using SonarQube/SonarCloud
To use SonarQube/SonarCloud with iOS projects, you need to:

1. install the [Sonar Scanner](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/)
2. generate a debug build of your project
3. convert the coverage report to Sonarqube format
4. generate and upload code analysis report

All of these steps are already implemented in the included `codemagic.yaml` file in this project.

### Install Sonar Scanner
```yaml
  scripts:
    - name: Install Sonar Scanner
      script: | 
        brew install sonar-scanner
```

### Convert code coverage format
To convert the coverage report to Sonarqube format, create a bash script in your project's root folder named `xccov-to-sonarqube-generic.sh` as illustrated in this sample project.

#### iOS Project

For the iOS build analysis, we have to first download and add the [SonarScanner](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/) to the path. 
SonarScanners running in Codemagic can automatically detect branches and merge or pull requests in certain jobs.
```
workflows:
  ios-workflow:
    name: ios_workflow
    instance_type: mac_pro
    cache:
      cache_paths:
        - ~/.sonar
    environment:
      groups:
        - sonar
      vars:
        XCODE_WORKSPACE: "Sonar.xcodeproj"  # PUT YOUR WORKSPACE NAME HERE
        XCODE_SCHEME: "Sonar" # PUT THE NAME OF YOUR SCHEME HERE
      xcode: latest
      cocoapods: default
    triggering:
      events:
        - push
        - pull_request
      branch_patterns:
        - pattern: '*'
          include: true
          source: true
    scripts:
      - name: Run tests
        script: |
          xcodebuild \
          -project "$XCODE_WORKSPACE" \
          -scheme "$XCODE_SCHEME" \
          -sdk iphonesimulator \
          -destination 'platform=iOS Simulator,name=iPhone 12,OS=15.4' \
          clean build test CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
      - name: Build debug app
        script: |
          xcodebuild build -project "$XCODE_WORKSPACE" \
          -scheme "$XCODE_SCHEME" \
          CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
      - name: Sonar
        script: |
            # download and install the SonarScanner
            wget -O $FCI_BUILD_DIR/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.4.0.2170-macosx.zip
            unzip $FCI_BUILD_DIR/sonar-scanner.zip
            mv sonar-scanner-* sonar-scanner
      - name: Coverage tests
        script: |
            xcodebuild \
            -project "$XCODE_WORKSPACE" \
            -scheme "$XCODE_SCHEME" \
            -sdk iphonesimulator \
            -destination 'platform=iOS Simulator,name=iPhone 11 Pro,OS=15.4' \
            -derivedDataPath Build/ \
            -enableCodeCoverage YES \
            clean build test CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
      - name: convert coverage report to sonarqube format
        script: |
            bash xccov-to-sonarqube-generic.sh Build/Logs/Test/*.xcresult/ > sonarqube-generic-coverage.xml
      - name: Generate and upload code analysis report
        script: |
            export PATH=$PATH:$FCI_BUILD_DIR/sonar-scanner/bin
            sonar-scanner \
            -Dsonar.projectKey=$SONAR_PROJECT_KEY \
            -Dsonar.host.url=$SONARQUBE_URL \
            -Dsonar.c.file.suffixes=- \
            -Dsonar.cpp.file.suffixes=- \
            -Dsonar.coverageReportPaths=sonarqube-generic-coverage.xml \
    artifacts:
      - $HOME/Library/Developer/Xcode/DerivedData/**/Build/**/*.app
      - /tmp/xcodebuild_logs/*.log
      - $HOME/Library/Developer/Xcode/DerivedData/**/Build/**/*.dSYM
    publishing:
      email:
        recipients:
            - kalgi@nevercode.io
```

**Coverage Reports** cannot be uploaded in this format, so you have to use the following script to convert it from an `.xcresult` to an `.xml` file:

#### File name: xccov-to-sonarqube-generic.sh
```
#!/usr/bin/env bash
set -euo pipefail

function convert_file {
  local xccovarchive_file="$1"
  local file_name="$2"
  echo "  <file path=\"$file_name\">"
  local line_coverage_cmd="xcrun xccov view"
  if [[ $@ == *".xcresult"* ]]; then
    line_coverage_cmd="$line_coverage_cmd --archive"
  fi
  line_coverage_cmd="$line_coverage_cmd --file \"$file_name\" \"$xccovarchive_file\""
  eval $line_coverage_cmd | \
    sed -n '
    s/^ *\([0-9][0-9]*\): 0.*$/    <lineToCover lineNumber="\1" covered="false"\/>/p;
    s/^ *\([0-9][0-9]*\): [1-9].*$/    <lineToCover lineNumber="\1" covered="true"\/>/p
    '
  echo '  </file>'
}

function xccov_to_generic {
  echo '<coverage version="1">'
  for xccovarchive_file in "$@"; do
    local file_list_cmd="xcrun xccov view"
    if [[ $@ == *".xcresult"* ]]; then
      file_list_cmd="$file_list_cmd --archive"
    fi
    file_list_cmd="$file_list_cmd --file-list \"$xccovarchive_file\""
    eval $file_list_cmd | while read -r file_name; do
      convert_file "$xccovarchive_file" "$file_name"
    done
  done
  echo '</coverage>'
}

xccov_to_generic "$@"
```

Run this script using:
```
bash xccov-to-sonarqube-generic.sh Build/Logs/Test/*.xcresult/ > sonarqube-generic-coverage.xml
```
Pass the result to SonarQube by specifying the following properties:
```
-Dsonar.cfamily.build-wrapper-output.bypass=true \
-Dsonar.coverageReportPaths=sonarqube-generic-coverage.xml \
-Dsonar.c.file.suffixes=- \
-Dsonar.cpp.file.suffixes=- \
-Dsonar.objc.file.suffixes=-
```
![](https://blog.codemagic.io/uploads/2022/04/aws_4.png)

And that’s it! We have successfully integrated SonarQube with Codemagic.


### Automatically detecting pull requests

For SonarQube to automatically detect pull requests when using Codemagic, you need to add an event in the triggering section of your `codemagic.yaml` file as shown in the following snippet:
```
    triggering:
      events:
        - pull_request
```
For **triggering** to work, you also need to set up [webhook](https://docs.codemagic.io/configuration/webhooks/) between Codemagic and your DevOps platform (Bitbucket, Github, etc.).

## Caching the .sonar folder
Caching the `.sonar` folder would save build time on subsequent analyses. For this, add the following snippet to your `codemagic.yaml` file:
```
    cache:
      cache_paths:
        - ~/.sonar
```
