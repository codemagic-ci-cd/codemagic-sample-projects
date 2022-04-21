# Integrating SonarQube with Codemagic

[SonarQube](https://www.sonarqube.org/) is the leading tool for continuously inspecting the **Code Quality** and **Security of your codebase** and guiding development teams during code reviews. It is an **open-source tool** and has support for [29 languages](https://www.sonarqube.org/features/multi-languages/) as of 8th April 2022 and they are growing.

#### Using SonarQube with Codemagic

We can easily integrate [SonarQube with Codemagic](https://docs.sonarqube.org/latest/analysis/codemagic/) using the [codemagic.yaml](https://docs.codemagic.io/yaml/yaml-getting-started/) file. Codemagic recently worked together with Christophe Havard (Product Manager, SonarQube) in adding Codemagic to the list of supported CIs for branch and pull-request detection. You can check the SonarQube release notes [here](https://jira.sonarsource.com/browse/SONAR-15412). 

To integrate Sonarqube with Codemagic, we will need to set the Environment variables in the Codemagic UI as shown below. Mark the environment variables **secure** and add the respective **group** to the codemagic.yaml file.

![](https://blog.codemagic.io/uploads/2022/04/aws_2.png)

Let’s define the build pipeline script in the codemagic.yaml file for the iOS project.

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

### Caching the .sonar folder
Caching the `.sonar` folder would save build time on subsequent analyses. For this, add the following snippet to your `codemagic.yaml` file:
```
    cache:
      cache_paths:
        - ~/.sonar
```
