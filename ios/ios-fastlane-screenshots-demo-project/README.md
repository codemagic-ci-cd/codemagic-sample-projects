## iOS Automatic Screenshots Using fastlane and Codemagic

The **codemagic.yaml** in this project can be used as a starter template for automating the screenshots using fastlane. 

The project contains an onboarding workflow based around a native iOS app and contains a UI test for capturing the screenshots.

The project also contains a demo `Snapfile` with the configuration matching the requirements of App Store Connect for the different screen sizes and devices. 

When the workflow is successfully built, it provides an artifact that contains the screenshots and an HTML that you open to see all the screenshots in different devices and languages.

You can combine it with `fastlane deliver` to upload screenshots, metadata, and binaries to App Store Connect and submit your app for App Store review.