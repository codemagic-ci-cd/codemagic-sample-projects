import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'io.ionic.starter',
  appName: 'capgo_integration_demo_project',
  webDir: 'build',
  bundledWebRuntime: false,
  "plugins": {
    "CapacitorUpdater": {
        "autoUpdate": true
    }
  }
};

export default config;
