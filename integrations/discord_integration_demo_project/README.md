# Discord Integration Demo Project (YAML build configuration)

The codemagic.yaml in the root of this project contains an example of how to post messages to Discord with details of your Codemagic CI/CD builds. 

This example contains a workflow based around an Android Flutter build but the integration script can be used with any mobile app build such as Native iOS, Native Android, or React Native.

Documentation for YAML builds can be found at the following URL:

https://docs.codemagic.io/getting-started/yaml/

## Create a Discord Webhook

<ol>
<li>Open your channel in Discord and open its settings</li>
<li>Click on 'integrations'</li>
<li>Click 'Create webhook' buttonif this your first webhook, or click the 'View webhooks' if you have already configure a webhook on this channel</li>
<li>Rename the webhook if desired</li>
<li>Click on the 'Copy webhook URL</li>
</ol>


## Environment variables

<ol>
<li>Create an environment variable called 'WEBHOOK_URL' in the Codemagic web app on the 'Environment variables' tab.</li>
<li>Paste in the webook URL you copied in the previous step and create a groupd called 'discord'.</li>
<li>Check the 'Secure' checkbox</li> 
<li>Click the 'Add' button</li>
</li>Import the variable into your codemagic.yaml as shown below</li>
</ol>

```yaml
workflows:
  workflow-name:
    environment:
      groups:
        - discord
```

## Post a message to Discord 

A cURL request can be used to send a message to your Discord channel with information anout your Codemagic builds. 

The following is an example of how to perform a cURL request that uses your Discord webhook to send a message with a commit number, commit message, branch name, Git commit author and a link to the build artifact. It also adds a file attachment that contains the Git changelog. 


```
curl -H "Content-Type: multipart/form-data" \
  -F 'payload_json={"username" : "codemagic-builds", "content": "**Commit:** `'"$COMMIT"'`\n\n**Commit message:** '"$COMMIT_MESSAGE"'\n\n**Branch:** '"$FCI_BRANCH"'\n\n**Author:** '"$AUTHOR"'\n\n**Artifacts: **\n\n'"$APP_LINK"'\n\n"}' \
  -F "file1=@release_notes.txt" \
  $WEBHOOK_URL
```

![Discord message](./discord-message.png?raw=true "Discord")

Please refer to the `codemagic.yaml` in the root of this project for the full example.

### Environment variables in JSON

If you want to use an environment variable within your message use single quotes and double quotes within the JSON value as follows (note that the addtional backticks will format it as code in Discord):

```
  "content": "**Commit:** `'"$COMMIT"'`"
```
