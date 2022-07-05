# Flutter Integration Tests Demo Project (YAML build configuration)

## Flutter Integration Tests starter template 

The **codemagic.yaml** in this Flutter project can be used as a starter template for building your apps with Codemagic CI/CD and running UI tests using the [integration test](https://pub.dev/packages/integration_test) package. This allows tests to be run on emulators and real devices. This means that your integration tests can be run on services such as Firebase Test Lab or AWS device Farm. 

This example contains one workflow which shows how to use the integration test package on Android OS devices. 

There are links to the Codemagic documentation for additional information about code signing and publishing.

Documentation for YAML builds can be found at the following URL: 

https://docs.codemagic.io/getting-started/yaml/

## Firebase Test Lab prerequisites

You will need to set up the following in the [Firebase console](https://firebase.google.com/)

<ol>
<li>Create a Firebase project</li>
<li>Create a service account and download the credentials file so you can authenticate with Firebase Test Lab using the CLI tools to run your tests</li>
<li>Enable the ‘Cloud tools results API’</li>
</ol>

Please follow the guides in the [Firebase test lab documentation](https://firebase.google.com/docs/test-lab/?gclid=EAIaIQobChMIs5qVwqW25QIV8iCtBh3DrwyUEAAYASAAEgLFU_D_BwE) to set up a project.

## Configuring the codemagic.yaml

<ol>
<li>Add a copy of the codemagic.yaml to the root of the repository branch you want to build</li>
<li>Update the values in codemagic.yaml file in the indicated places. Use the documentation links for help if required.</li>
<li>Login to your Codemagic account at https://codemagic.io/login</li>
<li>Add the repository for your Flutter application in the Codemagic web app</li>
<li>Click the 'Set up build' button on the respository</li>
<li>Select a 'Flutter App' workflow</li>
<li>Click the 'Start new build' button at the top of the screen </li>
<li>In the dialog that appears, select the branch and workflow you would like to build and click the 'Start new build' button</li>
</ol>

## Adding the integration test package to your Flutter Android project

Add the [integration test](https://pub.dev/packages/integration_test) package to your pubpec.yaml and run `flutter pub get`.

Create a folder called `test_driver` in the root of your project and create a folder in it called `integration_driver.dart`. 

Add the following to the file:

```

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();

```

## Preparing the Integration tests file

Please refer to the documentation provided for the integration test package [here](https://pub.dev/packages/integration_test). 

The following instructions below are here only for your convenience.

Create a folder called `integration_test` in the root of your project and add a file called `app_test.dart`. To start with add the following:

```
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart';
import 'dart:io';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Your integration tests will go here

}
```

For examples of how to write your integration tests please see the `integration_test/app_test.dart` in this demo project. 

## Running your Flutter integration tests

To run your integration tests on an emulator running on your local machine or a physical device connected with USB, use the following command to run your tests:

```

flutter driver --driver=test_driver/integration_driver.dart --target=integration_test/app_test.dart


```

## Configuring your Flutter Android project to run on real devices

1. Create a folder called `androidTest` in `android/app/src` 
2. Create a subfolder structure as follows that matches your package name. In this demo project the package name is "io.codemagic.integration" so the structire needs to be `androidTest/java/io/codemagic/integration`
3. Add a file in the end folder called `MainActivityTest.java`. Add the following to its contents:

```

    // Change this to your package name!!
    package io.codemagic.integration;

    import androidx.test.rule.ActivityTestRule;
    import dev.flutter.plugins.integration_test.FlutterTestRunner;
    import org.junit.Rule;
    import org.junit.runner.RunWith;

    // Change this your_package_name.MainActivity !!
    import io.codemagic.integration.MainActivity;

    @RunWith(FlutterTestRunner.class)
    public class MainActivityTest {
    @Rule
    public ActivityTestRule<MainActivity> rule = new ActivityTestRule<>(MainActivity.class, true, false);
    }

```
4. Under `android/app/src/main/kotlin` add folders to match the structur of your package name e.g. `android/app/src/main/kotlin/io/codemagic/integration`. 
5. Add a file called `MainActivity.kt` with the following contents:

```
    // Change this to the name of your package!!
    package io.codemagic.integration;

    import io.flutter.embedding.android.FlutterActivity

    class MainActivity: FlutterActivity() {
    }

```

6. In `android/app/build.gradle` add the following lines to your dependencies section:

```

dependencies {
    ...

    testImplementation 'junit:junit:4.12'
    androidTestImplementation 'androidx.test:runner:1.2.0'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.2.0'
}

```


## Understanding the scripts to run tests on Firebase Test Lab

In codemagic.yaml file the script called `Create debug and test APK` will create two .apk files. One is the debug version of your app, and the other is the .apk that is used to run the integration tests.

The script called `Run Firebase Test Lab tests` will use the `gcloud` CLI tools to authenticate with Firebase and then run the test passing in the debug apk, the test .apk, and specifying a build timeout. 

## Getting help and support

Click the URL below to join the Codemagic Slack Community:

https://slack.codemagic.io/

Customers who have enabled billing can use the in-app chat widget to get support. 

Need a business plan with 3 Mac Pro concurrencies, unlimited build minutes, unlimited team seats and business priorty support? Click [here](https://codemagic.io/pricing/) for details.
