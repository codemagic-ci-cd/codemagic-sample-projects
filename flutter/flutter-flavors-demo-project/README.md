# Flutter flavors demo project

The **codemagic.yaml** in this project can be used as a starter template for white labelling your iOS applications when building your apps with Codemagic CI/CD.

This example contains a workflow based around a Flutter iOS app, but can be adapted to work with native iOS, Android or React Native.

In this example builds are triggered using the bash scrips in the .scripts folder but you can build your own application for triggering builds for specific app version or customer apps.

The scripts use the Codemagic API to trigger builds and pass environment variables to the workflow. This means a single workflow can be used to build multiple apps.

When the app is built it is automatically published to App Store Connect/TestFlight.

# Setting up multiple schemes in Xcode

If you want to setup Xcode schemes for 'dev' and 'prod' you would do the following:

1. Runner > Project [Runner] > Info tab
2. Rename Debug, Release, Profile to Debug-dev, Release-dev, Profile-dev
3. Duplicate Debug-dev, Release-dev, Profile-dev and rename to Debug-prod, Release-prod, Profile-prod
4. In the top menu click Product > Scheme > Manage Schemes...
5. Select the scheme called 'Runner' and press enter and rename to 'dev'
6. With the scheme you just renamed still selected click the settings icon and chose 'duplicate' and set its name to 'prod'
7. Set the following build configurations
    Run = Debug-prod
    Test = Debug-prod
    Profile = Profile-prod
    Analyze = Debug-prod
    Archive = Release-prod
8. Runner > Targets [Runner] > Build Settings > Click the + button > Add User-defined Setting > add a setting APP_DISPLAY_NAME and set the value next to each configuration.
9. Open the Info.plist for the project and add a new key called 'Bundle display name' and set the value to $(APP_DISPLAY_NAME)
10. Runner > Targets [Runner] > Signing & Capabilities > set the bundle identifier for each configuration. If done correctly with two schemes with two bundle ids then when you click 'All' you should see the two different bundle ids.
11. Run a build using flutter build ios --flavor dev or flutter build ios --flavor prod 
12. If you are using Flutter and use different entry point, remember to use the -t flag. For example:

- flutter build ios -t lib/main_dev.dart  --flavor dev
- flutter build ios -t lib/main_prod.dart  --flavor prod

