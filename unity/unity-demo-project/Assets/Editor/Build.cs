using System.Linq;
using UnityEditor;
using UnityEngine;
using System;

public static class BuildScript
{

    [MenuItem("Build/Build All")]
    public static void BuildAll()
    {
        BuildAndroid();
        BuildXcode();
    }

    

    [MenuItem("Build/Build Android")]
    public static void BuildAndroid()
    {
        
        PlayerSettings.Android.useCustomKeystore = true;

        // Set bundle version
        var versionIsSet = int.TryParse(Environment.GetEnvironmentVariable("NEW_BUILD_NUMBER"), out int version);
        if (versionIsSet)
        {
            Debug.Log($"Bundle version code set to {version}");
            PlayerSettings.Android.bundleVersionCode = version;
        }
        else
        {
            Debug.Log("Bundle version not provided");
        }

        // Set keystore name
        string keystoreName = Environment.GetEnvironmentVariable("FCI_KEYSTORE_PATH");
        if (!String.IsNullOrEmpty(keystoreName))
        {
            Debug.Log($"Setting path to keystore: {keystoreName}");
            PlayerSettings.Android.keystoreName = keystoreName;
        }
        else
        {
            Debug.Log("Keystore name not provided");
        }

        // Set keystore password
        string keystorePass = Environment.GetEnvironmentVariable("FCI_KEYSTORE_PASSWORD");
        if (!String.IsNullOrEmpty(keystorePass))
        {
            Debug.Log("Setting keystore password");
            PlayerSettings.Android.keystorePass = keystorePass;
        }
        else
        {
            Debug.Log("Keystore password not provided");
        }

        // Set keystore alias name
        string keyaliasName = Environment.GetEnvironmentVariable("FCI_KEY_ALIAS_USERNAME");
        if (!String.IsNullOrEmpty(keyaliasName))
        {
            Debug.Log("Setting keystore alias");
            PlayerSettings.Android.keyaliasName = keyaliasName;
        }
        else
        {
            Debug.Log("Keystore alias not provided");
        }

        // Set keystore password
        string keyaliasPass = Environment.GetEnvironmentVariable("FCI_KEY_ALIAS_PASSWORD");
        if (!String.IsNullOrEmpty(keyaliasPass))
        {
            Debug.Log("Setting keystore alias password");
            PlayerSettings.Android.keyaliasPass = keyaliasPass;
        }
        else
        {
            Debug.Log("Keystore alias password not provided");
        }

        BuildPlayerOptions buildPlayerOptions = new BuildPlayerOptions();
        buildPlayerOptions.locationPathName = "android/android.aab";
        buildPlayerOptions.target = BuildTarget.Android;
        buildPlayerOptions.options = BuildOptions.None;
        buildPlayerOptions.scenes = GetScenes();

        Debug.Log("Building Android");
        BuildPipeline.BuildPlayer(buildPlayerOptions);
        Debug.Log("Built Android");
    }

    [MenuItem("Build/Build Xcode")]
    public static void BuildXcode()
    {
        BuildPlayerOptions buildPlayerOptions = new BuildPlayerOptions();
        buildPlayerOptions.locationPathName = "ios";
        buildPlayerOptions.target = BuildTarget.iOS;
        buildPlayerOptions.options = BuildOptions.None;
        buildPlayerOptions.scenes = GetScenes();

        Debug.Log("Building iOS");
        BuildPipeline.BuildPlayer(buildPlayerOptions);
        Debug.Log("Built iOS");
    }



    private static string[] GetScenes()
    {
        return (from scene in EditorBuildSettings.scenes where scene.enabled select scene.path).ToArray();
    }

}