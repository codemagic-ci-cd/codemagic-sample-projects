# Build PROD version of app
# Codemagic API documentation can be found here - https://docs.codemagic.io/rest-api/builds/
# Update appId, workflowId, branch, APP_STORE_ID, BUNDLE_ID, XCODE_SCHEME, XCODE_CONFIG, ENTRY_POINT to your own values.

curl -H "Content-Type: application/json" -H "x-auth-token: ${CM_API_KEY}" \
--data '{
    "appId": "5faaaca7e55b87f29c8f246b", 
    "workflowId": "ios-release",
    "branch": "flavors", 
    "environment": { 
        "variables": { 
            "APP_STORE_ID": "1565355863",
            "BUNDLE_ID": "io.nevercode.flutterapp.prod",
            "XCODE_SCHEME": "prod", 
            "XCODE_CONFIG": "Release-prod",
            "ENTRY_POINT": "lib/main_prod.dart"
        }
    }
}' \
https://api.codemagic.io/builds