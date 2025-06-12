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
5. Send tests to Firebase Test Lab for execution on cloud devices

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
7. Send tests to Firebase Test Lab for execution on physical iOS devices

**Artifacts:**

- `build/ios_integ/Build/Products/ios_bundle.zip` - Complete iOS test bundle

**iOS Physical Device Setup:**
For running tests on physical iOS devices, this workflow handles the code signing requirements. The setup follows the [Patrol physical iOS devices documentation](https://patrol.leancode.co/documentation/physical-ios-devices-setup).

**Two Ways to Sign iOS Apps:**

1. **Codemagic Way:** Use the `ios_signing` section in codemagic.yaml with certificates and provisioning profiles uploaded to Codemagic team settings. This approach is currently configured in the workflow.

2. **Fastlane Way:** Comment out the `ios_signing` section and uncomment the Fastlane iOS script in the workflow. This uses the Fastlane `ios_patrol` lane that:
   - Sets up match profiles for both the main app (adhoc) and test runner (development)
   - Handles provisioning profiles for `RunnerUITests.xctrunner`
   - Builds in release mode as required for physical device testing

Both workflows are optimized for CI/CD environments and handle all necessary setup steps automatically.

## Running Tests with Firebase Test Lab

This project includes example scripts for running the built test artifacts on [Firebase Test Lab](https://firebase.google.com/docs/test-lab). You can replace these with your preferred testing provider's scripts.

### Android Test Execution

The Android workflow demonstrates how to send both the main APK and test APK to Firebase Test Lab:

```bash
gcloud firebase test android run \
   --type instrumentation \
   --use-orchestrator \
   --app $APK_PATH \
   --test $TEST_APK_PATH \
   --device model=MediumPhone.arm,version=35,locale=en,orientation=portrait
```

### iOS Test Execution

The iOS workflow shows how to run tests on physical iOS devices using the built test bundle:

```bash
gcloud firebase test ios run \
  --test=build/ios_integ/Build/Products/ios_bundle.zip \
  --device model=iphone14pro,version=16.6,locale=en,orientation=portrait \
  --type=xctest
```
