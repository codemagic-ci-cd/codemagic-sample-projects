# Build PROD version of app
# Codemagic API documentation can be found here - https://docs.codemagic.io/rest-api/builds/
# Update appId, workflowId, branch, APP_STORE_ID, BUNDLE_ID, XCODE_SCHEME, XCODE_CONFIG, ENTRY_POINT to your own values.

curl -H "Content-Type: application/json" -H "x-auth-token: ${CM_API_KEY}" \
--data '{
    "appId": "69e60691a9b343d841eeaa77",
    "workflowId": "ios-release",
    "branch": "main",
    "environment": {
        "variables": {
            "APP_STORE_ID": "1589804841",
            "BUNDLE_ID": "io.codemagic.flutterflavors.prod",
            "XCODE_SCHEME": "prod", 
            "XCODE_CONFIG": "Release-prod",
            "ENTRY_POINT": "lib/main_prod.dart"
        }
    }
}' \
https://api.codemagic.io/builds
