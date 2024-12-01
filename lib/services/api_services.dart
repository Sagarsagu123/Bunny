import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_demo/auth.dart';
import 'package:flutter_demo/modules/checkout/checkout.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/order-management/order-management-controller.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService extends GetxController {
  static Future sendOtp(phoneNumber, selectedCountryCode) async {
    var client = http.Client();
    try {
      var options = {
        'cus_phone': "$selectedCountryCode$phoneNumber",
        'lang': 'en'
      };
      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      var uri = Uri.http(ROUTE, SEND_OTP_SIGN_UP, options);
      var response = await client.post(uri, headers: headers);
      var responseBody = json.decode(response.body);
      return responseBody;
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
    return null;
  }

  static Future verifyOtp(
      phoneNumber, enteredOtp, token, selectedCountryCode) async {
    var client = http.Client();
    try {
      var options = {
        "lang": "en",
        "otp": enteredOtp,
        "phone": "$selectedCountryCode$phoneNumber",
        "token": token
      };
      print(options);
      bool isProd = is_prod;
      var uri = isProd == true
          ? Uri.https(ROUTE, VERIFY_OTP, options)
          : Uri.http(ROUTE, VERIFY_OTP, options);
      var response = await client.post(uri);
      var responseBody = json.decode(response.body);
      return responseBody;
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
    return null;
  }

  static updateUserInfoWhileRegistering(userInfo) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var options = {
          "lang": "en",
          "cus_fname": userInfo.displayFirstName,
          "cus_lname": userInfo.displayLastName,
          "cus_password": userInfo.confirmPassword,
          "cus_email": userInfo.email,
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, UPDATE_CUSTOMER_INFO_REG, options)
            : Uri.http(ROUTE, UPDATE_CUSTOMER_INFO_REG, options);
        var response = await client.post(uri, headers: headers);

        String jsonResponse = response.body;
        Map<String, dynamic> json = jsonDecode(jsonResponse);
        if (json['code'] == 200) {
          return json;
        } else {
          if (kDebugMode) {
            print("error fetching data");
            return json;
          }
        }
      } else {
        if (kDebugMode) {
          print("Auth token not available");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
    return null;
  }

  static customerLoginType(String customerType) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {"lang": "en", "cus_type": customerType};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, CUSTOMER_LOGIN_TYPE, options)
            : Uri.http(ROUTE, CUSTOMER_LOGIN_TYPE, options);

        var response = await client.post(uri, headers: headers);
        String jsonResponse = response.body;
        Map<String, dynamic> json = jsonDecode(jsonResponse);
        if (json['code'] == 200) {
          return json;
        } else {
          if (kDebugMode) {
            print("error fetching data");
          }
        }
      } else {
        if (kDebugMode) {
          print("Auth token not available");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
    return null;
  }

  static getProductsCategoriesList() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {
          "lang": "en",
        };
        bool isProd = is_prod;
        var uri = isProd == true
            // ? Uri.https(ROUTE, GET_CATEGORY_LIST, options)
            // : Uri.http(ROUTE, GET_CATEGORY_LIST, options);
            ? Uri.https(ROUTE, GET_MAIN_PRODUCT_CATEGORY, options)
            : Uri.http(ROUTE, GET_MAIN_PRODUCT_CATEGORY, options);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getSubCategoryList(String id, String mainApi) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {"lang": "en", "pro_main_id": id, "mainApi": mainApi};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, SUB_CATEGORY_PROD, options)
            : Uri.http(ROUTE, SUB_CATEGORY_PROD, options);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future updateProductSelectedByCustomer(List<int> val) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var options = {"lang": "en", "cus_interested_category": "$val"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, UPDATE_CATEGORY_INTERESTS, options)
            : Uri.http(ROUTE, UPDATE_CATEGORY_INTERESTS, options);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        if (responseBody['code'] == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        print("Redirect to login page");
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  static Future googleLogin(userInfo) async {
    var client = http.Client();
    try {
      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      var options = {
        "lang": "en",
        "name": userInfo.displayName,
        "email": userInfo.email,
        "google_id": userInfo.id
      };
      bool isProd = is_prod;
      var uri = isProd == true
          ? Uri.https(ROUTE, GOOGLE_LOGIN, options)
          : Uri.http(ROUTE, GOOGLE_LOGIN, options);
      var response = await client.post(uri, headers: headers);
      var responseBody = json.decode(response.body);
      return responseBody;
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  static Future loginWithEmail(emailInfo) async {
    var client = http.Client();
    try {
      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      var options = {
        "lang": "en",
        "cus_password": emailInfo.password,
        "login_id": emailInfo.email,
      };
      print(options);
      bool isProd = is_prod;
      var uri = isProd == true
          ? Uri.https(ROUTE, EMAIL_LOGIN, options)
          : Uri.http(ROUTE, EMAIL_LOGIN, options);
      var response = await client.post(uri, headers: headers);
      var responseBody = json.decode(response.body);
      print(responseBody);
      return responseBody;
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
    return null;
  }

  static Future userEmailCheck(emailInfo) async {
    var client = http.Client();
    try {
      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      var options = {
        "lang": "en",
        "login_id": emailInfo,
      };
      bool isProd = is_prod;
      var uri = isProd == true
          ? Uri.https(ROUTE, EMAIL_CHECK, options)
          : Uri.http(ROUTE, EMAIL_CHECK, options);
      var response = await client.post(uri, headers: headers);
      var responseBody = json.decode(response.body);
      return responseBody;
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
    return null;
  }

  static Future facebookLogin(facebookUserInfo) async {
    var client = http.Client();
    try {
      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      var options = {
        "lang": "en",
        "name": facebookUserInfo.name,
        "email": facebookUserInfo.email,
        "google_id": facebookUserInfo.facebookId
        // "andr_fcm_id": "android_fcm_id", // Optional
        // "andr_device_id": "android_device_id", // Optional
        // "ios_fcm_id": "ios_fcm_id", // Optional
        // "ios_device_id": "ios_device_id", // Optional
        // "type": "android", // or "ios"
        // "lang": "en" // Language code
      };
      bool isProd = is_prod;
      var uri = isProd == true
          ? Uri.https(ROUTE, GOOGLE_LOGIN, options)
          : Uri.http(ROUTE, GOOGLE_LOGIN, options);
      var res = await client.post(uri, headers: headers);
      // print(res.body);
      return true;
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future getCustomerStoreInfo() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var options = {"lang": "en"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, "Get Store info", options)
            : Uri.http(ROUTE, "Get Store info", options);
        print(uri);
        // var response = await client.post(uri, headers: headers);
        // var responseBody = json.decode(response.body);

        var responseBody = "success";

        return responseBody;
      } else {
        print("Redirect to login page");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future loginSendService(phoneNumber) async {
    var client = http.Client();
    try {
      var options = {
        'cus_phone': phoneNumber,
        'lang': 'en',
        "isSignedIn": 'true'
      };
      bool isProd = is_prod;
      var uri = isProd == true
          ? Uri.https(ROUTE, SEND_OTP_SIGN_IN, options)
          : Uri.http(ROUTE, SEND_OTP_SIGN_IN, options);
      var response = await client.post(uri);
      var responseBody = json.decode(response.body);

      return responseBody;
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
    return null;
  }

  static Future loginVerifyOtp(phoneNumber, enteredOtp, token) async {
    var client = http.Client();
    try {
      var options = {
        "lang": "en",
        "otp": enteredOtp,
        "phone": "+91$phoneNumber",
        "token": token,
      };
      bool isProd = is_prod;
      var uri = isProd == true
          ? Uri.https(ROUTE, VERIFY_OTP_LOGIN, options)
          : Uri.http(ROUTE, VERIFY_OTP_LOGIN, options);
      var response = await client.post(uri);
      var responseBody = json.decode(response.body);

      return responseBody;
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
    return null;
  }

  static Future createStore(StoreInfo storeInfo) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var serverName =
            is_prod == true ? "https://buywithbunny.com/" : "marjins.local";
        var url = '${serverName}api/customer/create_store';

        var request = http.MultipartRequest('POST', Uri.parse(url));

        request.headers['Authorization'] = "Bearer $token";
        request.headers['Content-Type'] = "application/json";
        request.headers['Accept'] = "application/json";
        request.fields['lang'] = "en";
        request.fields['storeName'] = storeInfo.storeName.toString();
        request.fields['st_taxId'] = storeInfo.taxId.toString() ?? "";

        request.fields['store_website'] =
            storeInfo.storeWebsite.toString() ?? "";
        request.fields['cottage_foodLaw'] =
            storeInfo.cottageFoodLaw.toString() ?? "";
        request.fields['active_permit'] =
            storeInfo.activePermit.toString() ?? "";

        request.fields['storeAddress'] = storeInfo.storeAddress;
        request.fields['storeLicenseDocName'] = storeInfo.storeLicenseDocName;
        request.fields['storeProofDocName'] = storeInfo.storeProofDocName;
        request.fields['storeCertificateDocName'] =
            storeInfo.storeCertificateDocName;

        request.fields['deliverRadius'] = storeInfo.deliverRadius;
        request.fields['st_category'] =
            storeInfo.storeCategoryId.toString() == "0"
                ? "1"
                : storeInfo.storeCategoryId.toString();
        request.fields['st_latitude'] = "${storeInfo.storeLatitude}";
        request.fields['st_longitude'] = "${storeInfo.storeLongitude}";

        if (storeInfo.storeLicense.isNotEmpty) {
          var latestLicense = storeInfo.storeLicense.last;
          if (latestLicense != null) {
            request.files.add(await http.MultipartFile.fromPath(
                'store_license', latestLicense.path));
          }
        }
        if (storeInfo.storeProof.isNotEmpty) {
          var latestProof = storeInfo.storeProof.last;
          if (latestProof != null) {
            request.files.add(await http.MultipartFile.fromPath(
                'store_proof', latestProof.path));
          }
        }
        if (storeInfo.storeCertificate.isNotEmpty) {
          var latestCertificate = storeInfo.storeCertificate.last;
          if (latestCertificate != null) {
            request.files.add(await http.MultipartFile.fromPath(
                'store_certificate', latestCertificate.path));
          }
        }

        var response = await request.send();
        if (response.statusCode == 200) {
          print('updated successfully.');
          // Handle successful upload

          return "true";
        } else {
          print('Failed to create store Error: ${response.reasonPhrase}');
          // Handle upload failure

          return "false";
        }
      } else {
        print("unable to create");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      client.close(); // Close the client in a finally block
    }
  }

  static Future updateStore(StoreInfo storeInfo) async {
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var serverName =
            is_prod == true ? "https://buywithbunny.com/" : "marjins.local";
        var url = '${serverName}api/customer/update_store';

        var request = http.MultipartRequest('POST', Uri.parse(url));

        request.headers['Authorization'] = "Bearer $token";
        request.headers['Content-Type'] = "application/json";
        request.headers['Accept'] = "application/json";
        request.fields['lang'] = "en";
        request.fields['storeId'] = storeInfo.storeId.toString();
        request.fields['storeName'] = storeInfo.storeName.toString();
        request.fields['st_taxId'] = storeInfo.taxId.toString() ?? "";
        request.fields['store_website'] =
            storeInfo.storeWebsite.toString() ?? "";
        request.fields['cottage_foodLaw'] =
            storeInfo.cottageFoodLaw.toString() ?? "";
        request.fields['active_permit'] =
            storeInfo.activePermit.toString() ?? "";
        request.fields['storeAddress'] = storeInfo.storeAddress;
        request.fields['storeLicenseDocName'] = storeInfo.storeLicenseDocName;
        request.fields['storeProofDocName'] = storeInfo.storeProofDocName;
        request.fields['storeCertificateDocName'] =
            storeInfo.storeCertificateDocName;
        request.fields['deliverRadius'] = storeInfo.deliverRadius;
        request.fields['st_category'] =
            storeInfo.storeCategoryId.toString() == "0"
                ? "1"
                : storeInfo.storeCategoryId.toString();
        request.fields['st_latitude'] = "${storeInfo.storeLatitude}";
        request.fields['st_longitude'] = "${storeInfo.storeLongitude}";

        if (storeInfo.storeLicense.isNotEmpty) {
          var latestLicense = storeInfo.storeLicense.last;
          if (latestLicense != null) {
            request.files.add(await http.MultipartFile.fromPath(
                'store_license', latestLicense.path));
          }
        } else {
          request.fields['store_license'] = "";
        }
        if (storeInfo.storeProof.isNotEmpty) {
          var latestProof = storeInfo.storeProof.last;
          if (latestProof != null) {
            request.files.add(await http.MultipartFile.fromPath(
                'store_proof', latestProof.path));
          }
        } else {
          request.fields['store_proof'] = "";
        }
        if (storeInfo.storeCertificate.isNotEmpty) {
          var latestCertificate = storeInfo.storeCertificate.last;
          if (latestCertificate != null) {
            request.files.add(await http.MultipartFile.fromPath(
                'store_certificate', latestCertificate.path));
          }
        } else {
          request.fields['store_certificate'] = "";
        }

        var response = await request.send();
        print(response.statusCode);
        if (response.statusCode == 200) {
          print('updated successfully.');
          return "true";
        } else {
          print('Failed to update store Error: ${response.reasonPhrase}');
          // Handle upload failure

          return "false";
        }
      } else {
        print("Unable to update store");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getAllCustomersStoreList() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {
          "lang": "en",
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_CUSTOMER_STORE_LIST, options)
            : Uri.http(ROUTE, GET_CUSTOMER_STORE_LIST, options);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching store list");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future disableStore(String storeId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var options = {
          "lang": "en",
          "storeId": storeId,
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, DISABLE_STORE, options)
            : Uri.http(ROUTE, DISABLE_STORE, options);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("unable to disable store");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future getChoiceList() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var options = {"lang": "en"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_ALL_CHOICES, options)
            : Uri.http(ROUTE, GET_ALL_CHOICES, options);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("unable to disable store");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future createProduct(ProductInfo productInfo) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var finalAiName = ADD_PRODUCT;
        var serverName =
            is_prod == true ? "https://buywithbunny.com" : "marjins.local";
        var url = '$serverName$finalAiName';
        print(url);
        var request = http.MultipartRequest('POST', Uri.parse(url));

        var selectedChoicess = jsonEncode(productInfo.selectedChoices);

        request.headers['Authorization'] = "Bearer $token";
        request.headers['Content-Type'] = "application/json";
        request.headers['Accept'] = "application/json";
        request.fields['lang'] = "en";
        request.fields['pro_store_id'] = productInfo.storeId.toString();
        request.fields['pro_id'] = productInfo.productId.toString();
        request.fields['pro_tags'] = "${productInfo.productLabelIds}";
        request.fields['pro_category_id'] =
            productInfo.productCategoryId.toString();
        request.fields['pro_sub_cat_id'] =
            productInfo.selectedSubProductCategoryID.toString();
        request.fields['pro_item_name'] = productInfo.productName.toString();
        request.fields['productDescription'] = productInfo.productDescription;
        // request.fields['pro_images'] = "${productInfo.productImagesList1}";
        request.fields['selectedChoices'] = selectedChoicess;
        if (productInfo.productImagesList1.isNotEmpty) {
          var latestImage = productInfo.productImagesList1.last;
          if (latestImage != null) {
            request.files.add(await http.MultipartFile.fromPath(
                'pro_images', latestImage.path));
          }
        }

        var response = await request.send();
        if (response.statusCode == 200) {
          print('Product updated successfully.');
          return "true";
        } else {
          print('Failed to create product Error: ${response.reasonPhrase}');
          return "false";
        }
      } else {
        print("unable to create product");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      client.close(); // Close the client in a finally block
    }
  }

  static Future fetchProductItems(Items items) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var options = {
          "lang": "en",
          "main_category_id": items.mainCategoryId.toString(),
          "sub_category_id": items.subCategoryId,
          "search_text": items.searchText != "" ? items.searchText : "",
          "restuarant_id": items.storeId != "" ? items.storeId : "",
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, FETCH_INDIVIDUAL_PRODUCT_ITEMS, options)
            : Uri.http(ROUTE, FETCH_INDIVIDUAL_PRODUCT_ITEMS, options);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("unable to disable store");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future getAllProductsItems(
      String pageNo, String storeId, String? searchValue) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var options = {
          "lang": "en",
          "page_no": pageNo,
          "search_text": searchValue,
          "storeId": storeId,
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_ALL_PRODUCT_ITEMS, options)
            : Uri.http(ROUTE, GET_ALL_PRODUCT_ITEMS, options);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("unable to fetch product items");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future addToCart(
      String productId, String selectedChoiceId, String? quantity) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {
          "lang": "en",
          "choices_id": selectedChoiceId,
          "quantity": quantity.toString(),
          "item_id": productId
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, ADD_TO_CART, options)
            : Uri.http(ROUTE, ADD_TO_CART, options);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);

        return responseBody;
      } else {
        print("unable to add product to cart");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future removeItemFromCart(String cartId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {"lang": "en", "cart_id": cartId};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, REMOVE_TO_CART, options)
            : Uri.http(ROUTE, REMOVE_TO_CART, options);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);

        return responseBody;
      } else {
        print("unable to remove item from cart");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future myCart() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {"lang": "en"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, MY_CART, options)
            : Uri.http(ROUTE, MY_CART, options);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);

        return responseBody;
      } else {
        print("unable to fetch item from cart");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future removeAllItemsFromCart() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {"lang": "en"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, REMOVE_ALL_FROM_CART, options)
            : Uri.http(ROUTE, REMOVE_ALL_FROM_CART, options);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);

        return responseBody;
      } else {
        print("unable to remove all  item from cart");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future addCustomerAddressToShipping(locationUpdate) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {
          "lang": "en",
          "sh_cus_fname": locationUpdate.shCusFname,
          "sh_cus_lname": locationUpdate.shCusLname,
          "sh_cus_email": locationUpdate.shCusEmail,
          "sh_phone1": locationUpdate.shPhone1,
          "sh_phone2": locationUpdate.shPhone2,
          "sh_location": locationUpdate.shLocation,
          "sh_location1": locationUpdate.shLocation1,
          "sh_latitude": locationUpdate.shLatitude,
          "sh_longitude": locationUpdate.shLongitude,
          "sh_zipcode": locationUpdate.shZipcode,
          "landmark": locationUpdate.shLandmark,
          "sh_city": locationUpdate.shCity,
          "sh_state": locationUpdate.shState,
          "sh_country": locationUpdate.shCountry,
          "sh_label": locationUpdate.shLabel,
          "sh_id": locationUpdate.shShipId,
          "sh_default_location": locationUpdate.shDefaultId
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, ADDRESS_CUSTOMER, inputLists)
            : Uri.http(ROUTE, ADDRESS_CUSTOMER, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        print(responseBody);
        return responseBody;
      } else {
        print("unable to remove all  item from cart");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future forgotPassword(String emailId) async {
    var client = http.Client();
    try {
      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      var inputLists = {
        "lang": "en",
        "location": emailId,
      };
      bool isProd = is_prod;
      var uri = isProd == true
          ? Uri.https(ROUTE, FORGOT_PASSWORD, inputLists)
          : Uri.http(ROUTE, FORGOT_PASSWORD, inputLists);
      var response = await client.post(uri, headers: headers);
      var responseBody = json.decode(response.body);

      return responseBody;
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future cartDeliveryDetails() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {"lang": "en"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, CART_DELIVERY_DETAILS, inputLists)
            : Uri.http(ROUTE, CART_DELIVERY_DETAILS, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future customerShipAddress() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {"lang": "en", "new_view": "true"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, CUSTOMER_SHIP_ADDRESS, inputLists)
            : Uri.http(ROUTE, CUSTOMER_SHIP_ADDRESS, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);

        return responseBody;
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getstoreproducts(String storeId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {
          "lang": "en",
          "restaurant_id": storeId.toString(),
          "review_page_no": "1",
          "page_no": "1",
          // "search_text": ""
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_INDIVIDUAL_STORE_DATA, options)
            : Uri.http(ROUTE, GET_INDIVIDUAL_STORE_DATA, options);

        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);

        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future updateCheckoutInfor(
      CheckOutInfo checkoutInfo, String selectedType) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var preorderTye = selectedType == "Delivery" ? "0" : "1";
        var inputListsDelivery = {
          "lang": "en",
          "store_id": checkoutInfo.storeId.toString(),
          "on_demand_status": '1',
          "pre_order_date": checkoutInfo.preOrderDate.toString(),
          "pre_order_status": preorderTye,
          "sh_ship_id": checkoutInfo.shShipId,
        };
        var inputListsPickUp = {
          "lang": "en",
          "store_id": checkoutInfo.storeId.toString(),
          "on_demand_status": '1',
          "pre_order_date": checkoutInfo.preOrderDate.toString(),
          "pre_order_status": preorderTye,
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(
                ROUTE,
                UPDATE_CHECKOUT_INFO,
                selectedType == "Delivery"
                    ? inputListsDelivery
                    : inputListsPickUp)
            : Uri.http(
                ROUTE,
                UPDATE_CHECKOUT_INFO,
                selectedType == "Delivery"
                    ? inputListsDelivery
                    : inputListsPickUp);
        print(uri);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);

        return responseBody;
      } else {
        print("Checkout ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future getCustomerProfileDetail() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();

      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {"lang": "en"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_CUSTOMER_PROFILE_DETAIL, inputLists)
            : Uri.http(ROUTE, GET_CUSTOMER_PROFILE_DETAIL, inputLists);

        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);

        return responseBody;
      } else {
        print("Checkout ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getMyWallet() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {
          "lang": "en",
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, MY_WALLET, options)
            : Uri.http(ROUTE, MY_WALLET, options);

        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        // print(responseBody);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future fetchPaymentDetails() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {"lang": "en"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, PAYMENT, inputLists)
            : Uri.http(ROUTE, PAYMENT, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("PAYMENT FAILED ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future useWallet() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {
          "delivery_fee": "0.00",
          "lang": "en",
          "ord_self_pickup": "0",
          "pro_coupon_list": [],
          "product_list": [],
          "use_wallet": "1",
          "user_coupon_id": ""
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, USE_WALLET, inputLists)
            : Uri.http(ROUTE, USE_WALLET, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);

        return responseBody;
      } else {
        print("use wallet FAILED ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future checkoutAPI(String apiType, String ordSelfPickup,
      String usingWalletForPayment, String walletAmt, String shShipId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {
          "lang": "en",
          "ord_self_pickup": ordSelfPickup.toString(),
          "use_wallet": usingWalletForPayment.toString(),
          "wallet_amt": walletAmt.toString(),
          "sh_id": shShipId.toString(),
          "cus_name": '',
          "cus_last_name": '',
          "cus_phone1": '',
          "cus_email": '',
          "cus_lat": '',
          "cus_address": '',
        };
        String apiName;
        if (apiType == "cod") {
          apiName = COD_CHECKOUT;
        } else if (apiType == "stripe") {
          apiName = STRIPE_CHECKOUT;
        } else {
          apiName = WALLET_CHECKOUT;
        }
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, apiName, inputLists)
            : Uri.http(ROUTE, apiName, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("use wallet FAILED ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future fetchCustomerDetails() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {
          "lang": "en",
        };

        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, USE_WALLET, inputLists)
            : Uri.http(ROUTE, USE_WALLET, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("customer data  ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future updateCustomerDetails() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {
          "lang": "en",
        };

        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, USE_WALLET, inputLists)
            : Uri.http(ROUTE, USE_WALLET, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("customer data  ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future logOut() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {"lang": "en", "token": token};

        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, LOG_OUT, inputLists)
            : Uri.http(ROUTE, LOG_OUT, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("customer data  ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future changePwd(old, new1) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {
          "lang": "en",
          "old_password": old,
          'new_password': new1,
          "token": token
          // "token": token
        };

        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, CHANGE_PASSWORD, inputLists)
            : Uri.http(ROUTE, CHANGE_PASSWORD, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("customer data  ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static fetchCustomerProfie() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {
          "lang": "en",
          // "token": token
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_CUST0MER_PROFILE, inputLists)
            : Uri.http(ROUTE, GET_CUST0MER_PROFILE, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("customer data  ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static updateCustomerProfile(fname, lname, email, pnumber, gender, dob,
      File? selectedImageFile, context) async {
    // var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var serverName =
            is_prod == true ? "https://buywithbunny.com/" : "marjins.local";
        var url = '${serverName}api/customer/update_user_profile';

        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers['Authorization'] = "Bearer $token";
        request.headers['Content-Type'] = "application/json";
        request.headers['Accept'] = "application/json";
        request.fields['lang'] = "en";
        request.fields['cus_fname'] = fname;
        request.fields['cus_lname'] = lname;
        request.fields['cus_email'] = email;
        request.fields['cus_phone'] = pnumber;
        request.fields['cus_gender'] = gender;
        request.fields['cus_dob'] = dob;
        if (selectedImageFile != null) {
          request.files.add(await http.MultipartFile.fromPath(
              'cus_image', selectedImageFile.path));
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          print('updated successfully.');
          // Handle successful upload

          return "true";
        } else {
          print('Failed to upload image. Error: ${response.reasonPhrase}');
          // Handle upload failure

          return "false";
        }
      } else {
        print("customer data  ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future getMerchantAuthCode(String storeId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {"lang": "en", "store_id": storeId};

        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_MERCHANT_AUTH_CODE, inputLists)
            : Uri.http(ROUTE, GET_MERCHANT_AUTH_CODE, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        print(responseBody);
        return responseBody;
      } else {
        print("Merchant login fail");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future merchantAuthCode() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var getMerchantAuth = await Auth.getMerchantAuthCode();
        var headers = {
          "Authorization": "Bearer $getMerchantAuth",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {"lang": "en"};

        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, MERCHANT_DASHBOARD, inputLists)
            : Uri.http(ROUTE, MERCHANT_DASHBOARD, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        print(responseBody);
        return responseBody;
      } else {
        print("Merchant dashboard fail");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future newOrder() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var getMerchantAuth = await Auth.getMerchantAuthCode();
        var headers = {
          "Authorization": "Bearer $getMerchantAuth",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {"lang": "en"};

        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, NEW_ORDER, inputLists)
            : Uri.http(ROUTE, NEW_ORDER, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Merchant dashboard fail");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getCategoriesListForStore() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {
          "lang": "en",
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_CATEGORY_LIST, options)
            : Uri.http(ROUTE, GET_CATEGORY_LIST, options);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getOrderInvoice(String orderTransactionId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var getMerchantAuth = await Auth.getMerchantAuthCode();
        var headers = {
          "Authorization": "Bearer $getMerchantAuth",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {"lang": "en", "order_id": orderTransactionId};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, INVOICE_DETAILS, options)
            : Uri.http(ROUTE, INVOICE_DETAILS, options);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static acceptRejectOrder(OrderOperation order) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var getMerchantAuth = await Auth.getMerchantAuthCode();
        var headers = {
          "Authorization": "Bearer $getMerchantAuth",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var inputs = {
          "lang": "en",
          "transaction_id": order.transactionId,
          "ord_id": "${order.ordId}",
          "status": order.status.toString(),
          "reject_reason": order.rejectReason,
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, ACCEPT_REJECT_ORDER, inputs)
            : Uri.http(ROUTE, ACCEPT_REJECT_ORDER, inputs);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static preparingForDelivery(
      String transactionId, List<int> ordId, String status) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var getMerchantAuth = await Auth.getMerchantAuthCode();
        var headers = {
          "Authorization": "Bearer $getMerchantAuth",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var inputs = {
          "lang": "en",
          "transaction_id": transactionId,
          "ord_id": "$ordId",
          "status": status.toString(),
        };
        print(inputs);
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, CHANGE_ORDER_STATUS, inputs)
            : Uri.http(ROUTE, CHANGE_ORDER_STATUS, inputs);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future processingOrder() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var getMerchantAuth = await Auth.getMerchantAuthCode();
        var headers = {
          "Authorization": "Bearer $getMerchantAuth",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {"lang": "en"};

        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, PROCESSING_ORDER, inputLists)
            : Uri.http(ROUTE, PROCESSING_ORDER, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Merchant dashboard fail");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future preparingOrder() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var getMerchantAuth = await Auth.getMerchantAuthCode();
        var headers = {
          "Authorization": "Bearer $getMerchantAuth",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputLists = {"lang": "en"};

        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, PREPARING_ORDER, inputLists)
            : Uri.http(ROUTE, PREPARING_ORDER, inputLists);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Merchant dashboard fail");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getDeliveryBoys() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getMerchantAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {
          "lang": "en",
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, ALL_DELIVERY_BOYS, options)
            : Uri.http(ROUTE, ALL_DELIVERY_BOYS, options);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getStoreVehicle(String orderTransactionId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getMerchantAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {"lang": "en", "order_id": orderTransactionId.toString()};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_STORE_VEHICLE, options)
            : Uri.http(ROUTE, GET_STORE_VEHICLE, options);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static assignDeliveryBoy(String delboyId, String orderId, String delManagerId,
      String vehicleId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getMerchantAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {
          "lang": "en",
          "delboy_id": delboyId.toString(),
          "order_id": orderId.toString(),
          "del_manager_id": delManagerId.toString(),
          "ord_vehicle_id": vehicleId.toString()
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, ASSIGN_DELIVERY_BOY, options)
            : Uri.http(ROUTE, ASSIGN_DELIVERY_BOY, options);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getOrderHistory() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {
          "lang": "en",
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, MY_ORDER_HISTORY, options)
            : Uri.http(ROUTE, MY_ORDER_HISTORY, options);

        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static fetchBankDetails() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {"lang": "en"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_BANK_ACCOUNT_DETAILS, options)
            : Uri.http(ROUTE, GET_BANK_ACCOUNT_DETAILS, options);

        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);

        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static updateBankDetailsAPI(List sellerDetails) async {
    String sellerAccountName =
        sellerDetails[0]['seller_account_name'].toString();
    String sellerAccountNumber =
        sellerDetails[0]['seller_account_number'].toString();
    String achWireTransferRouting =
        sellerDetails[0]['ach_wire_transfer_routing'].toString();
    String swiftCode = sellerDetails[0]['swift_code'].toString();
    String branchName = sellerDetails[0]['branch_name'].toString();
    String city = sellerDetails[0]['city'].toString();
    String state = sellerDetails[0]['state'].toString();
    String areaCode = sellerDetails[0]['area_code'].toString();

    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {
          "lang": "en",
          "seller_account_name": sellerAccountName,
          "seller_account_number": sellerAccountNumber,
          "ach_wire_transfer_routing": achWireTransferRouting,
          "swift_code": swiftCode,
          "branch_name": branchName,
          "city": city,
          "state": state,
          "area_code": areaCode
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, UPDATE_BANK_ACCOUNT_DETAILS, options)
            : Uri.http(ROUTE, UPDATE_BANK_ACCOUNT_DETAILS, options);

        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);

        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static createPaymentIntentBunny(String amount, String currency) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        double dollarAmount = double.parse(amount);
        int paiseAmount = (dollarAmount * 100).toInt();

        var options = {
          "lang": "en",
          "amount": paiseAmount.toString(),
          "currency": currency
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, STRIPE_INITIAL_INTENT, options)
            : Uri.http(ROUTE, STRIPE_INITIAL_INTENT, options);

        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error in login");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static stripePaymentStatus() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {"lang": "en"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, STRIPE_TRANSACTION_STATUS, options)
            : Uri.http(ROUTE, STRIPE_TRANSACTION_STATUS, options);

        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);

        return responseBody;
      } else {
        print("Error ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getProductDetails(String productId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {"lang": "en", "item_id": productId.toString()};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_INDIVIDUAL_PRODUCT_DETAIL, options)
            : Uri.http(ROUTE, GET_INDIVIDUAL_PRODUCT_DETAIL, options);

        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);

        return responseBody;
      } else {
        print("Error ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getProductLabels() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };

        var options = {"lang": "en"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_ALL_PRODUCT_LABELS, options)
            : Uri.http(ROUTE, GET_ALL_PRODUCT_LABELS, options);

        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);

        return responseBody;
      } else {
        print("Error ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getOrdetDetails(String orderId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        print(orderId);
        var options = {"lang": "en", "order_id": orderId.toString()};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_ORDER_DETAIL, options)
            : Uri.http(ROUTE, GET_ORDER_DETAIL, options);

        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static cancelOrder(String id, String rejectReason, String type) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var finalApi = type == '0' ? CANCEL_SINGLE_ORDER : CANCEL_ENTIRE_ORDER;
        var idd = type == '0' ? 'orderId' : 'order_id';
        var inputs = {
          "lang": "en",
          idd: id,
          "reason": rejectReason,
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, finalApi, inputs)
            : Uri.http(ROUTE, finalApi, inputs);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static setAndUnSetFavorite(String productId, String selectedChoiceId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputs = {
          "lang": "en",
          "product_id": productId,
          "choice_id": selectedChoiceId,
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, SET_FAVORITE, inputs)
            : Uri.http(ROUTE, SET_FAVORITE, inputs);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static fetchFavouriteProducts() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputs = {"lang": "en"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_ALL_FAVORITE, inputs)
            : Uri.http(ROUTE, GET_ALL_FAVORITE, inputs);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getAllCustomerMessages() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputs = {"lang": "en"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_ALL_CUSTOMER_CHATS, inputs)
            : Uri.http(ROUTE, GET_ALL_CUSTOMER_CHATS, inputs);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getIndividualChatMessges(String chatId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputs = {"lang": "en", "chat_id": chatId.toString(), "page": "1"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_MESSAGES_FROM_CHAT_ID, inputs)
            : Uri.http(ROUTE, GET_MESSAGES_FROM_CHAT_ID, inputs);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static sendMsgFromCusToSeller(String storeId, String message) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputs = {
          "lang": "en",
          "store_id": storeId.toString(),
          "message": message.toString()
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, SEND_MSG_FROM_CUSTOMER, inputs)
            : Uri.http(ROUTE, SEND_MSG_FROM_CUSTOMER, inputs);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getAllSellerMessages() async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var getMerchantAuth = await Auth.getMerchantAuthCode();
        var headers = {
          "Authorization": "Bearer $getMerchantAuth",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputs = {"lang": "en"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_ALL_STORE_CHATS, inputs)
            : Uri.http(ROUTE, GET_ALL_STORE_CHATS, inputs);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getIndividualCustomerChat(String chatId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var getMerchantAuth = await Auth.getMerchantAuthCode();
        var headers = {
          "Authorization": "Bearer $getMerchantAuth",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputs = {"lang": "en", "chat_id": chatId.toString(), "page": "1"};
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, GET_STORE_MESSAGES_FROM_CHAT_ID, inputs)
            : Uri.http(ROUTE, GET_STORE_MESSAGES_FROM_CHAT_ID, inputs);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static sendMsgToCustomer(String cusId, String cusName, String message) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var getMerchantAuth = await Auth.getMerchantAuthCode();
        var headers = {
          "Authorization": "Bearer $getMerchantAuth",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputs = {
          "lang": "en",
          "message": message.toString(),
          "cus_id": cusId.toString(),
          "cus_name": cusName.toString(),
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, SEND_MSG_REPLY_TO_CUSTOMER, inputs)
            : Uri.http(ROUTE, SEND_MSG_REPLY_TO_CUSTOMER, inputs);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static updateChatFlagFromCustomer(String chatId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var token = await Auth.getAuthCode();
        var headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputs = {
          "lang": "en",
          "chat_id": chatId.toString(),
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, UPDATE_FLAG_FROM_CUSTOMER, inputs)
            : Uri.http(ROUTE, UPDATE_FLAG_FROM_CUSTOMER, inputs);
        var response = await client.post(uri, headers: headers);

        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static updateChatFlagFromSeller(String chatId) async {
    var client = http.Client();
    try {
      bool isAuthAvailable = await Auth.isAuthExpired();
      if (isAuthAvailable == true) {
        var getMerchantAuth = await Auth.getMerchantAuthCode();
        var headers = {
          "Authorization": "Bearer $getMerchantAuth",
          "Content-Type": "application/json",
          "Accept": "application/json"
        };
        var inputs = {
          "lang": "en",
          "chat_id": chatId.toString(),
        };
        bool isProd = is_prod;
        var uri = isProd == true
            ? Uri.https(ROUTE, UPDATE_FLAG_FROM_SELLER, inputs)
            : Uri.http(ROUTE, UPDATE_FLAG_FROM_SELLER, inputs);
        var response = await client.post(uri, headers: headers);
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print("Error fetching categories");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
