# Codemagic Magic Actions

Magic Actions refers to the post-processing of App Store Distribution jobs.

Once the build is uploaded to the App Store, Codemagic starts post-processing asynchronously outside of the macOS virtual machine.

This means that you don’t need to wait around and pay for Apple to process your builds in order to get a green build and continue with development.

The timeout on the post-processing is set to 60 minutes and this does not count towards build minutes or concurrencies.

This is a feature available for customers using Teams in Codemagic.

[![Codemagic build status](https://api.codemagic.io/apps/60b8a0dd639c3e293b8bc002/ios-magic-actions/status_badge.svg)](https://codemagic.io/apps/60b8a0dd639c3e293b8bc002/ios-magic-actions/latest_build)

![Alt text](magic-actions.png?raw=true "Magic Actions")