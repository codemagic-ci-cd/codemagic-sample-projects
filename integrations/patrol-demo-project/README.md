# Patrol Integration Tests Demo Project

This sample project demonstrates how to write and run integration tests using [Patrol](https://patrol.leancode.co/), a powerful testing framework for Flutter applications developed by LeanCode. The project includes examples of:

- Setting up Patrol in a Flutter project
- Configuring Patrol in your codemagic.yaml workflow
- Testing Firebase integration

## Codemagic Workflows

This project includes two main workflows configured in `codemagic.yaml` for building Patrol integration tests:

### Patrol Android Build (`patrol_android_build`)

This workflow builds the Android application and test APKs for Patrol integration testing:

- **Instance**: mac_mini_m2
- **Max Duration**: 30 minutes
- **Flutter Version**: 3.27.3
- **Java Version**: 17

**Build Steps:**

1. Install Flutter dependencies with `flutter pub get`
2. Install Patrol CLI version 3.6.0

- Make sure that the CLI version is compatible with your Patrol version in pubspec.yaml. You can check the compatibility in the [Patrol compatibility table](https://patrol.leancode.co/documentation/compatibility-table).

3. Build Android APKs using `patrol build android --verbose`
4. Generate both the main app APK and the androidTest APK

**Artifacts:**

- `build/app/outputs/apk/dev/debug/app-dev-debug.apk` - Main application APK
- `build/app/outputs/apk/androidTest/dev/debug/app-dev-debug-androidTest.apk` - Test APK

### Patrol iOS Build (`patrol_ios_build`)

This workflow builds the iOS application bundle for Patrol integration testing on physical devices:

- **Instance**: mac_mini_m2
- **Max Duration**: 30 minutes
- **Flutter Version**: 3.27.3
- **Java Version**: 17

**Build Steps:**

1. Install Flutter dependencies with `flutter pub get`
2. Install Patrol CLI version 3.6.0

- Make sure that the CLI version is compatible with your Patrol version in pubspec.yaml. You can check the compatibility in the [Patrol compatibility table](https://patrol.leancode.co/documentation/compatibility-table).

3. Configure App IDs (main app: `pl.leancode.patrol.Example.dev`, test runner: `pl.leancode.patrol.Example`)
4. Run Fastlane `ios_patrol` lane for code signing setup
5. Build iOS bundle using `patrol build ios --clear-permissions --release --verbose`
6. Create a zip archive of the iOS build products

**Artifacts:**

- `build/ios_integ/Build/Products/ios_bundle.zip` - Complete iOS test bundle

**iOS Physical Device Setup:**
For running tests on physical iOS devices, this workflow handles the code signing requirements automatically through Fastlane. The setup follows the [Patrol physical iOS devices documentation](https://patrol.leancode.co/documentation/physical-ios-devices-setup), with code signing managed via the Fastlane `ios_patrol` lane that:

- Sets up match profiles for both the main app (adhoc) and test runner (development)
- Handles provisioning profiles for `RunnerUITests.xctrunner`
- Builds in release mode as required for physical device testing

Both workflows are optimized for CI/CD environments and handle all necessary setup steps automatically.

## Summary

After these steps you are ready to upload test files to any CI/CD platform and run tests in tools like [Firebase Test Lab](https://patrol.leancode.co/documentation/ci/firebase-test-lab) etc.
