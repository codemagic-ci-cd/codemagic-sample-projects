## iOS white labelling with a single scheme

The **codemagic.yaml** in this project can be used as a starter template for white labelling your iOS applications when building your apps with Codemagic CI/CD.

This example contains a workflow based around a native iOS app, but can be adapted to work with iOS apps build with other frameworks such as Flutter, React Native, Cordova, or Ionic.

In this example builds are triggered using the bash scrips in the .scripts folder but you can build your own application for triggering builds for specific app version or customer apps.

The scripts use the Codemagic API to trigger builds and pass environment variables to the workflow. This means a single workflow can be used to build multiple apps.

You can see that in this workflow assets are cloned from a repository used to store different assets for each app you want to build. The assest.sh script is used to replace files in the project with those clone from the assets repository.

When the app is build it is automatically published to App Store Connect/TestFlight.