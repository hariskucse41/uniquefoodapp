import 'package:flutter/foundation.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_foundation/shared_preferences_foundation.dart';
import 'package:shared_preferences_linux/shared_preferences_linux.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_windows/shared_preferences_windows.dart';

class SharedPreferencesBootstrap {
  SharedPreferencesBootstrap._();

  static void ensureInitialized() {
    if (kIsWeb) {
      return;
    }

    if (SharedPreferencesAsyncPlatform.instance != null) {
      return;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        SharedPreferencesAndroid.registerWith();
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        SharedPreferencesFoundation.registerWith();
        break;
      case TargetPlatform.windows:
        SharedPreferencesWindows.registerWith();
        break;
      case TargetPlatform.linux:
        SharedPreferencesLinux.registerWith();
        break;
      case TargetPlatform.fuchsia:
        break;
    }
  }
}
