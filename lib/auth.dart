import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  // set auth in shared preference
  static setAuthCode(token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static setLoginDetail(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  // To get auth in shared preference
  static getAuthCode() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('auth_token');
    String? auth;
    if (authToken != null) {
      auth = authToken;
    } else {
      auth = null;
    }
    return auth;
  }

  static isAuthExpired() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('auth_token');

    bool flag = true;
    if (authToken != null) {
      flag = true;
    } else {
      flag = false;
    }
    return flag;
  }

  static decodeToken(String token) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    String jsonToken = json.encode(decodedToken);
    return jsonToken;
  }

  static setUserName(String cusFname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cus_name', cusFname);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    var cusName = prefs.getString('cus_name');
    return cusName;
  }

  static setUserId(String cusId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cus_id', cusId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    var cusId = prefs.getString('cus_id');
    return cusId;
  }

  static setStoreId(String storeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('storeId', storeId);
  }

  static Future<String?> getStoreId() async {
    final prefs = await SharedPreferences.getInstance();
    var storeId = prefs.getString('storeId');
    return storeId;
  }

  static setTotalCartCount(String totalCartCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('totalCartCount', totalCartCount);
  }

  static setTotalCartAmount(String totalCartAmount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('totalCartAmount', totalCartAmount);
  }

  static Future<String?> gettotalCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    var totalCartCount = prefs.getString('totalCartCount');
    return totalCartCount;
  }

  static Future<String?> gettotalCartAmount() async {
    final prefs = await SharedPreferences.getInstance();
    var totalCartAmount = prefs.getString('totalCartAmount');
    return totalCartAmount;
  }

  static setTotalAmount(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('totalAmount', value);
  }

  static Future<String?> getTotalAmount() async {
    final prefs = await SharedPreferences.getInstance();
    var totalAmount = prefs.getString('totalAmount');
    return totalAmount;
  }

  static setSubTotalAmount(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('subTotalAmount', value);
  }

  static Future<String?> getSubTotalAmount() async {
    final prefs = await SharedPreferences.getInstance();
    var subTotalAmount = prefs.getString('subTotalAmount');
    return subTotalAmount;
  }

  static setDeliveryFee(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('deliveryFeeAmount', value);
  }

  static Future<String?> getDeliveryFee() async {
    final prefs = await SharedPreferences.getInstance();
    var deliveryFeeAmount = prefs.getString('deliveryFeeAmount');
    return deliveryFeeAmount;
  }

  static setCurrencyCode(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currencyCode', value);
  }

  static Future<String?> getCurrencyCode() async {
    final prefs = await SharedPreferences.getInstance();
    var currencyCode = prefs.getString('currencyCode');
    return currencyCode;
  }

  // set Merchant Auth to call merchant related API's
  static setMerchantAuthCode(String auth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('merchantAuth', auth);
  }

  // get Merchant Auth
  static Future<String?> getMerchantAuthCode() async {
    final prefs = await SharedPreferences.getInstance();
    var merchantAuth = prefs.getString('merchantAuth');
    return merchantAuth;
  }
}
