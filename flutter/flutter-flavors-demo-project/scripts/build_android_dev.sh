#!/bin/sh
# Build Android DEV flavor as AAB
# Codemagic API documentation can be found here - https://docs.codemagic.io/rest-api/builds/
# Update appId, workflowId, branch, PACKAGE_NAME and GOOGLE_PLAY_TRACK to your own values.

curl -H "Content-Type: application/json" -H "x-auth-token: ${CM_API_KEY}" \
--data '{
    "appId": "69e60691a9b343d841eeaa77",
    "workflowId": "android-aab-release",
    "branch": "main",
    "environment": {
        "variables": {
            "ANDROID_FLAVOR": "dev",
            "ENTRY_POINT": "lib/main_dev.dart",
            "PACKAGE_NAME": "io.codemagic.flutterflavors.dev",
            "GOOGLE_PLAY_TRACK": "internal"
        }
    }
}' \
https://api.codemagic.io/builds
