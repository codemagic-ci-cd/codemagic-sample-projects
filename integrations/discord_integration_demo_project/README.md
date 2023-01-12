# Discord Integration sample Project (YAML build configuration)

The codemagic.yaml in the root of this project contains an example of how to post messages to Discord with details of your Codemagic CI/CD builds. 

This example contains a workflow based around an Android Flutter build but the integration script can be used with any mobile app build such as Native iOS, Native Android, or React Native.


## Create a Server and channel in Discord

A Server is a dedicated space for your community. A server is required for you to create text channels to talk with people you invite to the server. 

1. Log into Discord [here](https://discord.com/login)
2. Click on the **+** button on the left hand menu to create a Server and give it a name and click the **Create** button. 
3. Click on the **+** button next to Text Channels. Make sure the channel type is set to **Text channel** and give your channel a name e.g. `codemagic-builds` and then click **Create channel**.
4. Once the channel has been created, click on the channel name to highlight it and then click on the channel's settings icon.
5. Click on **Integrations** and then click **Create webhook** and change the name if you want.
6. Click the **Copy webhook URL**

## Configuring access to Discord in Codemagic

One **environment variable**  needs to be added to your workflow for the Discord integration: `WEBHOOK_URL` which is the webhook URL you created in the steps above.

1. Open your Codemagic app settings, and go to the **Environment variables** tab.
2. Enter the desired **_Variable name_**, e.g. `WEBHOOK_URL`.
3. Enter the required value as **_Variable value_**.
4. Enter the variable group name, e.g. **_discord_credentials_**. Click the button to create the group.
5. Make sure the **Secure** option is selected.
6. Click the **Add** button to add the variable.

7. Add the variable group to your `codemagic.yaml` file
``` yaml
  environment:
    groups:
      - discord_credentials
```

## Post a message to Discord 

A cURL request can be used to send a message to your Discord channel with information anout your Codemagic builds. 

The following is an example of how to perform a cURL request that uses your Discord webhook to send a message with a commit number, commit message, branch name, Git commit author and a link to the build artifact. It also adds a file attachment that contains the Git changelog. 


``` bash
curl -H "Content-Type: multipart/form-data" \
     -F 'payload_json={"username" : "codemagic-builds", "content": "**Commit:** `'"$COMMIT"'`\n\n**Commit message:** '"$COMMIT_MESSAGE"'\n\n**Branch:** '"$FCI_BRANCH"'\n\n**Author:** '"$AUTHOR"'\n\n**Artifacts: **\n\n'"$APP_LINK"'\n\n"}' \
     -F "file1=@release_notes.txt" \
     $WEBHOOK_URL
```

![Discord message](./discord-message.png?raw=true "Discord")

Please refer to the `codemagic.yaml` in the root of this project for the full example.

### Environment variables in JSON

If you want to use an environment variable within your message use single quotes and double quotes within the JSON value as follows (note that the addtional backticks will format it as code in Discord):

``` bash
  "content": "**Commit:** `'"$COMMIT"'`"
```
