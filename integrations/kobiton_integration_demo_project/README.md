# kobiton integration with codemagic

## Getting Started

**Kobiton** is a mobile testing platform that accelerates delivery and testing of mobile apps by offering manual and automated testing on real devices, in the cloud & on-premises.


**Step 1**: App Url and appPath need to created to upload binaries to AWS S3 bucket by running the following cURL script:

```
CURL_RESULT=$(curl -X POST https://api.kobiton.com/v1/apps/uploadUrl \
-H 'Authorization: Basic $KOBITON_CREDENTIALS) \
-H 'Content-Type: application/json' \
-d '{"filename": "your_desired_binary_name.ipa"}' | jq -r)

APP_URL=$(jq -r '.url' <<<"$CURL_RESULT")
APP_PATH=$(jq -r '.appPath' <<<"$CURL_RESULT") 
```

**Step 2**: Upload to S3:

```
curl -X PUT “$APP_URL” \
-H 'content-type: application/octet-stream' \
-H 'x-amz-tagging: unsaved=true' \
-T "build/ios/ipa/kobition_integration.ipa"
```

**Step 3**: Upload to the Kobiton environment:

```
curl -X POST https://api.kobiton.com/v1/apps \
-H 'Authorization:  Basic $KOBITON_CREDENTIALS' \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-d '{"appPath": “’”$APP_PATH”’”}’
```

**$KOBITON_CREDENTIALS** environment variable is a custom name and can be named to anything preferred. More info can be found [here](https://docs.codemagic.io/variables/environment-variable-groups/) about how to set up environment variable groups with Codemagic.

After a successful upload, you should get appId and versionId in the Codemagic logs. After the whole process, check your App section in the Kobiton UI and you should see your uploaded binary there.