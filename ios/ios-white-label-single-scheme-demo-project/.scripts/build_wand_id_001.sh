#!/bin/sh
# Example of how to use the Codemagic API to trigger a build
# See the following documentation for more information - https://docs.codemagic.io/rest-api/builds/#start-a-new-build

curl -H "Content-Type: application/json" -H "x-auth-token: ${CM_API_KEY}" \
--data '{
    "appId": "50550a55555f5d5d5b0005b", 
    "workflowId": "ios-prod",
    "branch": "main", 
    "environment": { 
        "variables": { 
            "ASSET_GIT_BRANCH": "id_001", 
            "BUNDLE_ID": "io.codemagic.wand",
            "BUNDLE_VERSION": "1.0.0",
            "BUNDLE_DISPLAY_NAME": "Wand",
            "ASSET_GIT_REPO": "git@github.com:YOUR_ACCOUNT/assets.git",
            "APP_STORE_APP_ID": "Encrypted(...)"
        }
    }
}' \
https://api.codemagic.io/builds