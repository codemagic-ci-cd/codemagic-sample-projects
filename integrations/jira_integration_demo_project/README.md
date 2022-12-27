# Jira Integration Sample Project
## Jira Integration starter template 

The **codemagic.yaml** in this project can be used as a starter template for integrating your workflow with Jira when building your apps with Codemagic CI/CD.

This example contains a workflow based around an iOS build but the Jira integration script can be used with any mobile app build such as Flutter, Native Android, or React Native.

It shows how to use the Jira API in a script that allows you to add formatted comments to a Jira issue with links to your build artefacts e.g the .ipa or .apk, add attachments such as release notes and test results, and how to transition the status of a Jira issue.

## Configure environment variables

To get started, you will need a Jira account (you can [sign up](https://www.atlassian.com/software/jira) for free) and a [Jira API Token](https://id.atlassian.com/manage-profile/security/api-tokens).


There are four **environment variables** that need to be configured for the Jira integration: `JIRA_AUTH`, `JIRA_BASE_URL`, `JIRA_ISSUE` and `JIRA_TRANSITION_ID`. To add a variable, follow these steps:

1. Open your Codemagic app settings, and go to the **Environment variables** tab.
2. Enter the desired **_Variable name_**, e.g. `JIRA_AUTH`.
3. Enter the required value as **_Variable value_**.
4. Enter the variable group name, e.g. **_jira_credentials_**. Click the button to create the group.
5. Make sure the **Secure** option is selected.
6. Click the **Add** button to add the variable.
7. Repeat the process to add all of the required variables.

#### JIRA_AUTH environment variable

The `JIRA_AUTH` environment variable is a `base64` encoded string which consists of the email address you log into Jira with and the Jira API token you created: 

`email@example.com:<api_token>`

You can encode these credentials in the **macOS Terminal** using:

{{< highlight bash "style=paraiso-dark">}}
echo -n 'email@example.com:<api_token>' | openssl base64
{{< /highlight >}}

Alternatively, use an online tool to base64 encode this string. 

This value is used in the Authorization header used in cURL requests to the Jira API.

#### JIRA_BASE_URL environment variable

This is the subdomain you chose when you set up your Jira account e.g. "YOUR_SUBDOMAIN.atlassian.net". Put the subdomain including "atalassian.net" in the `JIRA_BASE_URL` environment variable. 


#### JIRA_ISSUE environment variable

Issues, epics, and stories have a unique id, usually in the format **'projectKey-id'**, and is visible on your issues either in the bottom right or top left when looking at an issue. Put this value in the `JIRA_ISSUE` environment variable. 

#### JIRA_TRANSITION_ID environment variable

If you want to transition your issue to another status, you will need to know what transition ids are available. You can obtain the available transition ids using a cURL request as documented in the [Jira API documentation](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/#api-rest-api-3-issue-issueidorkey-transitions-get). Once you know the transition id then put this value in the `JIRA_TRANSITION_ID` environment variable.

## Adding formatted comments to a Jira issue

Create a **.templates** folder in the root of your project. In this folder, create a template file called **jira.json**, which adds formatted comments to a Jira issue. An example **jira.json** file can be found in our [Sample project](https://github.com/codemagic-ci-cd/codemagic-sample-projects/blob/main/integrations/jira_integration_demo_project/.templates/jira.json).

The Atlassian Document Format (ADF) is used to format the comment layout and style. Click [here](https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/) for more information about ADF and how to modify this template. 

![A formatted Jira issue comment](https://docs.codemagic.io/uploads/jira_issue_comment.png)

**Note** that it contains strings beginning with `$`, which the scripts use to replace values in the JSON using `sed` before it is added as JSON payload to the `cURL` requests.


## Publishing to Jira

Publishing to Jira is performed by a script in the `publishing:` section in the `codemagic.yaml`. The example script shown below contains several actions which set environment variables, update the comment template, and then use cURL requests to add a comment and upload files to a specific Jira issue.

### Using jq to parse $CM_ARTIFACT_LINKS

First, it uses **jq** (a command-line tool for parsing JSON) to parse the contents of the Codemagic built-in environment variable `$CM_ARTIFACT_LINKS` to find information such as the articact URL, filename, bundle id, and version name and store the values in environment variables.

See this link about the JSON data that [$CM_ARTIFACT_LINKS](../yaml-basic-configuration/environment-variables#artifact-links) contains.

### Setting additional environment variables

Additional environment variables are then set, such as the build number, build date, and commit number. These environment variables are used to replace values in the **jira.json** comment template using **sed**, a stream editor for parsing and transforming text.

### Making cURL requests to the Jira API 

1. The script performs a request to add a comment to the Jira issue specified using the jira.json as the payload.
2. Another request is used to transition the issue to a different status.
3. The script checks to see if XML test results have been generated. See [here](../testing-yaml/testing/) for information about using `test_report` to generate a test report .xml output. If **xml test results** are available, then they will be uploaded to the Jira issue.
4. If **release notes** have been created, then these are uploaded to the Jira issue.
