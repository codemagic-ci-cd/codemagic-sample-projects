# Capgo Integration with Codemagic



## Getting Started

[Capgo](https://capgo.app/) is an instant updater for Capacitor apps and it is possible to integrate it with **Codemagic**

In order to get live updates in your Capgo account via Codemagic, you will need to follow the steps:

1. Sign up with Capgo to get your login token
2. Add the foolowing part in your **capacitor.config.json**
```
"plugins": {
        "CapacitorUpdater": {
            "autoUpdate": true
        }
```
3. Inside your main app source, import the following package:
```
import { CapacitorUpdater } from '@capgo/capacitor-updater'

CapacitorUpdater.notifyAppReady()
```
4. Install **capacitor-updater** by running the following commands in your **codemagic.yaml**
```
    - name: Install npm dependencies for Ionic project
      script: |
        npm install @capgo/capacitor-updater
        npx @capgo/cli login $CAPGO_TOKEN
```
**$CAPGO_TOKEN** is your login token and can be found under your Capgo account.

5. Run **npx cap sync**:
```
    - name: Update dependencies and copy web assets to native project
      script: |
        npx cap sync
```

6. Upload your project to Capgo:
```
    - name: Capgo
      script: |
        npx @capgo/cli add 
        npx @capgo/cli upload
```


## Getting help and support 

Click the URL below to join the Codemagic Slack Community:

https://slack.codemagic.io/

Customers who have enabled billing can use the in-app chat widget to get support.

Need a business plan with 3 Mac Pro concurrencies, unlimited build minutes, unlimited team seats and business priorty support? Click [here](https://codemagic.io/pricing/) for details.
