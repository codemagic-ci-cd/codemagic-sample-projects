package io.codemagic.cmreactnative;

import android.app.Application;
import com.facebook.react.PackageList;
import com.facebook.react.ReactApplication;
import com.facebook.react.ReactHost;
import com.facebook.react.ReactNativeApplicationEntryPoint;
import com.facebook.react.defaults.DefaultReactHost;

import java.util.Collections;

public class MainApplication extends Application implements ReactApplication {

  private ReactHost mReactHost;

  @Override
  public ReactHost getReactHost() {
    if (mReactHost == null) {
      mReactHost =
          DefaultReactHost.getDefaultReactHost(
              this,
              new PackageList(this).getPackages(),
              "index",
              "index.android.bundle",
              null,
              null,
              BuildConfig.DEBUG,
              Collections.emptyList(),
              exception -> {
                throw new RuntimeException(exception);
              },
              null);
    }
    return mReactHost;
  }

  @Override
  public void onCreate() {
    super.onCreate();
    ReactNativeApplicationEntryPoint.loadReactNative(this);
  }
}