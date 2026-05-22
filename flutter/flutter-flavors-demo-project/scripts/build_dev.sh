# Buid DEV version of app
# Codemagic API documentation can be found here - https://docs.codemagic.io/rest-api/builds/
# Update appId, workflowId, branch, APP_STORE_ID, BUNDLE_ID, XCODE_SCHEME, XCODE_CONFIG, ENTRY_POINT to your own values.

curl -H "Content-Type: application/json" -H "x-auth-token: ${CM_API_KEY}" \
--data '{
    "appId": "6560a19c5141c1ce6d3a8deb",
    "workflowId": "ios-release",
    "branch": "main",
    "environment": {
        "variables": {
            "APP_STORE_ID": "1589804869",
            "BUNDLE_ID": "io.codemagic.flutterflavors.dev",
            "XCODE_SCHEME": "dev", 
            "XCODE_CONFIG": "Release-dev",
            "ENTRY_POINT": "lib/main_dev.dart"
        }
    }
}' \
https://api.codemagic.io/builds