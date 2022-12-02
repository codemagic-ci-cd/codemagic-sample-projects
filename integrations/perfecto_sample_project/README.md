# Integrating Codemagic with Perfecto


## Getting Started

**Perfecto** is a web-based Software as a Service (SaaS) platform that allows mobile application developers and QA Engineers to work with services such as advanced automation, monitoring and testing services. It is possible to integrate with Perfecto directly from your **codemagic.yaml**

Signing up with [Perfect](https://www.perfecto.io/) is required in order to get credentials that are needed during an upload process. 

Usin the following cURL script in a pre-build script(a script that is run after executing build commands in yaml), **.apk**, **.aab** and **.ipa** binaries can be uploaded to the Perfecto platform:

```
curl "https://web.app.perfectomobile.com/repository/api/v1/artifacts" -H "Perfecto-Authorization: $PERFECTO_TOKEN" -H "Content-Type: multipart/form-data" -F "requestPart={\"artifactLocator\":\"PRIVATE:app.aab\",\"artifactType\":\"ANDROID\",\"override\":true}" -F "inputStream=@/path/to/app.aab"
```

**PERFECTO_TOKEN** can found in the Perfecto UI with your account. Environment variables can be added in the Codemagic web app using the ‘Environment variables’ tab. You can then and import your variable groups into your codemagic.yaml. For example, if you named your variable group ‘browserstack_credentials’, you would import it as follows:

```
workflows:
  workflow-name:
    environment:
      groups:
        - perfecto_credentials
```

For further information about using variable groups please click [here](.../variables/environment-variable-groups/).


## Test Automation

In order to automate tests, desired capabitlies can be set inside your custom made test scripts in your project. For example, if your application requires device sensors such as camera or fingerprint reader, then **sensorInstrument** needs to be set:

```
capabilities.setCapability("sensorInstrument", true);
```

With Appium tests **autoInstrument** capability automatically instrument the application and it needs to be set to true:

```
capabilities.setCapability("autoInstrument", true);
```
