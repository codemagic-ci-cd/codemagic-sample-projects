# Capawesome Cloud Integration with Codemagic

[Capawesome Cloud](https://capawesome.io/cloud/) is a powerful platform that provides a suite of tools to help you deploy [Live Updates](https://capawesome.io/blog/announcing-the-capacitor-live-update-plugin/) to your [Capacitor](https://capacitorjs.com/) apps after they have been published to the App Store or Google Play.

## Configure access to Capawesome Cloud

Follow these steps to configure access to Capawesome Cloud:

1. Sign up with [Capawesome Cloud](https://cloud.capawesome.io) and generate a new token via the [Settings](https://cloud.capawesome.io/settings/tokens) page
2. Open your Codemagic app settings, and go to the **Environment variables** tab.
3. Enter the desired **_Variable name_**, e.g. `CAPAWESOME_TOKEN`.
4. Copy and paste the Capawesome Cloud token string as **_Variable value_**.
5. Enter the variable group name, e.g. **_capawesome_credentials_**. Click the button to create the group.
6. Make sure the **Secure** option is selected.
7. Click the **Add** button to add the variable.
8. Add the variable group to your `codemagic.yaml` file

{{< highlight yaml "style=paraiso-dark">}}
  environment:
    groups:
      - capawesome_credentials
{{< /highlight >}}

## Install the Capawesome Cloud CLI

In order to deploy live updates to Capawesome Cloud, you need to install the Capawesome Cloud CLI:

{{< highlight yaml "style=paraiso-dark">}}
  scripts:
    - name: Install Capawesome Cloud CLI
      script: | 
        npm install @capawesome/cli
{{< /highlight >}}

After that, you need to log in to Capawesome Cloud using the token you generated:

{{< highlight yaml "style=paraiso-dark">}}
  scripts:
    - name: Log in to Capawesome Cloud
      script: | 
        npx capawesome login --token $CAPAWESOME_TOKEN
{{< /highlight >}}

## Deploy a Live Update to Capawesome Cloud

Now you can deploy a live update to Capawesome Cloud:

{{< highlight yaml "style=paraiso-dark">}}
  scripts:
    - name: Deploy to Capawesome Cloud
      script: | 
        npx capawesome apps:bundles:create --appId <app-id> --path <path-to-bundle>
{{< /highlight >}}

Make sure to replace `<app-id>` with the ID of your app on Capawesome Cloud and `<path-to-bundle>` with the path to the bundle you want to upload (e.g. `www`).

We recommend that you also specify a [Channel](https://capawesome.io/cloud/live-updates/channels/) when uploading the bundle:

{{< highlight yaml "style=paraiso-dark">}}
  scripts:
    - name: Deploy to Capawesome Cloud
      script: | 
        npx capawesome apps:bundles:create --appId <app-id> --path <path-to-bundle> --channel <channel-name>
{{< /highlight >}}

This way you can easily restrict live updates to specific versions of your app and prevent incompatible updates.

The Capawesome Cloud CLI then automatically creates a zip archive of the bundle and uploads it to the Capawesome Cloud where it becomes immediately available for download.
