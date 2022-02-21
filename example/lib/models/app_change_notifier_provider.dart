// import 'package:dadabhagwan_tv/api/apiservice.dart';
// import 'package:dadabhagwan_tv/common/app_data.dart';
// import 'package:dadabhagwan_tv/common/constants.dart';
// import 'package:dadabhagwan_tv/common/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'LiveInfoModel.dart';

// class AppChangeNotifierProvider extends ChangeNotifier {
//   String liveSpecialTabName = Constants.liveTabName;
//   String liveSpecialTabInfo = Constants.liveTabInfo;

//   void blankNotify() {
//     notifyListeners();
//   }

//   Future<void> fetchLiveInfoForTv(context) async {
//     try {
//       // String timezoneName = await FlutterNativeTimezone.getLocalTimezone();
//       var response = await APIService.sendHttpRequest(
//           Uri.https(
//             '${Constants.AKFAST_URL}',
//             '/api/fetch_live_info_for_tv/',
//           ),
//           {
//             // 'user_tz': timezoneName,
//             // /// reqrd only for live schedule
//             // 'is_schedule_required': false,
//           },
//           context);

//       if (response != null && response['success']) {
//         if (response['data'] != null) {
//           /// TODO: Comment below line
//           // response = setDummySplSsgResponse();

//           AppData.liveInfo = LiveInfoModel.fromJson(response['data']);

//           if (AppData.liveInfo.isSpecial) {
//             liveSpecialTabName = Constants.specialVideoTabName;
//             liveSpecialTabInfo = Constants.specialVideoTabInfo;
//             String indianTimeStr = await APIService.getIndianTime();
//             computeCurrentISTSpecialSsgList(indianTimeStr);
//           } else {
//             liveSpecialTabName = Constants.liveTabName;
//             liveSpecialTabInfo = Constants.liveTabInfo;
//           }

//           if (AppData.liveInfo.isLive) {
//             AppData.currentTabIndex = TabIndex.LIVE_OR_SPECIAL;
//             AppData.currentFirstLangFocusNode = AppData.firstLiveLangFocusNode;

//             /// Hack: to know if the current program is ON live, not jus created
//             liveSpecialTabInfo = liveSpecialTabInfo.replaceAll(' )', '. )');
//           } else {
//             AppData.currentTabIndex = TabIndex.TV;
//             AppData.currentFirstLangFocusNode = AppData.firstWebTvLangFocusNode;
//           }

//           notifyListeners();

//           // if (AppData.liveInfo.isLive) {
//           Utils.setFocusOnFirstItem();
//           // }

//           // setFocusOnFirstLangTab();
//         }
//       }
//     } catch (e) {
//       print('#EXC _fetchLiveInfo:: $e');
//     }
//   }

//   computeCurrentISTSpecialSsgList(String indianTimeStr) {
//     AppData.liveInfo.liveSatsangVideoList = [];

//     final twentyfourHourTimeFormat = DateFormat('HH:mm:ss');

//     DateTime indiaTimeNow = twentyfourHourTimeFormat.parse(indianTimeStr);

//     for (int i = 0, len = AppData.liveInfo.specialSatsangVideoList.length;
//         i < len;
//         i++) {
//       LiveSatsangVideo splSsgVideo =
//           AppData.liveInfo.specialSatsangVideoList[i];

//       DateTime videoStartTime =
//           twentyfourHourTimeFormat.parse(splSsgVideo.startTime);
//       DateTime videoEndTime =
//           twentyfourHourTimeFormat.parse(splSsgVideo.endTime);

//       if (indiaTimeNow.isAtSameMomentAs(videoStartTime) ||
//           (indiaTimeNow.isAfter(videoStartTime) &&
//               indiaTimeNow.isBefore(videoEndTime))) {
//         AppData.liveInfo.liveSatsangVideoList.add(splSsgVideo);
//       }
//     }
//     notifyListeners();
//   }

//   setDummySplSsgResponse() {
//     /// Change the starttime and endtime of the programs as per testing need
//     return {
//       "data": {
//         "is_live": "Y",
//         "is_special": "N",
//         "default_timezone": "IST",
//         "live_satsang_schedule": [],
//         "live_satsang_video_list": [
//           {
//             "languageName": "Gujarati",
//             "youtubeVideoId": "crsi1z-U-MY",
//             "languageId": 1,
//             "embedCode":
//                 "<iframe src=\"https://www.youtube.com/embed/crsi1z-U-MY?rel=0\" height=\"315\" width=\"560\" frameborder=\"0\" allow=\"autoplay; encrypted-media\" allowfullscreen></iframe>",
//             "videoUrl": "https://www.youtube.com/embed/crsi1z-U-MY?rel=0",
//             "languageOrder": 1,
//             "isAutoPlay": true,
//             "isRedirectToYouTube": true,
//             "translation": false,
//             "eventTitle":
//                 "LIVE PMHT Shibir Activity in Gujarati - 14 August 2021",
//             "eventDate": "14 August 2021",
//             "startTime": "05:30 PM",
//             "endTime": "07:00 PM"
//           }
//         ],
//         "dbf_youtube_channel_url":
//             "https://www.youtube.com/user/dadabhagwan?view_as=subscriber?sub_confirmation=1",
//         "today_schedule_url":
//             "https://downloads.akonnect.org/todays_schedule/live_schedule_16_Sep_2021.jpg",
//         "special_satsang_video_list": [
//           // {
//           //   "languageName": "Gujarati",
//           //   "youtubeVideoId": "VGKwJlj6oqE",
//           //   "videoUrl": "https://www.youtube.com/embed/VGKwJlj6oqE",
//           //   "videoWebUrl":
//           //       "https://www.dadabhagwan.tv/specialsatsang/gujarati/",
//           //   "isAutoPlay": true,
//           //   "isRedirectToYouTube": true,
//           //   "translation": false,
//           //   "eventTitle": "Pujyashree at Trimandir after Lockdown",
//           //   "eventDate": "16 September 2021",
//           //   "startTime": "12:26:00",
//           //   "endTime": "12:33:35"
//           // },
//           // {
//           //   "languageName": "Gujarati",
//           //   "youtubeVideoId": "Vk1eDaXfKr4",
//           //   "videoUrl": "https://www.youtube.com/embed/Vk1eDaXfKr4",
//           //   "videoWebUrl":
//           //       "https://www.dadabhagwan.tv/specialsatsang/gujarati/",
//           //   "isAutoPlay": true,
//           //   "isRedirectToYouTube": true,
//           //   "translation": false,
//           //   "eventTitle": "Jagat Kalyani Bhavna",
//           //   "eventDate": "16 September 2021",
//           //   "startTime": "12:33:35",
//           //   "endTime": "12:37:25"
//           // },
//           // {
//           //   "languageName": "Gujarati",
//           //   "youtubeVideoId": "xGyQo32o414",
//           //   "videoUrl": "https://www.youtube.com/embed/xGyQo32o414",
//           //   "videoWebUrl":
//           //       "https://www.dadabhagwan.tv/specialsatsang/gujarati/",
//           //   "isAutoPlay": true,
//           //   "isRedirectToYouTube": true,
//           //   "translation": false,
//           //   "eventTitle":
//           //       "Paryushan 1999 - Sansaar Jagruti - Atma Jagruti Part- 2",
//           //   "eventDate": "16 September 2021",
//           //   "startTime": "11:24:35",
//           //   "endTime": "12:12:29"
//           // },
//         ]
//       },
//       "success": true,
//       "gujarati": "",
//       "hindi": "",
//       "english": "",
//       "message": "",
//       "code": "0"
//     };
//   }
// }
