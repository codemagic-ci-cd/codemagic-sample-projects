# codecov_integration_demo_project



## Getting Started

[Codecov](https://about.codecov.io/) Codecov is a tool that is used to measure the test coverage of your codebase. 

It is possible to run test suite and collect code coverage via **lcov** and upload the results to **Codecov** directly from Codemagic yaml file.


To collect code coverage and set checks if coverage rate is less or more than expected and store test results in a location, the following script is needed:


```
 - name: Collecting code coverage and storing in a location
        script: |
           HOMEBREW_NO_AUTO_UPDATE=1 brew install lcov
           mkdir -p test-results 
           flutter test --coverage --machine > test-results/flutter.json  
           code_coverage=$(lcov --list $FCI_BUILD_DIR/coverage/lcov.info | sed -n "s/.*Total:|\(.*\)%.*/\1/p")
           echo "Code Coverage: ${code_coverage}% " | bc); then { echo "uploading to codecov" }; fi 
           if (( $(echo "$code_coverage < $CODE_COVERAGE_TARGET" | bc) )); then { echo "code coverage is less than expected" && exit 1; }; fi                  
        test_report: test-results/flutter.json  
```


After successfully passing this stage, Codecov upload comes. The following script is required to install the Codecov uploader and push the results to your Codecov account:

```
    - name: Codecov upload
    script: |
        #!/bin/bash
        curl -Os https://uploader.codecov.io/latest/macos/codecov
        chmod +x codecov
        ./codecov -t ${CODECOV_TOKEN} -f "test-results/flutter.json" 
```

Codecov allows you to upload from different machines types: macos, linux and windows:

For Mac:
```
    #!/bin/bash
    curl -Os https://uploader.codecov.io/latest/macos/codecov
    chmod +x codecov
    ./codecov -t ${CODECOV_TOKEN} -f "test-results/flutter.json" 
```

For Linux:

```
    curl -Os https://uploader.codecov.io/latest/linux/codecov
    chmod +x codecov
    ./codecov -t ${CODECOV_TOKEN} -f "test-results/flutter.json" 
```

For Windows:

```
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri https://uploader.codecov.io/latest/windows/codecov.exe 
    -Outfile codecov.exe
    .\codecov.exe -t ${CODECOV_TOKEN} -f "test-results/flutter.json" 
```


## Getting help and support 

Click the URL below to join the Codemagic Slack Community:

https://slack.codemagic.io/

Customers who have enabled billing can use the in-app chat widget to get support.

Need a business plan with 3 Mac Pro concurrencies, unlimited build minutes, unlimited team seats and business priorty support? Click [here](https://codemagic.io/pricing/) for details.