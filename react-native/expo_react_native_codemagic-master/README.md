

[**Expo**](https://docs.expo.dev/) is a framework and a platform for universal React applications. It is a set of tools and services built around React Native and native platforms that help you develop, build, deploy, and quickly iterate on iOS, Android, and web apps from the same JavaScript/TypeScript codebase.



In order to have the respective directories you need to iOS and Adnroid, you need to run **expo eject** in the root of your project.




To perform an over-the-air update of your app, you simply run expo publish. If you're using release channels, specify one with --release-channel <channel-name> option. Please note- if you wish to update the SDK version of your app, or make any of the these changes, you'll need to rebuild your app with expo build:* command and upload the binary file to the appropriate app store (see the docs here). More info about OTA updates is [here](https://docs.expo.dev/guides/configuring-ota-updates/)
            
            
OTA updates are controlled by the updates settings in app.json, which handle the initial app load, and the Updates SDK module, which allows you to fetch updates asynchronously from your JS. In order to do that you can include the following scripts into your **codemagic.yaml** file:
```
            - name: Expo 
              script: |
                  npx expo-cli login -u $USERNAME -p $PASSWORD
                  npx expo-cli publish --non-interactive --max-workers 1 --release-channel $EXPO_RELEASE_CHANNEL
    
```

            
            
Environement variables can be created easily by generating groups. More info about it can be found [here](https://docs.codemagic.io/variables/environment-variable-groups/)
