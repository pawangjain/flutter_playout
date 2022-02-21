
import 'package:flutter_playout_example/common/app_data.dart';

class InitAppResponse {
  String configVersion;
  // String latestIosAppVersion;
  String latestAppVersionFromServer;
  // String minimumRequiredIosAppVersion; //below which user is forced to update
  String minimumRequiredAppVersionFromServer; //below which user CANNOT USE APP
  String pullNotificationsUrl;
  String akonnectPromoVideoUrl;
  bool androidOsLaunchEnergizerInBrowser = false;

  /// Hack; Trick; deceit; deception
  /// Until the app is reviewed and made live on amazon, set below flag false on server;
  /// so as to avoid app rejection, that vdo player lacks play/pause/fwd functionality
  bool fireOsAppReviewRejectionHackOpenVideoInBrowser = false;

  InitAppResponse({
    this.androidOsLaunchEnergizerInBrowser = false,
    this.fireOsAppReviewRejectionHackOpenVideoInBrowser = false,
  });

  // var sampleResponseOfData = {
  //   "config_version": "1",
  //   "latest_android_app_version": "0.0.1",
  //   "latest_fire_os_app_version": "0.0.1",
  //   "minimum_required_android_app_version": "0.0.1",
  //   "minimum_required_fire_os_app_version": "0.0.1",
  //   "repeat_alarm_time_in_minutes": 4,
  //   "alarm_offset_window_in_minutes": 0,
  // };

  InitAppResponse.fromJson(Map<String, dynamic> json) {
    try {
      configVersion = json['config_version'];

      latestAppVersionFromServer = json['latest_android_app_version'];
      minimumRequiredAppVersionFromServer =
          json['minimum_required_android_app_version'];

      if (AppData.currPhysicalDevice.isFireOs) {
        latestAppVersionFromServer = json['latest_fire_os_app_version'];
        minimumRequiredAppVersionFromServer =
            json['minimum_required_fire_os_app_version'];
      }

      androidOsLaunchEnergizerInBrowser =
          json['launch_energizer_in_browser'] == 1 ?? false;
      fireOsAppReviewRejectionHackOpenVideoInBrowser =
          json['fire_os_launch_energizer_in_browser'] == 1 ?? false;
    } catch (e) {
      print('#EXC $e');
    }
  }
}
