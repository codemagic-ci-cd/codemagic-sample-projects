# Codecov integration for test coverage reports

## Getting Started

This sample project shows how you can run a test suite and collect test coverage using **lcov** and then upload the results to [Codecov](https://about.codecov.io/) directly from your `codemagic.yaml` file.

## Configure Codecov access

1. In order to get a dedicated Codecov token, signing up is required. You can sign up for free [here](https://about.codecov.io/).
1. Open your Codemagic app settings, and go to the **Environment variables** tab.
2. Enter the desired **_Variable name_**, e.g. `CODECOV_TOKEN`.
3. Copy and paste the Capgo token string as **_Variable value_**.
4. Enter the variable group name, e.g. **_codecov_credentials_**. Click the button to create the group.
5. Make sure the **Secure** option is selected.
6. Click the **Add** button to add the variable.

7. Add the variable group to your `codemagic.yaml` file
``` yaml
  environment:
    groups:
      - codecov_credentials
```
## Collecting test results

After writing tests with your test suite you can generate a coverage report using **lcov** and upload that coverage report to **Codecov** directly via **codemagic.yaml**. It is also possible to exit the script if code coverage is lower or higher than the expected treshold. Refer to the sample script below:

``` yaml
  scripts:
    - name: Create coverage report
      script: | 
        HOMEBREW_NO_AUTO_UPDATE=1 brew install lcov
        mkdir -p test-results 
        flutter test --coverage --machine > test-results/flutter.json  
        
        code_coverage=$(lcov --list $FCI_BUILD_DIR/coverage/lcov.info | sed -n "s/.*Total:|\(.*\)%.*/\1/p")
        
        echo "Code Coverage: ${code_coverage}% "
        if (( $(echo "$code_coverage < $CODE_COVERAGE_TARGET" | bc) ))
          then { echo "code coverage is less than expected" && exit 1; }
        fi  
  
        test_report: test-results/flutter.json
```

Codecov accepts **.xml** **.json** and **.txt** coverage report formats. You can display test results visually in the build overview by adding them to a path. Just include the **test_report** field with a glob pattern matching the test result file location. More information can be found [here](https://docs.codemagic.io/yaml-testing/testing/).


## Submitting to Codecov

Code coverages can be submitted to the Codecov environment through Codemagic using a **cURL** request.

Codecov uses a separate upload tool to make it easy to upload coverage reports to Codecov for processing. Depending on the build machine type, add the corresponding script to your `codemagic.yaml` file: 

### macOS
``` yaml
  scripts:
    - name: Codecov upload
      script: | 
        curl -Os https://uploader.codecov.io/latest/macos/codecov
        chmod +x codecov
        ./codecov -t ${CODECOV_TOKEN}
```

### Linux
``` yaml
  scripts:
    - name: Codecov upload
      script: | 
        curl -Os https://uploader.codecov.io/latest/linux/codecov
        chmod +x codecov
        ./codecov -t ${CODECOV_TOKEN}
```
### Windows
``` yaml
  scripts:
    - name: Codecov upload
      script: | 
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri https://uploader.codecov.io/latest/windows/codecov.exe -Outfile codecov.exe
        .\codecov.exe -t ${CODECOV_TOKEN}
```

After successfully uploading code coverage to **Codecov**, line-by-line coverage will be displayed on your GitHub pull requests via GitHub Checks. More information can be found [here](https://about.codecov.io/blog/announcing-line-by-line-coverage-via-github-checks/#:~:text=On%20a%20pull%20request%2C%20simply,right%20side%20of%20the%20annotation).

## Getting help and support

If you have a technical question or need help with some particular issue, you can get help in our [GitHub discussions](https://github.com/codemagic-ci-cd/codemagic-docs/discussions) page.

Customers who have enabled billing can use the in-app chat widget to get support. You have to be logged in to see the chat icon at the bottom right corner (please note that some ad blockers might block the chat widget).