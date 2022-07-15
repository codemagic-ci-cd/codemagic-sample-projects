# unity deploy to steam demo project

## Prerequisites

- A Unity **Plus** or **Pro** license. Your license is used to activate Unity on the Codemagic build server so the project can be built. The license is returned automatically once the workflow completes.
- A Steam Partner account is required to publish to Steam.

## Getting Started

The **codemagic.yaml** in this project can be used as a starter template for building and publishing your Unity PC application to Steam with Codemagic CI/CD.

The template is for a Windows 64 bit application and uses SteamCMD to upload the build to Steam.

The following environment variables must be defined:
```
   UNITY_SERIAL
   UNITY_EMAIL
   UNITY_PASSWORD
   STEAM_USERNAME
   STEAM_PASSWORD
   CONFIG_FILE
   SSFN_FILE
   SSFN_FILE_NAME   
```

SteamCMD is the tool used to upload builds to Steam. SteamCMD requires logging into Steam and will normally require a Steam Guard code be entered.
To solve this problem, there are two options.

Option #1: Disable Steam Guard for the account doing the Steam upload.  This is not recommended, as it makes the Steam account less secure.

Option #2: Use sentry files that are generated after logging in successfully to Steam on the build machine. When these sentry files are present on the build machine, a Steam Guard code is not required.
So we are going to save the sentry files as secure environment variables and then place them at the correct path when the build starts.

To obtain the sentry files:
First you need to install the SteamCMD.

```
   mkdir ~/Steam
   curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_osx.tar.gz" | tar zxvf - -C ~/Steam
```

Then log in to Steam with the following, which will prompt for the Steam Guard code:
```
   ~/Steam/steamcmd.sh +login steam $STEAM_USERNAME $STEAM_PASSWORD
```
You now can see the **ssfn** file in `~/Steam/ssfn*******************` and the **config.vdf** file at `~/Steam/config/config.vdf`.

- Save the ssfn file name, ssfn file itself, and the config file to the respective environment variables in the **Environment variables** section in Codemagic UI, so they can be used in subsequent builds.
- If you don't want to install the SteamCMD on your local machine to obtain the sentry files, you can use Codemagic machines to do so and then copy them into your local machine using the secure copy command `scp`.
```shell
   scp -P <port> builder@X.X.X.X ~/Library/Application\ Support/ssfn******************* .
   scp -P <port> builder@X.X.X.X ~/Library/Application\ Support/config/config.vdf .
```

In your workflow you need to base64 decode these files:
```yaml
      - name: Decode Sentry files
        script: |
          echo $CONFIG_FILE | base64 --decode > steam/config.vdf
          echo $SSFN_FILE | base64 --decode > steam/$SSFN_FILE_NAME
```
And then copy them to the correct path:
```yaml
      - name: Copy Sentry Files
        script: |
          mkdir -p ~/Library/Application\ Support/Steam/config
          cp ~/clone/steam/$SSFN_FILE_NAME ~/Library/Application\ Support/Steam
          cp ~/clone/steam/config.vdf ~/Library/Application\ Support/Steam/config
```
To configure the upload to Steam, edit the following two files in the demo project:
```
   steam/app_build.vdf
   steam/depot_build.vdf
```

These are standard VDF files required for uploading a build to Steam and require your application's AppID, DepotID and branch name for deployment.
And then use the script to publish your app to steam:
```yaml
      - name: Upload Build to Steam
        script: | 
          ~/Steam/steamcmd.sh +login $STEAM_USERNAME $STEAM_PASSWORD +run_app_build ~/clone/steam/app_build.vdf +quit
```


## Getting help and support

Ream the full documentation in [here](https://docs.codemagic.io/yaml-publishing/steam/).

Click [here](https://slack.codemagic.io/) to join the Codemagic Slack Community:

Customers who have enabled billing can use the in-app chat widget to get support.

Need a business plan with 3 Mac Pro concurrencies, unlimited build minutes, unlimited team seats and business priorty support? Click [here](https://codemagic.io/pricing/) for details.