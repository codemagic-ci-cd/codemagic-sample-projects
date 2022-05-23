# unity deploy to steam demo project

## Prerequisites

- A Unity **Plus** or **Pro** license. Your license is used to activate Unity on the Codemagic build server so the project can be built. The license is returned automatically once the workflow completes.
- A Steam Partner account is required to publish to Steam.

## Getting Started

The **codemagic.yaml** in this project can be used as a starter template for building and publishing your Unity PC application to Steam with Codemagic CI/CD.

The template is for a Windows 64 bit application and uses steamcmd to upload the build to Steam.

The following environment variables must be defined:
```
    UNITY_SERIAL
	UNITY_USERNAME
	UNITY_PASSWORD
	STEAM_USERNAME
	STEAM_PASSWORD   
```

steamcmd is the tool used to upload builds to Steam. Steamcmd requires logging into Steam and will normally require a Steam Guard code be entered.
To solve this problem, there are two options.

Option #1: Disable Steam Guard for the account doing the Steam upload.  This is not recommended, as it makes the Steam account less secure.

Option #2: Use sentry files that are generated after logging in successfully to Steam on the build machine. When these sentry files are present on the build machine, a Steam Guard code is not required.

To obtain the sentry files, see the "Explore build machine via SSH or VNC client" stage when making a build.  Once access is obtained, install steamcmd with:

```
	mkdir Steam
	curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_osx.tar.gz" | tar zxvf - -C Steam
```

Then log into Steam with the following, which will prompt for the Steam Guard code:
```
	Steam/steamcmd.sh +login <steam username> <steam password>
```

After entering the Steam Guard code and successfully logging into Steam, you will need to copy two files to your local machine using scp.  Issue the following commands from your local machine:
```
	scp -P <port> builder@X.X.X.X ~/Library/Application\ Support/ssfn******************* .
	scp -P <port> builder@X.X.X.X ~/Library/Application\ Support/config/config.vdf .
```

Once the ssfn and config.vdf files are obtained, they must be included in your depot so they can be copied onto the build machine is subsequent builds using:
```
	- name: Copy Sentry Files
       script: |
          #mkdir ~/Library/Application\ Support/Steam
          #cp ~/clone/steam/ssfn******************* ~/Library/Application\ Support/Steam
          #mkdir ~/Library/Application\ Support/Steam/config
          #cp ~/clone/steam/config.vdf ~/Library/Application\ Support/Steam/config        
```

Note the mkdir and cp commands are commented out in the template. Remove the leading # on each line to enable the copying.
This demo project stores the sentry files in the steam folder under the root of the project.

To configure the upload to Steam, edit the following two files in the demo project:
```
	steam/app_build.vdf
	steam/depot_build.vdf
```

These are standard VDF files required for uploading a build to Steam and require your application's AppID, DepotID and branch name for deployment.

## Getting help and support

Click the URL below to join the Codemagic Slack Community:

https://slack.codemagic.io/

Customers who have enabled billing can use the in-app chat widget to get support.

Need a business plan with 3 Mac Pro concurrencies, unlimited build minutes, unlimited team seats and business priorty support? Click [here](https://codemagic.io/pricing/) for details.



