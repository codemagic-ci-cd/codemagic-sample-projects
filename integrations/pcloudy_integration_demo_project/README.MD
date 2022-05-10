# pCloudy integration with Codemagic

[pCloudy](https://www.pcloudy.com/) is a mobile application testing platform on cloud for "next-gen" app testing. 

It is possible to test your apps on actual devices provided by **pCloudy** via **Codemagic**. In order to achieve it, you need to go through the following steps:

1. Sign up with pCloudy
2. Get your API Token from your pCloudy settings
3. Start building your artifacts with Codemagic and upload them to the pCloudy environment

In order to achive the above-mentioned steps, you need use the curl commands below after generating the respective artifacts:

```
 - name: pCloudy upload
   script: |      
    APP_URL=$(curl -u "$PCLOUDY_USERNAME:$PCLOUDY_API_TOKEN" https://device.pcloudy.com/api/access | jq -r '.[].token')             
    curl -X POST -F "file=@android/app/build/outputs/apk/release/app-release.apk" -F "source_type=raw" -F "token=$APP_URL" -F "filter=all" https://device.pcloudy.com/api/upload_file
```

After that, you can find a success message in the Codemagic logs and uploaded artefacts in the pCloudy dashboard. 

**$PCLOUDY_USERNAME** and **$PCLOUDY_API_TOKEN** are generated to you automatically after signing up with **PCLOUDY** and setting up the environment variables in the Codemagic UI will allow them to be used during a build.