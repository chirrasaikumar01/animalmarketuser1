// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:animal_market/core/constants.dart';
import 'package:animal_market/modules/auth/views/login_view.dart';
import 'package:animal_market/services/api_logs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static Future getData(String url, {Map<String, String>? headers}) async {
    var result;
    Log.console('Http.Get Url: $url');
    if (headers != null) {
      Log.console('Http.Get Headers: $headers');
    }
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      result = handleResponse(response);
      Log.console('Http.Get Response Code: ${response.statusCode}');
      Log.console('Http.Get Response Body: ${response.body}');
    } catch (e) {
      result = handleResponse();
      Log.console('Http.Get Error: $e');
      Log.console('Http.Get Response Body: $result');
    }
    return result;
  }

  static Future postData(String url, {Map<String, String>? headers, Object? body, bool skip401 = false}) async {
    var result;
    Log.console('Http.Post Url: $url');
    if (headers != null) {
      Log.console('Http.Post Headers: $headers');
    }
    if (body != null) {
      Log.console('Http.Post Body: $body');
    }

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      result = handleResponse(response, skip401);
      Log.console('Http.Post Response Code: ${response.statusCode}');
      Log.console('Http.Post Response Body: ${response.body}');
    } catch (e) {
      result = handleResponse();
      Log.console('Http.Post Error: $e');
      Log.console('Http.Post Response Body: $result');
    }

    return result;
  }

  static dynamic handleResponse([http.Response? response, bool skip401 = false]) async {
    var result;
    try {
      if (response != null) {
        switch (response.statusCode) {
          case 200:
            result = jsonDecode(response.body);
            break;
          case 201:
            result = jsonDecode(response.body);
            break;
          case 302:
            SharedPreferences preferences = await SharedPreferences.getInstance();
            await preferences.clear();
            Constants.navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(
                settings: const RouteSettings(name: '/login'),
                builder: (_) => const LoginView(),
              ),
            );
            result = {'status': false, 'message': 'Redirecting to login screen'};
            break;
          /* case 404:
            SharedPreferences preferences = await SharedPreferences.getInstance();
            await preferences.clear();
            navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(
                settings: const RouteSettings(name: '/login'),
                builder: (_) => const UserTypeView(),
              ),
            );
            result = {'status': false, 'message': 'Redirecting to login screen'};
            break;*/
          case 401:
            SharedPreferences preferences = await SharedPreferences.getInstance();
            await preferences.clear();
            Constants.navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(
                settings: const RouteSettings(name: '/login'),
                builder: (_) => const LoginView(),
              ),
            );
            if (!skip401) {
              Constants.navigatorKey.currentState?.pushReplacement(
                MaterialPageRoute(
                  settings: const RouteSettings(name: '/login'),
                  builder: (_) => const LoginView(),
                ),
              );
            }
            result = {'status': false, 'message': response.reasonPhrase};
            break;
          default:
            result = {'status': false, 'message': response.reasonPhrase};
            break;
        }
      } else {
        result = {'status': false, 'message': 'Unable to Connect to Server!'};
      }
    } catch (e) {
      Log.console('Handle Response Error: $e');
      result = {'status': false, 'message': 'Something went Wrong!'};
    }
    return result;
  }
}
