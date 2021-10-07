# Jira Integration Demo Project (YAML build configuration)

## Jira Integration starter template 

The **codemagic.yaml** in this project can be used as a starter template for integrating your workflow with Jira when building your apps with Codemagic CI/CD.

This example contains a workflow based around an iOS build but the Jira integration script can be used with any mobile app build such as Flutter, Native Android, or React Native.

It shows how to use the Jira API in a script that allows you to add formatted comments to a Jira issue with links to your build artefacts e.g the .ipa or .apk, add attachments such as release notes and test results, and how to transition the status of a Jira issue.

There are links to the Codemagic documentation for additional information about code signing and publishing.

Documentation for YAML builds can be found at the following URL: 

https://docs.codemagic.io/getting-started/yaml/

## Storing Environment Variables

Add the group environment variables in Codemagic UI (either in Application/Team variables). Entering values in the Variable value input and marking the Secure checkbox will automatically encrypt those values.

The generated group name must be used in the yaml file under environment section. 
Secure marked environment variables can only be accessed on the Codemagic build servers.

Please note that values are specific to your personal account or team. 

If you move your app from personal account to a Team or vice versa you may need to re-secure these values.

## How to Build your iOS app using the codemagic.yaml

<ol>
<li>Add a copy of the codemagic.yaml to the root of the repository branch you want to build</li>
<li>Copy the .templates folder which contains the jira.json template file to the root of your repository</li>
<li>Update the values in codemagic.yaml file in the indicated places. Use the documentation links for help if required.</li>
<li>Login to your Codemagic account at https://codemagic.io/login</li>
<li>Add the repository for your iOS application in the Codemagic web app</li>
<li>Click the 'Set up build' button on the respository</li>
<li>In the Continuous Integration Workflows section choose the 'iOS' workflow</li>
<li>At the top of the screen select the branch you added the codemagic.yaml to and click the 'Check for configuration file' button</li>
<li>Click on the 'Start your first build' button that is displayed when the configuration file is detected</li>
<li>Select the workflow you would like to build and click the 'Start new build' button</li>
</ol>

## Notes about the Jira integration script

### Jira account and API token 
The script uses curl requests to call the Jira API. 

You will need a Jira account and and API token which can be created at the following URL: 

https://id.atlassian.com/manage-profile/security/api-tokens

### Authorization header
The script adds your authentication credentials using an Authorization: Basic <credentials> header. The credential are provided as a base64 encoded string consisting of the following: 

email_used_with_jira:api_token

You can encode these credentials in the macOS Terminal using:

echo -n 'email:token' | openssl base64

Alternatively use an online tool to encode this string.

### Atalassian Document Format for comments

A JSON payload is used to add comments to a Jira issue, epic, or story. The Atlassasion Document Format (ADF) is used to format the comment layout and style. This example uses a .json template located in .templates/jira.json and string substition to replace values in the template using sed. See the following URL for details on how to structure comments using Atlassion Document Format:

https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/


## Automatic build triggers

To configure automatic build triggering on commit, tag, or pull request please refer to the following documentation:

https://docs.codemagic.io/getting-started/yaml/#triggering

## Getting help and support

Click the URL below to join the Codemagic Slack Community:

https://slack.codemagic.io/

Customers who have enabled billing can use the in-app chat widget to get support. 
