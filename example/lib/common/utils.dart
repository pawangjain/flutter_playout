import 'dart:io';

// import 'package:android_intent_plus/android_intent.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_playout_example/common/constants.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart'
    as flutterStyledToast;
import 'package:version/version.dart';
import 'dart:convert';
import 'app_data.dart';

enum SnackBarType { success, error, warning, info }

// extension StringExtensions on String {
//   // bool get isNullOrEmpty {
//   //   bool _hasSpace = RegExp(r'\s').hasMatch(this);
//   //   //  bool _hasSpace = this.contains(' ');

//   //   return this == null || isEmpty || _hasSpace;
//   // }

//   String removeSecondsPart() {
//     String ret = '';
//     if (!Utils.isNullOrEmpty(this) && this.length == 8) {
//       ret = this.substring(0, 5);
//     }
//     return ret;
//   }
// }

class Utils {
  // static ProgressDialog progressDialog;

  // static final logger = Logger(printer: SimpleLogPrinter());

  static bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase()?.trim() == string2?.toLowerCase()?.trim();
  }

  /// Launch in external system app
  static launchURL(String videoUrl) async {
    if (!isNullOrEmpty(videoUrl)) {
      await launch('$videoUrl', forceSafariVC: false);
    }
  }

   static askAndroidStoragePermission() async {
    Map<Permission, PermissionStatus> statuses = await [
              // Permission.location,
              Permission.storage,
            ].request();
  }

  // static getEnergizerWebUrl(String energizerVideoId) {
  //   // getEnergyCode
  //   final bytes = utf8.encode(energizerVideoId);
  //   String base64Str = base64.encode(bytes);
  //   // print(base64Str);
  //   base64Str = 'https://www.dadabhagwan.tv/energizers/' + base64Str + '/';

  //   return base64Str;
  // }

  // static void setFocusOnFirstItem() {
  //   // return;
  //   /// AUTO Focus on 1st language btn only in TV and Live tab @Jineshbhai 25-OCT-21
  //   Future.delayed(const Duration(milliseconds: 500), () {
  //     AppData.currentFirstLangFocusNode?.requestFocus();
  //   });
  // }

  // static launchURL(String videoUrl, [bool openInYoutubeApp = false]) async {
  //   if (kIsWeb) {
  //     // html.window.open('https://$videoUrl', '_blank');
  //   } else {
  //     String videoUrlWithoutHttp = videoUrl.split('://')[1];

  //     // bool canOpenInYoutubeApp =
  //     //     await canLaunch('youtube://$videoUrlWithoutHttp');
  //     if (openInYoutubeApp) {
  //       // && canOpenInYoutubeApp) {
  //       await launch('vnd.youtube://$videoUrlWithoutHttp',
  //           forceSafariVC: false);
  //     } else {
  //       if (await canLaunch('$videoUrl')) {
  //         await launch('$videoUrl');
  //       } else {
  //         showToast('Error to launch $videoUrl');
  //       }
  //     }
  //   }
  // }

  static getCurrentDateTime() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    // return DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
  }

  static showToast(String msg,
      [Duration duration = const Duration(
        milliseconds: 2400,
      ),
      flutterStyledToast.StyledToastPosition position =
          flutterStyledToast.StyledToastPosition.top]) {
    flutterStyledToast.showToast(msg, duration: duration, position: position
        //,textStyle: TextStyle(fontSize: 14)
        );
  }

  static showSnackBar(context, SnackBarType snackBarType, String str) {
    Color snackBarColor;
    IconData snackBarIcon;

    switch (snackBarType) {
      case SnackBarType.success:
        snackBarColor = Colors.lightGreen;
        snackBarIcon = Icons.check;
        break;
      case SnackBarType.error:
        snackBarColor = Colors.red;
        snackBarIcon = Icons.cancel_outlined;
        break;
      case SnackBarType.warning:
        snackBarColor = Colors.amber;
        snackBarIcon = Icons.warning_amber_outlined;
        break;
      case SnackBarType.info:
        snackBarColor = Colors.blue;
        snackBarIcon = Icons.info_outline;
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(snackBarIcon),
          SizedBox(
            width: 9,
          ),
          Text(
            '$str',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: snackBarColor,
    ));
  }

  static Future<void> showLoading(BuildContext context, {GlobalKey key}) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              children: <Widget>[
                Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.grey[200]),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  static void hideLoading(BuildContext context, {GlobalKey key}) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static bool isNullOrEmpty(String str) {
    return str == null || str.trim().isEmpty;
  }

  static showAlert({
    @required BuildContext context,
    String type = 'info', // 'success' || 'error'
    String title = '',
    String msg,
    bool showDoneButton = true,
    String doneButtonText,
    String cancelButtonText,
    Function doneButtonFn,
    bool barrierDismissible,
    bool showCancelButton = false,
    Function doneCancelFn,
    AlertDialog Function() builder,
    Widget widget,
    String errorHint,
    bool closeable = true,
    bool isAutoClose = true,
  }) {
    String cancel = 'Cancel';
    String ok = 'OK';
    // String ok = AppLocalizations.of(context).translate('ok');
    //based on DeviceWidth we can decide button width and margin between button width
    double deviceWidth = MediaQuery.of(context).size.width;

    if (context != null) {
      String newTitle = !Utils.isNullOrEmpty(title)
          ? title
          : type == 'error'
              ? 'Error'
              : type == 'success'
                  ? 'Success'
                  : '';

      FocusNode _doneBtnFocusNode = FocusNode();
      showDialog(
        context: context,
        barrierDismissible: barrierDismissible ?? true,
        builder: (_) {
          return WillPopScope(
            onWillPop: () async => closeable,
            child: ButtonBarTheme(
              data: ButtonBarThemeData(alignment: MainAxisAlignment.center),
              child: AlertDialog(
                title: (type == 'info' && Utils.isNullOrEmpty(newTitle)
                    ? null
                    : Column(
                        children: <Widget>[
                          (type == 'success' ||
                                  type == 'error' ||
                                  type == 'warning')
                              ? Container(
                                  //color: Colors.green,
                                  // height: 70,
                                  // child: Padding(
                                  //   padding: const EdgeInsets.only(bottom: 8.0),
                                  //   child: FlareActor(
                                  //     'assets/animation/$type.flr',
                                  //     animation: '$type',
                                  //   ),
                                  // ),
                                  )
                              : Container(),
                          if (!Utils.isNullOrEmpty(newTitle)) Text(newTitle),
                        ],
                      )),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                content: Container(
                  //     height: 200,
                  // width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        widget != null ? widget : Container(),
                        SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            msg != null ? msg : '',
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.caption.color),
                          ),
                        ),
                        // SizedBox(height: 5.0),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Center(
                      child: Container(
                        // color: Colors.red,
                        // width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: showCancelButton
                              ? MainAxisAlignment.spaceAround
                              : MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 40,
                              width: deviceWidth < 410 ? 110 : 125,
                              child: InkWell(
                                // autofocus: true,
                                child: ElevatedButton(
                                  focusNode: _doneBtnFocusNode,
                                  onPressed: () {
                                    if (isAutoClose) {
                                      Navigator.pop(context);
                                    }
                                    if (doneButtonFn != null) {
                                      doneButtonFn();
                                    }
                                  },
                                  child: Text(
                                    doneButtonText ?? ok, //'OK',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    // returns ButtonStyle
                                    // primary: Colors.red,
                                    // onPrimary: Colors.white,
                                    shape: StadiumBorder(
                                        // side: BorderSide(
                                        //     width: 10,
                                        //     color: Colors
                                        //         .blue) // Not Working (Read Note).
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            showCancelButton
                                ? SizedBox(width: deviceWidth < 410 ? 10 : 20)
                                : SizedBox(),
                            showCancelButton
                                ? Container(
                                    height: 40,
                                    width: deviceWidth < 410
                                        ? 110
                                        : 125, //adjusting width based on screen size
                                    child: OutlinedButton(
                                      onPressed: doneCancelFn != null
                                          ? doneCancelFn
                                          : () {
                                              Navigator.pop(context);
                                            },
                                      child: Text(
                                        cancelButtonText ?? cancel, //'Cancel',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        // returns ButtonStyle
                                        side: BorderSide(
                                            width: 2.0,
                                            color: Constants.highlightColor),
                                        shape: StadiumBorder(
                                            // side: BorderSide(
                                            //     width: 10,
                                            //     color: Colors
                                            //         .blue) // Not Working (Read Note).
                                            ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      Future.delayed(Duration(milliseconds: 500), () {
        _doneBtnFocusNode.requestFocus();
        // _doneBtnFocusNode.dispose();
      });
    }
  }

  static checkIfInternetIsAvailable() async {
    bool isOnline = false;
    try {
      /// https://stackoverflow.com/questions/49648022/check-whether-there-is-an-internet-connection-available-on-flutter-app
      /// https://stackoverflow.com/questions/55060998/how-to-continuously-check-internet-connect-or-not-on-flutter
      /// On some android devices, Network change event is not obtained or returns none,
      /// hence manually connect to below domains and ascertain internet availability
      // final result = await InternetAddress.lookup('google.com');
      // final result2 = await InternetAddress.lookup('facebook.com');
      final result3 = await InternetAddress.lookup('microsoft.com');
      final result4 = await InternetAddress.lookup('wikipedia.org');
      // final result5 = await InternetAddress.lookup('dadabhagwan.org');

      if (
          // (result.isNotEmpty && result[0].rawAddress.isNotEmpty) ||
          //   (result2.isNotEmpty && result2[0].rawAddress.isNotEmpty) ||
          (result3.isNotEmpty && result3[0].rawAddress.isNotEmpty) ||
              (result4.isNotEmpty && result4[0].rawAddress.isNotEmpty)
          //|| (result5.isNotEmpty && result5[0].rawAddress.isNotEmpty)
          ) {
        isOnline = true;
        print("#DEVICE is ONLINE");
      } else {
        isOnline = false;
        print("#DEVICE went Offline");
      }
    } catch (e) {
      isOnline = false;
      print("##DEVICE went Offline");
    }

    return isOnline;
  }

  // static checkIfAppUpdateIsAvailable(context) async {
  //   try {
  //     var response = await APIService.sendHttpRequest(
  //       Uri.https(
  //         '${Constants.AKFAST_URL}',
  //         '/api/init_android_tv_app/',
  //       ),
  //       {},
  //       null,
  //       showLoading: false,
  //       showErrorMsg: false,
  //     );

  //     if (response != null) {
  //       // InitAppResponse initAppResponse = InitAppResponse.fromJson(
  //       AppData.initAppResponse = InitAppResponse.fromJson(
  //         response,
  //       );

  //       Version installedVersion =
  //           Version.parse(AppData.currPhysicalDevice.appVersion);
  //       Version serverVersion =
  //           Version.parse(AppData.initAppResponse.latestAppVersionFromServer);

  //       if (serverVersion > installedVersion) {
  //         debugPrint("Update is available");
  //         String sharedPrefReminderDateStr =
  //             await SharedPreferencesService.getString(
  //                 SharedPrefConstants.AppUpdateReminderDate);
  //         DateTime todaysDate = DateTime.now();
  //         DateTime sharedPrefReminderDate;

  //         if (Utils.isNullOrEmpty(sharedPrefReminderDateStr)) {
  //           sharedPrefReminderDate = todaysDate;
  //           await SharedPreferencesService.setString(
  //               SharedPrefConstants.AppUpdateReminderDate,
  //               todaysDate.toString());
  //         } else {
  //           sharedPrefReminderDate = DateTime.parse(sharedPrefReminderDateStr);
  //         }

  //         bool isReminderDateCrossed =
  //             sharedPrefReminderDate.difference(todaysDate).inDays <= 0;

  //         bool showRemindLaterBtn = true;

  //         if (!Utils.isNullOrEmpty(
  //             AppData.initAppResponse.minimumRequiredAppVersionFromServer)) {
  //           Version serverMinimumRequiredVersion = Version.parse(
  //               AppData.initAppResponse.minimumRequiredAppVersionFromServer);

  //           if (installedVersion < serverMinimumRequiredVersion) {
  //             isReminderDateCrossed = true;
  //             showRemindLaterBtn = false;
  //           }
  //         }

  //         String appstoreUrl = Constants.appPlayStoreUrl;

  //         appstoreUrl =
  //             response[AppData.currPhysicalDevice.deviceOs + '_store_url'];

  //         if (Utils.isNullOrEmpty(appstoreUrl)) {
  //           appstoreUrl = Constants.appPlayStoreUrl;
  //         }

  //         if (isReminderDateCrossed) {
  //           Utils.showAlert(
  //               context: context,
  //               closeable: false,
  //               title: 'Update is available',
  //               msg:
  //                   '\nNew version (${AppData.initAppResponse.latestAppVersionFromServer}) is available with enhanced features.\n\nPlease click on "Update Now" button to update it from the app store.\n\n',
  //               doneButtonText: 'Update Now',
  //               doneButtonFn: () {
  //                 Utils.launchURL(appstoreUrl);
  //               },
  //               showCancelButton: showRemindLaterBtn,
  //               cancelButtonText: 'Remind Later',
  //               doneCancelFn: () async {
  //                 DateTime todaysDate = DateTime.now().add(Duration(
  //                     days: Constants.APP_UPDATE_REMINDER_INTERVAL_DAYS));

  //                 await SharedPreferencesService.setString(
  //                     SharedPrefConstants.AppUpdateReminderDate,
  //                     todaysDate.toString());

  //                 Navigator.pop(context);
  //               });
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print('#EXC _checkIfAppUpdateIsAvailable - $e');
  //   }
}
