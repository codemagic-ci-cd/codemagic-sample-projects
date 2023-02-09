# Flutter with Unity sample project

This sample project illustrates the way to export an android package of your Unity game, use it inside your Flutter application and then build everything using Codemagic.

## Unity licensing requirements

Building Unity apps in a cloud CI/CD environment requires a Unity **Plus** or a **Pro** license. Your license is used to activate Unity on the Codemagic build server so the iOS and Android projects can be exported.  The license is returned during the publishing step of the workflow which is always run **except if the build is cancelled**.

Create a new environment variable group and name it `unity`, in this group add these variables (`UNITY_SERIAL`, `UNITY_EMAIL`, `UNITY_PASSWORD`).


## Placing Unity code
create a new folder called `unity/` in the root of your Flutter application, and copy your whole Unity project into that folder.
The expected path is `unity/your-unity-game/...`

## Import the Unity package
In order for the communication to happen, you’ll need to import the `fuw.unitypackage` which you can download from the official repo [here](https://github.com/juicycleff/flutter-unity-view-widget/tree/master/unitypackages).

Go to `Assets → Import Package → Custom Package…` and import your downloaded `.unitypackage`. Make sure to select all the files and click **import**.


## Import the Flutter package
Add the [flutter_unity_widget](https://pub.dev/packages/flutter_unity_widget) package to your `pubspec.yaml `file, and use the widget in our application like this:

```
return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: null,
          child: Container(
            color: Colors.yellow,
            child: UnityWidget(
              onUnityCreated: onUnityCreated,
            ),
          ),
        ),
      ),
    );
```

## Blog post
You can find more detailed instructions in the [blog psot](https://blog.codemagic.io/).