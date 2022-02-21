import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_playout_example/common/app_data.dart';
import 'package:flutter_playout_example/common/constants.dart';
import 'package:flutter_playout_example/common/utils.dart';
import 'package:http/http.dart' as http;

enum HTTP_METHOD { GET, POST }

class APIService {
  // List<WebTVLang> webTVLang = [];


  // /// Get Chennal langauge Ids from API
  // Future<List<WebTVLang>> getWebTvLang() async {
  //   try {
  //     if (webTVLang.length > 0) {
  //       return webTVLang;
  //     }
  //     // Uri url = Uri.https('${URLS.DBAPI_URL}', '/api/schedule/webtvlang');

  //     /// Constant fixed Response, Can it be hardcoded to avoid API call?
  //     /// {"result":{"webtvlang":[{"CHANNEL_ID":58,"CHANNEL_NAME":"Gujarati"},{"CHANNEL_ID":59,"CHANNEL_NAME":"Hindi"},
  //     /// {"CHANNEL_ID":60,"CHANNEL_NAME":"English"}]}}
  //     ///
  //     // final response = await http.get(url);
  //     // if (response.statusCode != 200) {
  //     //   throw 'Error to get TV Languages !!';
  //     // }
  //     // dynamic jsondata = jsonDecode(response.body);
  //     // WebTvLangModel webTvLangModel = WebTvLangModel.fromJson(
  //     //   jsondata['result'],
  //     // );
  //     WebTvLangModel webTvLangModel = WebTvLangModel.fromJson({
  //       "webtvlang": [
  //         {"CHANNEL_ID": 58, "CHANNEL_NAME": "Gujarati"},
  //         {"CHANNEL_ID": 59, "CHANNEL_NAME": "Hindi"},
  //         {"CHANNEL_ID": 60, "CHANNEL_NAME": "English"}
  //       ]
  //     });
  //     webTVLang = webTvLangModel.webtvlang;
  //     return webTVLang;
  //   } catch (e) {
  //     throw e;
  //   }
  // }


  static Future<dynamic> sendHttpRequest(
    Uri uri,
    Map postdata,
    BuildContext context, {
    HTTP_METHOD method,
    bool showLoading = true,
    int timeOutSec,
    bool showErrorMsg = true,
    bool isJsonResponse = true,
  }) async {
    var responseJson;

    if (!await Utils.checkIfInternetIsAvailable()) {
      if (showErrorMsg) {
        Utils.showToast(
            'No internet connection. Please connect to internet and try again.');
      }
      return null;
    }

    try {
      if (showLoading && context != null) {
        Utils.showLoading(context);
      }

      String body = json.encode(postdata);
      // Utils.logger.i('Post Url:' + url + '\tReq:' + body);

      http.Response response;

      if (method == HTTP_METHOD.GET) {
        response = await http.get(uri, headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        }).timeout(Duration(seconds: Constants.HTTP_TIMEOUT));
      } else {
        response = await http
            .post(uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Access-Control-Allow-Origin': '*',
                },
                body: body)
            .timeout(Duration(seconds: timeOutSec ?? Constants.HTTP_TIMEOUT));
      }

      // Utils.logger.i(
      //     '${DateTime.now()} :: Response: ${response.body} status code: ${response.statusCode} msg: ${response.reasonPhrase}');

      final int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        if (isJsonResponse) {
          if (!Utils.isNullOrEmpty(response.body)) {
            responseJson = json.decode(response.body);
          }
        } else {
          responseJson = response.body;
        }
      } else if (statusCode < 200 || statusCode > 400 || json == null) {
        // Utils.logger.e('#ERR HttpStatusCode = $statusCode; URL = $url');
        if (showErrorMsg) {
          Utils.showToast('Server Error - $statusCode!');
        }
        throw Exception('Error while fetching data');
      }
      // ignore: unused_catch_stack
    } catch (e, s) {
      // Utils.logger.e(e);
      // Utils.logger.e(s);
      print('Timeout time--> ${Constants.HTTP_TIMEOUT} ${uri.toString()}');
      // print(
      //     'ConnectivityService.isInternetAvailable :: ${ConnectivityService.isInternetAvailable} ');

      String httpErrorUserMsg = 'Unable to Connect.';

      /// Unable to Connect. = status code: 502 msg: Bad Gateway
      String exceptionStr = e.toString();

      if (exceptionStr.contains('TimeoutException')) {
        httpErrorUserMsg =
            'Server is busy, Please try again !'; //'Timed out. Try again!';
        // 'Server is busy, Please try again. Timeout:${Constants.HTTP_TIMEOUT}, Net:${ConnectivityService.isInternetAvailable}'; //'Timed out. Try again!';
      } else if (exceptionStr
          .contains('SocketException: OS Error: Connection reset by peer')) {
        ///
        /// When server's nginx is down(every monday?), python returns -
        /// SocketException: OS Error: Connection reset by peer, errno = 104
        httpErrorUserMsg = 'Unable to Connect..';
      } else if (exceptionStr.contains('SocketException: Failed host lookup')) {
        httpErrorUserMsg = 'Unable to Connect...';
      }

      if (showErrorMsg) {
        Utils.showToast(httpErrorUserMsg);
      }
    }

    if (showLoading && context != null) {
      Utils.hideLoading(context);
    }

    return responseJson;
  }

  static fireAndForgetRequest(
    Uri url,
    Map postdata, {
    HTTP_METHOD method = HTTP_METHOD.POST,
  }) async {
    var response = await APIService.sendHttpRequest(
      url,
      postdata,
      null,
      method: method,
      showLoading: false,
      showErrorMsg: false,
      isJsonResponse: false,
    );

    return response;
  }

  static sendAppInstallStat(Map<String, dynamic> params) async {
    var ret;
    try {
      Uri url =
          Uri.https('${Constants.STATS_URL}', '/dadabhagwan_tv_app_install');

      var postdata = {};
      postdata.addAll(AppData.currPhysicalDevice.toJson());
      postdata.addAll({
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      postdata.addAll(params ?? {});
      ret = await fireAndForgetRequest(url, postdata);
    } catch (e) {
      print(e.toString());
    }
    return ret;
  }

  static sendStats(String action, Map<String, dynamic> params) {
    var ret;
    try {
      Uri url =
          Uri.https('${Constants.STATS_URL}', '/dadabhagwan_tv_action_stats');

      var postdata = {};
      postdata.addAll(AppData.currPhysicalDevice.toJson());
      postdata.addAll({'action': action});
      postdata.addAll({
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      postdata.addAll(params ?? {});
      ret = fireAndForgetRequest(url, postdata);
    } catch (e) {
      print(e.toString());
    }
    return ret;
  }
}
