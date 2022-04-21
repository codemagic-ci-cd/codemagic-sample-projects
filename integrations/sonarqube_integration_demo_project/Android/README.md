# Integrating SonarQube with Codemagic

[SonarQube](https://www.sonarqube.org/) is the leading tool for continuously inspecting the **Code Quality** and **Security of your codebase** and guiding development teams during code reviews. It is an **open-source tool** and has support for [29 languages](https://www.sonarqube.org/features/multi-languages/) as of 8th April 2022 and they are growing.

#### Using SonarQube with Codemagic

We can easily integrate [SonarQube with Codemagic](https://docs.sonarqube.org/latest/analysis/codemagic/) using the [codemagic.yaml](https://docs.codemagic.io/yaml/yaml-getting-started/) file. Codemagic recently worked together with Christophe Havard (Product Manager, SonarQube) in adding Codemagic to the list of supported CIs for branch and pull-request detection. You can check the SonarQube release notes [here](https://jira.sonarsource.com/browse/SONAR-15412). 

To integrate Sonarqube with Codemagic, we will need to set the Environment variables in the Codemagic UI as shown below. Mark the environment variables **secure** and add the respective **group** to the codemagic.yaml file.

![](https://blog.codemagic.io/uploads/2022/04/aws_2.png)

Also, Navigate to your `app/build.gradle` and add the SonarQube Gradle plugin:
```
plugins {
    id "org.sonarqube" version "3.0"
}
```

Let’s define the build pipeline script in the codemagic.yaml file for the Android project.

#### Android Project
```
workflows:
  android-workflow:
    name: Android Workflow
    instance_type: mac_pro
    cache:
      cache_paths:
        - ~/.sonar
    environment:
      groups:
        - sonarqube # includes SONAR_TOKEN, SONARQUBE_URL, SONAR_PROJECT_KEY
    triggering:
      events:
        - push
        - pull_request
      branch_patterns:
        - pattern: '*'
          include: true
          source: true
    scripts:     
      - name: Build Android app
        script: |
          ./gradlew assembleDebug
      - name: Generate and upload code analysis report
        script: |
           ./gradlew sonarqube \
-Dsonar.projectKey=$SONAR_PROJECT_KEY \
-Dsonar.host.url=$SONARQUBE_URL \
-Dsonar.login=$SONAR_TOKEN
```
Once the build is successful, you can check your code analysis on SonarQube UI. 

![](https://blog.codemagic.io/uploads/2022/04/aws_3.png)

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
