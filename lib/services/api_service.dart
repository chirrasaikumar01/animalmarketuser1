// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/doctor/models/time_slot_list_model.dart';
import 'package:animal_market/services/api_client.dart';
import 'package:animal_market/services/api_logs.dart';
import 'package:animal_market/services/api_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService extends ChangeNotifier {
  static var client = http.Client();

  static Future<String> getAccessToken() async {
    try {
      var instance = await SharedPreferences.getInstance();
      var token = instance.getString('currentToken');
      Log.console("AccessToken$token");
      if (token == null) {
        return "";
      } else {
        return token;
      }
    } catch (e) {
      Log.console("Error(Function getAccessToken): $e");
      return '';
    }
  }

  ///registerApi
  static Future<http.Response> registerApi(
    String languageCode,
    String countryCode,
    String mobile,
  ) async {
    http.Response response;
    var result = await ApiClient.postData(
      ApiUrl.register,
      body: {
        'language_code': languageCode,
        'country_code': countryCode,
        'mobile': mobile,
      },
    );
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///verifyOtpApi
  static Future<http.Response> verifyOtpApi(
    String mobile,
    String otp,
  ) async {
    http.Response response;
    var result = await ApiClient.postData(ApiUrl.verifyOtp, body: {
      'mobile': mobile,
      'otp': otp,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///languageList
  static Future<http.Response> languageList() async {
    http.Response response;
    var result = await ApiClient.postData(ApiUrl.languageList, body: {});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///categoryList
  static Future<http.Response> categoryList() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.category, headers: {
      'Authorization': 'Bearer $token',
      "Accept": "application/json",
    }, body: {});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///subCategory
  static Future<http.Response> subCategory(String categoryId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.subCategory, headers: {
      'Authorization': 'Bearer $token',
      "Accept": "application/json",
    }, body: {
      "category_id": categoryId
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///stateList
  static Future<http.Response> stateList() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.state, headers: {'Authorization': 'Bearer $token'}, body: {});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///cityList
  static Future<http.Response> cityList(String stateId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.city, headers: {'Authorization': 'Bearer $token'}, body: {"state_id": stateId});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///appDownload
  static Future<http.Response> appDownload() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.appDownload, headers: {'Authorization': 'Bearer $token'}, body: {});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///changeLanguage
  static Future<http.Response> changeLanguage(String languageCode) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.changeLanguage, headers: {
      'Authorization': 'Bearer $token',
      "Accept": "application/json",
    }, body: {
      "language_code": languageCode
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///get Cms Pages
  /// page :-   about_us,contact_us,terms_and_conditions,privacy_policy,data
  static Future<http.Response> getCmsPages(String type) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.cmsPages, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "page": type,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// deactivate Account
  static Future<http.Response> deactivateAccount(String reasonId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.deactivateAccount, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "delete_reason_id": reasonId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// get Notification List
  static Future<http.Response> getNotificationList() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.notificationList, headers: {'Authorization': 'Bearer $token'}, body: {});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// my Blog post List
  static Future<http.Response> myBlogpostList() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.myBlogpostList, headers: {'Authorization': 'Bearer $token'}, body: {});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// blog post List
  static Future<http.Response> blogpostList(String catId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.blogpostList, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "cat_id": catId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// blog post Detail
  static Future<http.Response> blogpostDetail(String postId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.blogpostDetail, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "post_id": postId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// blog post Delete
  static Future<http.Response> blogpostDelete(String postId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.blogpostDelete, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "post_id": postId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// blog post Like
  static Future<http.Response> blogpostLike(String postId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.blogpostLike, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "post_id": postId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// blog post Report
  static Future<http.Response> blogpostReport(String postId, String reportReasonId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.blogpostReport, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "post_id": postId,
      "report_reason_id": reportReasonId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///blogpostCreate
  static Future<dynamic> blogpostCreate(
    String description,
    String image,
    String postId,
    String catId,
  ) async {
    var result;
    http.Response response;
    try {
      var url = ApiUrl.blogpostCreate;
      Log.console('Http.Post Url: $url');
      var token = await getAccessToken();
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        "Accept": "application/json",
      });
      Log.console('Http.Post Headers: ${request.headers}');
      request.fields['description'] = description;
      request.fields['post_id'] = postId;
      request.fields['cat_id'] = catId;
      if (image.isNotEmpty) {
        http.MultipartFile file = await http.MultipartFile.fromPath('image', image);
        request.files.add(file);
      }
      Log.console('Http.Post fields: ${request.fields}');
      response = await http.Response.fromStream(await request.send());
      Log.console('Http.Response Body: ${response.body}');
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        result = {'status_code': 400, 'message': '404'};
      } else if (response.statusCode == 401) {
        result = jsonDecode(response.body);
      }
    } catch (e) {
      result = http.Response(
        jsonEncode({e.toString()}),
        204,
        headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
      );
    }
    return result;
  }

  /// addComment
  static Future<http.Response> addComment(String postId, String comment) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.addComment, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "post_id": postId,
      "comment": comment,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// addCommentReply
  static Future<http.Response> addCommentReply(String postId, String comment, String commentId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.addCommentReply, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "post_id": postId,
      "comment": comment,
      "comment_id": commentId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// reasonsList
  static Future<http.Response> reasonsList(String type) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.reasonsList, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "type": type,

      ///post_report,delete
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// getProfile
  static Future<http.Response> getProfile() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(
      ApiUrl.getProfile,
      headers: {'Authorization': 'Bearer $token'},
      body: {},
    );
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///updateProfile
  static Future<dynamic> updateProfile(
    String name,
    String email,
    String countryCode,
    String whatsappNo,
    String languageCode,
    String dob,
    String gender,
    String address,
    String image,
    String state,
    String city,
    String pinCode,
    String latitude,
    String longitude,
  ) async {
    var result;
    http.Response response;
    try {
      var url = ApiUrl.updateProfile;
      Log.console('Http.Post Url: $url');
      var token = await getAccessToken();
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        "Accept": "application/json",
      });
      Log.console('Http.Post Headers: ${request.headers}');
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['country_code'] = countryCode;
      request.fields['whatsapp_no'] = whatsappNo;
      request.fields['language_code'] = languageCode;
      request.fields['dob'] = dob;

      ///2000-02-12
      request.fields['gender'] = gender;
      request.fields['address'] = address;
      request.fields['state'] = state;
      request.fields['city'] = city;
      request.fields['pincode'] = pinCode;
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      if (image.isNotEmpty) {
        http.MultipartFile file = await http.MultipartFile.fromPath('image', image);
        request.files.add(file);
      }
      Log.console('Http.Post fields: ${request.fields}');
      response = await http.Response.fromStream(await request.send());
      Log.console('Http.Response Body: ${response.body}');
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        result = {'status_code': 400, 'message': '404'};
      } else if (response.statusCode == 401) {
        result = jsonDecode(response.body);
      }
    } catch (e) {
      result = http.Response(
        jsonEncode({e.toString()}),
        204,
        headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
      );
    }
    return result;
  }

  /// event List
  static Future<http.Response> eventList(String date) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(
      ApiUrl.eventList,
      headers: {'Authorization': 'Bearer $token'},
      body: {"date": date},
    );
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// delete Event
  static Future<http.Response> deleteEvent(String eventId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(
      ApiUrl.deleteEvent,
      headers: {'Authorization': 'Bearer $token'},
      body: {"event_id": eventId},
    );
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// add Event
  static Future<http.Response> addEvent(
    String title,
    String description,
    String date,
    String startTime,
    String endTime,
    String remindMe,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(
      ApiUrl.addEvent,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        "title": title,
        "description": description,
        "date": date,
        "start_time": startTime,
        "end_time": endTime,
        "remind_me": remindMe,
      },
    );
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///doctor Home
  static Future<http.Response> doctorHome() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(
      ApiUrl.doctorHome,
      headers: {'Authorization': 'Bearer $token'},
    );
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// create Doctor
  static Future<dynamic> createDoctor(
    String doctorId,
    String name,
    String clinicName,
    String experience,
    String state,
    String city,
    String address,
    String pinCode,
    String aboutDoctor,
    String fees,
    var image,
  ) async {
    var result;
    http.Response response;
    try {
      var url = ApiUrl.createDoctor;
      Log.console('Http.Post Url: $url');
      var token = await getAccessToken();
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        "Accept": "application/json",
      });
      Log.console('Http.Post Headers: ${request.headers}');
      request.fields['doctor_id'] = doctorId;
      request.fields['name'] = name;
      request.fields['clinic_name'] = clinicName;
      request.fields['experience'] = experience;
      request.fields['state'] = state;
      request.fields['city'] = city;
      request.fields['address'] = address;
      request.fields['pincode'] = pinCode;
      request.fields['about_doctor'] = aboutDoctor;
      request.fields['fees'] = fees;
      for (int i = 0; i < image.length; i++) {
        if (image[i].isNotEmpty) {
          http.MultipartFile file = await http.MultipartFile.fromPath('image[$i]', image[i]);
          request.files.add(file);
        }
      }
      Log.console('Http.Post fields: ${request.fields}');
      response = await http.Response.fromStream(await request.send());
      Log.console('Http.Response Body: ${response.body}');
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        result = {'status_code': 400, 'message': '404'};
      } else if (response.statusCode == 401) {
        result = jsonDecode(response.body);
      }
    } catch (e) {
      result = http.Response(
        jsonEncode({e.toString()}),
        204,
        headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
      );
    }
    return result;
  }

  ///subscription Plan List
  static Future<http.Response> subscriptionPlanList() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(
      ApiUrl.subscriptionPlanList,
      headers: {'Authorization': 'Bearer $token'},
    );
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///buy Subscription
  static Future<http.Response> buySubscription(String planId, String paymentMethod) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.buySubscription, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "plan_id": planId,
      "payment_method": paymentMethod,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///my Appointment
  static Future<http.Response> myAppointment(
    String searchKey,
    String type,
    String startDate,
    String endDate,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.myAppointment, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "search_key": searchKey,
      "type": type,
      "start_date": startDate,
      "end_date": endDate,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///cancel Appointment
  static Future<http.Response> cancelAppointment(
    String appointmentId,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.cancelAppointment, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "appointment_id": appointmentId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///doctor Detail
  static Future<http.Response> doctorDetail(
    String doctorId,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.doctorDetail, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "doctor_id": doctorId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///time Slots List
  static Future<http.Response> timeSlotsList(
    String doctorId,
    String day,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.timeSlotsList, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "doctor_id": doctorId,
      "day": day,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///add Doctor Time Slots
  static Future<http.Response> addDoctorTimeSlots(
    String day,
    List<TimeSlotsListModel> timeSlots,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    final body = {
      "day": day,
    };
    if (timeSlots.isNotEmpty) {
      for (int i = 0; i < timeSlots.length; i++) {
        body['time_slots[$i]'] = timeSlots[i].id.toString();
      }
    }
    var result = await ApiClient.postData(
      ApiUrl.addDoctorTimeSlots,
      headers: {'Authorization': 'Bearer $token'},
      body: body,
    );
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///buy Crop Cattle Home
  static Future<http.Response> buyCropCattleHome(String categoryId, String type) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.buyCropCattleHome, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "category_id": categoryId,
      "type": type,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///cattle List
  static Future<http.Response> cattleList(
    String subCategoryId,
    String breedId,
    String minMilkCapacity,
    String maxMilkCapacity,
    String minPrice,
    String maxPrice,
    String latitude,
    String longitude,
    String city,
    String state,
    String pinCode,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.cattleList, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "sub_category_id": subCategoryId,
      "breed": breedId,
      'min_milk_capacity': minMilkCapacity,
      'max_milk_capacity': maxMilkCapacity,
      'min_price': minPrice,
      'max_price': maxPrice,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'state': state,
      'pincode': "",
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///cattle Detail
  static Future<http.Response> cattleDetail(String cattleId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.cattleDetail, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "cattle_id": cattleId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///seller Home
  static Future<http.Response> sellerHome(String type) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.sellerHome, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "type": type,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///seller Dashboard
  static Future<http.Response> sellerDashboard(String type, String status) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.sellerDashboard, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "type": type,
      "status": status,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///crop List
  static Future<http.Response> cropList(
    String subCategoryId,
    String minPrice,
    String maxPrice,
    String latitude,
    String longitude,
    String city,
    String state,
    String pinCode,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.cropList, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "sub_category_id": subCategoryId,
      'min_price': minPrice,
      'max_price': maxPrice,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'state': state,
      'pincode': "",
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///crop Detail
  static Future<http.Response> cropDetail(String cropId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.cropDetail, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "crop_id": cropId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///crop name
  static Future<http.Response> cropName(String cropCat) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.cropName, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "crop_cat": cropCat,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///crop name
  static Future<http.Response> cropVariety(String cropCat, String cropName) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.cropVariety, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "crop_cat": cropCat,
      "crop_type": cropName,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///crop Qualities
  static Future<http.Response> cropQualities() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.cropQualities, headers: {'Authorization': 'Bearer $token'}, body: {});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///breed List
  static Future<http.Response> breed(String categoryId, String subCategoryId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.breed, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "category_id": categoryId,
      "sub_category_id": subCategoryId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///heath Status List
  static Future<http.Response> heathStatusList() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.heathStatusList, headers: {'Authorization': 'Bearer $token'}, body: {});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///features List
  static Future<http.Response> featuresList(String subCategoryId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.featuresList, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "sub_cat_id": subCategoryId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// pregnancy History
  static Future<http.Response> pregnancyHistory() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.pregnancyHistory, headers: {'Authorization': 'Bearer $token'}, body: {});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// create Doctor
  static Future<dynamic> createEditCattle(
    String cattleId,
    String title,
    String description,
    String breedName,
    String catId,
    String subCatId,
    String state,
    String city,
    String pinCode,
    String address,
    String latitude,
    String longitude,
    String breed,
    String isNegotiable,
    String price,
    String gender,
    String isMilk,
    String milkCapacity,
    String isBabyDelivered,
    String isPregnant,
    String isCalf,
    String calfCount,
    String isVaccinated,
    String healthStatus,
    String sellerType,
    String age,
    String pregnancyHistory,
    var image,
    var videos,
    var audios,
  ) async {
    var result;
    http.Response response;
    try {
      var url = ApiUrl.createEditCattle;
      Log.console('Http.Post Url: $url');
      var token = await getAccessToken();
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        "Accept": "application/json",
      });
      Log.console('Http.Post Headers: ${request.headers}');
      request.fields['cattle_id'] = cattleId;
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['breed_name'] = breedName;
      request.fields['cat_id'] = catId;
      request.fields['sub_cat_id'] = subCatId;
      request.fields['state'] = state;
      request.fields['city'] = city;
      request.fields['pincode'] = pinCode;
      request.fields['address'] = address;
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      request.fields['breed'] = breed;
      request.fields['is_negotiable'] = isNegotiable;
      request.fields['price'] = price;
      request.fields['is_milk'] = isMilk;
      request.fields['milk_capacity'] = milkCapacity;
      request.fields['gender'] = gender;
      request.fields['is_vaccinated'] = isVaccinated;
      request.fields['is_baby_delivered'] = isBabyDelivered;
      request.fields['is_pregnent'] = isPregnant;
      request.fields['health_status'] = healthStatus;
      request.fields['is_calf'] = isCalf;
      request.fields['calf_count'] = calfCount;
      request.fields['seller_type'] = sellerType;
      request.fields['age'] = age;
      request.fields['pregnency_history'] = pregnancyHistory;
      for (int i = 0; i < image.length; i++) {
        if (image[i].isNotEmpty) {
          http.MultipartFile file = await http.MultipartFile.fromPath('images[$i]', image[i]);
          request.files.add(file);
        }
      }
      for (int i = 0; i < audios.length; i++) {
        if (audios[i].isNotEmpty) {
          http.MultipartFile file = await http.MultipartFile.fromPath('audios[$i]', audios[i]);
          request.files.add(file);
        }
      }
      for (int i = 0; i < videos.length; i++) {
        if (videos[i].isNotEmpty) {
          http.MultipartFile file = await http.MultipartFile.fromPath('videos[$i]', videos[i]);
          request.files.add(file);
        }
      }
      Log.console('Http.Post fields: ${request.fields}');
      response = await http.Response.fromStream(await request.send());
      Log.console('Http.Response Body: ${response.body}');
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        result = {'status_code': 400, 'message': '404'};
      } else if (response.statusCode == 401) {
        result = jsonDecode(response.body);
      }
    } catch (e) {
      result = http.Response(
        jsonEncode({e.toString()}),
        204,
        headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
      );
    }
    return result;
  }

  /// delete Cattle
  static Future<http.Response> deleteCattle(String cattleId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.deleteCattle, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "cattle_id": cattleId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// cattle Mark To Sold
  static Future<http.Response> cattleMarkToSold(String cattleId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.cattleMarkToSold, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "cattle_id": cattleId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///fcmUpdate
  static Future<http.Response> fcmUpdate(String fcmToken) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(
      ApiUrl.updateFcm,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "fcm_token": fcmToken,
      },
    );
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// create Doctor
  static Future<dynamic> createEditCrop(
    String cropId,
    String title,
    String description,
    String catId,
    String subCatId,
    String state,
    String city,
    String pinCode,
    String address,
    String latitude,
    String longitude,
    String cropType,
    String isNegotiable,
    String price,
    String cropVariety,
    String quantityType,
    String quantity,
    String cropCondition,
    String isOrganic,
    String isQualityTested,
    String storageCondition,
    String sellerType,
    String isHarvested,
    String age,
    var image,
    var videos,
    var audios,
  ) async {
    var result;
    http.Response response;
    try {
      var url = ApiUrl.createEditCrop;
      Log.console('Http.Post Url: $url');
      var token = await getAccessToken();
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        "Accept": "application/json",
      });
      Log.console('Http.Post Headers: ${request.headers}');
      request.fields['crop_id'] = cropId;
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['cat_id'] = catId;
      request.fields['sub_cat_id'] = subCatId;
      request.fields['state'] = state;
      request.fields['city'] = city;
      request.fields['pincode'] = pinCode;
      request.fields['address'] = address;
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      request.fields['crop_type'] = cropType;
      request.fields['is_negotiable'] = isNegotiable;
      request.fields['price'] = price;
      request.fields['quantity_type'] = quantityType;
      request.fields['quantity'] = quantity;
      request.fields['crop_variety'] = cropVariety;
      request.fields['crop_condition'] = cropCondition;
      request.fields['is_organic'] = isOrganic;
      request.fields['is_quality_tested'] = isQualityTested;
      request.fields['storage_condition'] = storageCondition;
      request.fields['seller_type'] = sellerType;
      request.fields['is_harvested'] = isHarvested;
      request.fields['age'] = age;
      for (int i = 0; i < image.length; i++) {
        if (image[i].isNotEmpty) {
          http.MultipartFile file = await http.MultipartFile.fromPath('images[$i]', image[i]);
          request.files.add(file);
        }
      }
      for (int i = 0; i < audios.length; i++) {
        if (audios[i].isNotEmpty) {
          http.MultipartFile file = await http.MultipartFile.fromPath('audios[$i]', audios[i]);
          request.files.add(file);
        }
      }
      for (int i = 0; i < videos.length; i++) {
        if (videos[i].isNotEmpty) {
          http.MultipartFile file = await http.MultipartFile.fromPath('videos[$i]', videos[i]);
          request.files.add(file);
        }
      }
      Log.console('Http.Post fields: ${request.fields}');
      response = await http.Response.fromStream(await request.send());
      Log.console('Http.Response Body: ${response.body}');
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        result = {'status_code': 400, 'message': '404'};
      } else if (response.statusCode == 401) {
        result = jsonDecode(response.body);
      }
    } catch (e) {
      result = http.Response(
        jsonEncode({e.toString()}),
        204,
        headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
      );
    }
    return result;
  }

  /// create Doctor
  static Future<dynamic> createEditPet(
    String petId,
    String title,
    String description,
    String breedName,
    String purpose,
    String catId,
    String subCatId,
    String breed,
    String gender,
    String ageType,
    String age,
    String isNegotiable,
    String price,
    String vaccination,
    String vaccineName,
    String vaccineDate,
    String state,
    String city,
    String pinCode,
    String address,
    String latitude,
    String longitude,
    var image,
    var videos,
    var audios,
    String isMicroChipped,
    String isDewormed,
    String isNeutered,
    String requiredSpecialCare,
    String goodWithPets,
    String goodWithKids,
    String isTrained,
    String trainingType,
    String deliveryOption,
    String shippingCharges,
    String packingCharges,
    String whatsappNo,
    String sellerMobileNumber,
    String sellerName,
  ) async {
    var result;
    http.Response response;
    try {
      var url = ApiUrl.createEditPet;
      Log.console('Http.Post Url: $url');
      var token = await getAccessToken();
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        "Accept": "application/json",
      });
      Log.console('Http.Post Headers: ${request.headers}');
      request.fields['pet_id'] = petId;
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['breed_name'] = breedName;
      request.fields['purpose'] = purpose;
      request.fields['cat_id'] = catId;
      request.fields['sub_cat_id'] = subCatId;
      request.fields['breed'] = breed;
      request.fields['gender'] = gender;
      request.fields['age_type'] = ageType;
      request.fields['age'] = age;
      request.fields['is_negotiable'] = isNegotiable;
      request.fields['price'] = price;
      request.fields['vaccination'] = vaccination;
      request.fields['vaccine_name'] = vaccineName;
      request.fields['vaccine_date'] = vaccineDate;
      request.fields['state'] = state;
      request.fields['city'] = city;
      request.fields['pincode'] = pinCode;
      request.fields['address'] = address;
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      request.fields['is_microchipped'] = isMicroChipped;
      request.fields['is_dewormed'] = isDewormed;
      request.fields['is_neutered'] = isNeutered;
      request.fields['requires_special_care'] = requiredSpecialCare;
      request.fields['good_with_pets'] = goodWithPets;
      request.fields['good_with_kids'] = goodWithKids;
      request.fields['is_trained'] = isTrained;
      request.fields['training_type'] = trainingType;
      request.fields['delivery_option'] = deliveryOption;
      request.fields['shipping_charges'] = shippingCharges;
      request.fields['packing_charges'] = packingCharges;
      request.fields['whatsapp_no'] = whatsappNo;
      request.fields['seller_mobile_no'] = sellerMobileNumber;
      request.fields['seller_name'] = sellerName;
      for (int i = 0; i < image.length; i++) {
        if (image[i].isNotEmpty) {
          http.MultipartFile file = await http.MultipartFile.fromPath('images[$i]', image[i]);
          request.files.add(file);
        }
      }
      for (int i = 0; i < audios.length; i++) {
        if (audios[i].isNotEmpty) {
          http.MultipartFile file = await http.MultipartFile.fromPath('audios[$i]', audios[i]);
          request.files.add(file);
        }
      }
      for (int i = 0; i < videos.length; i++) {
        if (videos[i].isNotEmpty) {
          http.MultipartFile file = await http.MultipartFile.fromPath('videos[$i]', videos[i]);
          request.files.add(file);
        }
      }
      Log.console('Http.Post fields: ${request.fields}');
      response = await http.Response.fromStream(await request.send());
      Log.console('Http.Response Body: ${response.body}');
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        result = {'status_code': 400, 'message': '404'};
      } else if (response.statusCode == 401) {
        result = jsonDecode(response.body);
      }
    } catch (e) {
      result = http.Response(
        jsonEncode({e.toString()}),
        204,
        headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
      );
    }
    return result;
  }

  /// delete Crop
  static Future<http.Response> deleteCrop(String cropId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.deleteCrop, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "crop_id": cropId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// crop Mark To Sold
  static Future<http.Response> cropMarkToSold(String cropId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.cropMarkToSold, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "crop_id": cropId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// knowledge List
  static Future<http.Response> knowledgeList(
    String catId,
    String subCatId,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.knowledgeList, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "cat_id": catId,
      "sub_cat_id": subCatId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// knowledge Details
  static Future<http.Response> knowledgeDetails(
    String knowledgeId,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.knowledgeDetails, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "knowledge_id": knowledgeId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///pet List
  static Future<http.Response> petList(
    String subCategoryId,
    String minPrice,
    String maxPrice,
    String latitude,
    String longitude,
    String city,
    String state,
    String pinCode,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.petList, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "sub_category_id": subCategoryId,
      'min_price': minPrice,
      'max_price': maxPrice,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'state': state,
      'pincode': "",
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///pet Detail
  static Future<http.Response> petDetail(String petId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.petDetail, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "pet_id": petId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// delete Pet
  static Future<http.Response> deletePet(String petId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.deletePet, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "pet_id": petId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// pet Mark To Sold
  static Future<http.Response> petMarkToSold(String petId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.petMarkToSold, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "pet_id": petId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// health Report Home
  static Future<http.Response> healthReportHome() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.healthReportHome, headers: {'Authorization': 'Bearer $token'}, body: {});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// health Report Plan List
  static Future<http.Response> reportPlanList() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.reportPlanList, headers: {'Authorization': 'Bearer $token'}, body: {});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// pay For Health Report
  static Future<http.Response> payForHealthReport(
    String reportId,
    String paymentStatus,
    String transactionId,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.payForHealthReport, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "report_id": reportId,
      "payment_status": paymentStatus,
      "transaction_id": transactionId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// health Report Add
  static Future<dynamic> healthReportAdd(
    String reportPlanId,
    String fees,
    String gst,
    String moreInfo,
    var image,
    var videos,
  ) async {
    var result;
    http.Response response;
    try {
      var url = ApiUrl.healthReportAdd;
      Log.console('Http.Post Url: $url');
      var token = await getAccessToken();
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        "Accept": "application/json",
      });
      Log.console('Http.Post Headers: ${request.headers}');
      request.fields['report_plan_id'] = reportPlanId;
      request.fields['fees'] = fees;
      request.fields['gst'] = gst;
      request.fields['more_info'] = moreInfo;
      for (int i = 0; i < image.length; i++) {
        if (image[i].isNotEmpty) {
          http.MultipartFile file = await http.MultipartFile.fromPath('images[$i]', image[i]);
          request.files.add(file);
        }
      }
      for (int i = 0; i < videos.length; i++) {
        if (videos[i].isNotEmpty) {
          http.MultipartFile file = await http.MultipartFile.fromPath('videos[$i]', videos[i]);
          request.files.add(file);
        }
      }
      Log.console('Http.Post fields: ${request.fields}');
      response = await http.Response.fromStream(await request.send());
      Log.console('Http.Response Body: ${response.body}');
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        result = {'status_code': 400, 'message': '404'};
      } else if (response.statusCode == 401) {
        result = jsonDecode(response.body);
      }
    } catch (e) {
      result = http.Response(
        jsonEncode({e.toString()}),
        204,
        headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
      );
    }
    return result;
  }

  /// my Health Report
  static Future<http.Response> myHealthReport(
    String date,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.myHealthReport, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "date": date,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// add Remove Favourite
  static Future<http.Response> addRemoveFavourite(
    String catId,
    String listingId,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.addRemoveFavourite, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "cat_id": catId,
      "listing_id": listingId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  /// my Favourite List
  static Future<http.Response> myFavouriteList(
    String catId,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.myFavouriteList, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "cat_id": catId,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///  doctor List
  static Future<http.Response> doctorList() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.doctorList, headers: {'Authorization': 'Bearer $token'}, body: {});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///  book Appointment
  static Future<http.Response> bookAppointment(
    String doctorId,
    String date,
    String timeSlotId,
    String paymentMode,
  ) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.bookAppointment, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      "doctor_id": doctorId,
      "date": date,
      "time_slot_id": timeSlotId,
      "payment_mode": paymentMode,
    });
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }

  ///  faq List Api
  static Future<http.Response> faqListApi() async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.faqList, headers: {'Authorization': 'Bearer $token'}, body: {});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }
  ///  translations
  static Future<http.Response> translations(String languageCode) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.translations, headers: {'Authorization': 'Bearer $token'}, body: {"language_code": languageCode});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }
  ///  other seller detail
  static Future<http.Response> getOtherSellerDetail(String sellerId) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.getOtherSellerDetail, headers: {'Authorization': 'Bearer $token'}, body: {"seller_id": sellerId});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }
  static Future<http.Response> increaseCallCount(String type,String id) async {
    http.Response response;
    var token = await getAccessToken();
    var result = await ApiClient.postData(ApiUrl.increaseCallCount, headers: {'Authorization': 'Bearer $token'}, body: {"type": type,"id":id});
    response = http.Response(jsonEncode(result), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    return response;
  }
}
