# Integrating SonarQube with Codemagic (Android)

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
To use SonarQube/SonarCloud with Android projects, you need to add the **sonarqube plugin** to the `app/build.gradle` file:

```groovy
plugins {
    ...
    id "org.sonarqube" version "3.3"
    ...
}
```

## Automatically detecting pull requests

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