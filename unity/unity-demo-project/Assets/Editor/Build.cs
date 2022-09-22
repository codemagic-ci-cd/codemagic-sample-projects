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
        BuildIos();
        BuildWindows();
        BuildMac();
    }

    

    [MenuItem("Build/Build Android")]
    public static void BuildAndroid()
    {
        
        PlayerSettings.Android.useCustomKeystore = true;
        EditorUserBuildSettings.buildAppBundle = true;

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
        string keystoreName = Environment.GetEnvironmentVariable("CM_KEYSTORE_PATH");
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
        string keystorePass = Environment.GetEnvironmentVariable("CM_KEYSTORE_PASSWORD");
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
        string keyaliasName = Environment.GetEnvironmentVariable("CM_KEY_ALIAS");
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
        string keyaliasPass = Environment.GetEnvironmentVariable("CM_KEY_PASSWORD");
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
        buildPlayerOptions.locationPathName = "android/" + Application.productName + ".aab";
        buildPlayerOptions.target = BuildTarget.Android;
        buildPlayerOptions.options = BuildOptions.None;
        buildPlayerOptions.scenes = GetScenes();

        Debug.Log("Building Android");
        BuildPipeline.BuildPlayer(buildPlayerOptions);
        Debug.Log("Built Android");
    }

    [MenuItem("Build/Build iOS")]
    public static void BuildIos()
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

    [MenuItem("Build/Build Windows")]
    public static void BuildWindows()
    {
        BuildPlayerOptions buildPlayerOptions = new BuildPlayerOptions();
        buildPlayerOptions.locationPathName = "windows/" + Application.productName + ".exe";
        buildPlayerOptions.target = BuildTarget.StandaloneWindows64;
        buildPlayerOptions.options = BuildOptions.None;
        buildPlayerOptions.scenes = GetScenes();

        Debug.Log("Building StandaloneWindows64");
        BuildPipeline.BuildPlayer(buildPlayerOptions);
        Debug.Log("Built StandaloneWindows64");
    }

    [MenuItem("Build/Build Mac")]
    public static void BuildMac()
    {
        BuildPlayerOptions buildPlayerOptions = new BuildPlayerOptions();
        buildPlayerOptions.locationPathName = "mac/" + Application.productName + ".app";
        buildPlayerOptions.target = BuildTarget.StandaloneOSX;
        buildPlayerOptions.options = BuildOptions.None;
        buildPlayerOptions.scenes = GetScenes();

        Debug.Log("Building StandaloneOSX");
        BuildPipeline.BuildPlayer(buildPlayerOptions);
        Debug.Log("Built StandaloneOSX");
    }


    private static string[] GetScenes()
    {
        return (from scene in EditorBuildSettings.scenes where scene.enabled select scene.path).ToArray();
    }

}