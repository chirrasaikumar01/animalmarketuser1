import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceData {
  getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profile = prefs.getString('profile');
    return profile;
  }

  getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profile = prefs.getString('name').toString();
    return profile;
  }

  getEmployeeCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profile = prefs.getString('employee_code').toString();
    return profile;
  }

  getDepartmentCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profile = prefs.getString('department_category').toString();
    return profile;
  }

  getDepartment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profile = prefs.getString('department').toString();
    return profile;
  }

  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profile = prefs.getString('email').toString();
    return profile;
  }

  getMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profile = prefs.getString('mobile').toString();
    return profile;
  }

  getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartCount = prefs.getString('cart_count').toString();
    return cartCount;
  }

  getDob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profile = prefs.getString('dob').toString();
    return profile;
  }

  getDateOfJoining() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profile = prefs.getString('joining_date').toString();
    return profile;
  }

  getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profile = prefs.getString('currentToken').toString();
    return profile;
  }
}
