# Sofy and Codemagic integration demo project


## Getting Started

**Sofy** is a testing automation platform that uses testing capabilities to enable tests without writing a single line of code. 

It is possible to publish binaries generated by **Codemagic** and schedule automation tests with **Sofy** via **codemagic.yaml**. More info can be found [here](../yaml/yaml-getting-started/)

In order to achieve it, you need to sign up with [**Sofy**](https://sofy.ai/) where you will access your API Key which is a must to have for deploying your apps via **Codemagic**.

The following **cURL** commands will help you achieveing the deployment process:

**Uploading apps**

```
- name: Publish APK / AAB / IPA to Sofy
  script: |
    curl --location --request POST 'https://api.sofy.ai/api/AppTests/buildUpload' \
    --header "SubscriptionKey: $SOFY_SUBSCRIPTION_KEY" \
    --form "applicationFile=@"$APK_PATH""
```

**Scheduling automation tests**

```
- name: Schedule an automation test with Sofy
  script: |
   curl --location --request POST 'https://api.sofy.ai/api/CICD/ScheduleAutomatedTestRun' 
    --header 'Content-Type: application/json'    
    --data-raw '{
    "APIKey":"$SOFY_API_KEY",
    "ScheduledID":9999
    }'
```

**Checking status of scheduled tests**

```
- name: Schedule an automation test with Sofy
  script: |
    curl --location --request POST 'https://api.sofy.ai/api/CICD/ScheduleAutomatedTestRunStatus'    
    --header 'Content-Type: application/json'     
    --data-raw '{
        "APIKey":"$SOFY_API_KEY",
        "ScheduledID":9999
    }'
```

**$SOFY_SUBSCRIPTION_KEY**, **ScheduledID** and **$SOFY_API_KEY** are coming from your **Sofy** account settings.