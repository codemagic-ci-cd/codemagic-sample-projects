While building a Cordova project, you may come across an error on uploading your .apk as follows: 

` You uploaded an APK that is not zip-aligned error `

- In this case you can make the following changes in the build step:
```
      - name: Build Android
        script: |
          set -x
          set -e
          cordova build android --release --no-interactive --prod --device
          echo $KEYSTORE | base64 --decode > $KEYSTORE_PATH
          UNSIGNED_APK_PATH=$(find platforms/android/app/build/outputs -name "*.apk" | head -1)
          jarsigner -sigalg SHA1withRSA -digestalg SHA1 -keystore "${KEYSTORE_PATH}" -storepass "${KEYSTORE_PASSWORD}" -keypass "${KEY_ALIAS_PASSWORD}" "${UNSIGNED_APK_PATH}" "${KEY_ALIAS}"
          zipalign -v 4 $UNSIGNED_APK_PATH app-release.apk
          mv $UNSIGNED_APK_PATH $(echo $UNSIGNED_APK_PATH | sed 's/-unsigned//')
```

- If you require an `apksigner` instead of `jarsigner`, then use the below code block:

```
      - name: Build Android
        script: |
          set -x
          set -e
          cordova build android --release --no-interactive --prod --device
          echo $KEYSTORE | base64 --decode > $KEYSTORE_PATH
          UNSIGNED_UNALIGNED_APK_PATH=$(find platforms/android/app/build/outputs -name "*.apk" | head -1)
          UNSIGNED_APK_PATH=$(echo $UNSIGNED_UNALIGNED_APK_PATH | sed 's/-unsigned/-unsigned-aligned/')
          SIGNED_APK_PATH=$(echo $UNSIGNED_APK_PATH | sed 's/-unsigned-aligned//')
          zipalign -v -p 4 $UNSIGNED_UNALIGNED_APK_PATH $UNSIGNED_APK_PATH
          apksigner sign --ks $KEYSTORE_PATH --ks-pass pass:$KEYSTORE_PASSWORD --ks-key-alias $KEY_ALIAS --key-pass pass:$KEYSTORE_PASSWORD --in $UNSIGNED_APK_PATH --out $SIGNED_APK_PATH
          rm -rf $UNSIGNED_UNALIGNED_APK_PATH
          rm -rf $UNSIGNED_APK_PATH
```
