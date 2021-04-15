# React Native Demo Project (YAML build configuration)

## React Native starter template 

The **codemagic.yaml** in this React Native project can be used as a starter template for building your apps with Codemagic CI/CD.

This example contains two workflows. 
<ul>
<li>The first is for building and publishing an Android App to Google Play.</li>
<li>The second workflow shows how to build and publish an IOS app to the App Store using Codemagic's open source CLI tools for automatic code signing.</li>
</ul>

There are links to the Codemagic documentation for additional information about code signing and publishing.

Documentation for YAML builds can be found at the following URL: 

https://docs.codemagic.io/getting-started/yaml/

## Encrypted Environment Variables

Use the Codemagic web app to securely encrypt environment variables that are included in the codemagic.yaml. These values can only be accessed on the Codemagic build servers.

Please note that encrypted values are specific to your personal account or team. If you move your app from personal account to a Team or vice versa you will need to re-encrypt these values.

## How to Build your React Native app using the codemagic.yaml

<ol>
<li>Add a copy of the codemagic.yaml to the root of the repository branch you want to build</li>
<li>Update the values in codemagic.yaml file in the indicated places. Use the documentation links for help if required.</li>
<li>Login to your Codemagic account at https://codemagic.io/login</li>
<li>Add the repository for your React Native application in the Codemagic web app</li>
<li>Click the 'Set up build' button on the respository</li>
<li>In the Continuous Integration Workflows section choose the 'React Native App' workflow</li>
<li>At the top of the screen select the branch you added the codemagic.yaml to and click the 'Check for configuration file' button</li>
<li>Click on the 'Start your first build' button that is displayed when the configuration file is detected</li>
<li>Select the workflow you would like to build and clikc the 'Start new build' button</li>
</ol>

To configure automatic build triggering on commit, tag, or pull request please refer to the following documentation:

https://docs.codemagic.io/getting-started/yaml/#triggering

## Getting help and support

Click the URL below to join the Codemagic Slack Community:

https://slack.codemagic.io/

Customers who have enabled billing can use the in-app chat widget to get support. 










