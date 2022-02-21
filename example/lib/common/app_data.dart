
import 'package:flutter/material.dart';
import 'package:flutter_playout_example/models/device.dart';
import 'package:flutter_playout_example/models/init_app_response.dart';

class AppData {
  static bool isOnline = true; //false;
  static int currentTabIndex = 0;
  static int currentFocusedTabIndex = -1;

  // static Map currPhysicalDevice = {};
  static Device currPhysicalDevice;
  static InitAppResponse initAppResponse = InitAppResponse();

  // static Language webTvSelectedLanguage;

  static String livePreferredLanguage;
  static String webTv24x7PreferredLanguage;
  static bool isAppInstalledStatSent = false; //false;
  static bool openWebTvInBrowser = false; //false;
  static bool useYoutubeAppForLiveSsg = false; //Only on Android ;
  static bool openSpecialSatsangInBrowser = false; //Only on Android ;
  /// On Fire TV; play Live & Recent Satsang in inapp player due to issues in Silk Browser
  static bool openLiveSatsangInBrowser = false; // Only on Fire OS ;
  static bool openRecentSatsangInBrowser = false; // Only on Fire OS;

  // static List<Tvschedule> currentLanguageWebTvScheduleList = [];

  // static CurTVProgramModel curTVProgramModel;
  // static List<Tvschedule> currentLanguageTvSchedule = [];

  // static List<Energizer> currentEnergizerList = [];
  // static List currentRecentSatsangLanguageList = [];
  // static List<RecentSatsang> currentRecentSatsangList = [];

  // static LiveInfoModel liveInfo = LiveInfoModel();

  static FocusNode currentFirstLangFocusNode;
  static FocusNode firstWebTvLangFocusNode = FocusNode();
  static FocusNode firstLiveLangFocusNode = FocusNode();
  static FocusNode firstEnergizerFocusNode = FocusNode();
  static FocusNode firstRecentSatsangFocusNode = FocusNode();
}
