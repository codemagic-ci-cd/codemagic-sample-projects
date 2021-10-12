# Build PROD version of app
# Codemagic API documentation can be found here - https://docs.codemagic.io/rest-api/builds/
# Update appId, workflowId, branch, APP_STORE_ID, BUNDLE_ID, XCODE_SCHEME, XCODE_CONFIG, ENTRY_POINT to your own values.

curl -H "Content-Type: application/json" -H "x-auth-token: ${CM_API_KEY}" \
--data '{
    "appId": "60b8a0dd639c3e293b8bc002", 
    "workflowId": "ios-flutter-flavors",
    "branch": "update/flutter-flavors", 
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