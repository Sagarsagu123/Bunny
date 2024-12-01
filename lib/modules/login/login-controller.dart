// ignore_for_file: file_names, use_build_context_synchronously, duplicate_ignore

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/auth.dart';
import 'package:flutter_demo/modules/dialog_utils.dart';
import 'package:flutter_demo/modules/login/location/customGoogleMap.dart';
import 'package:flutter_demo/modules/login/social%20media%20accounts/google/GoogleSignInApi.dart';
import 'package:flutter_demo/services/api_services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LoginController extends GetxController {
  TextEditingController phonenumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController tokenController = TextEditingController();

  TextEditingController entercodeController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  TextEditingController areaCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  Rx<bool> isShowPassword = true.obs;

  final TextEditingController displayFirstNameController =
      TextEditingController();
  final TextEditingController displayLastNameController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  TextEditingController passwordoneController = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController forgotPasswordController = TextEditingController();

  Rx<bool> isShowPassword1 = true.obs;

  // **
  // login throuh email or OTP options
  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passworForEmailLoginControllerN =
      TextEditingController();

  TextEditingController phonenumberLoginController = TextEditingController();
  TextEditingController mobileNumberLoginController = TextEditingController();

  TextEditingController entercodeLoginController = TextEditingController();

  TextEditingController currentUserName = TextEditingController();
  TextEditingController currentUserId = TextEditingController();
  bool displayFirstSection = true;
  // ****/

  TextEditingController loginTokenController = TextEditingController();
  bool isPaswordMatched = false;
  bool ispnumberEntered11 = false;
  bool enableContinueButton = false;
  bool isLoginVerificationCodeEntered = false;
  bool isloginVerificationCodeEnteredLogin = false;
  String? loginSendOtpSuccessMsg;
  String? loginVerifyOtpSuccessMsg;
  String? loginSendOtpSuccessMsgnew;

  String? sendOtpSuccessMsg;
  bool isPhonenumberEntered = false;
  bool isverificationcoderecived = false;
  bool isVerificationCodeEntered = false;
  List selectedIds = [];
  bool isDisplayF = false;
  bool isDisplayL = false;

  bool isEmailValid1 = false;
  bool isEmailValid11 = false;
  bool ispassword = false;
  bool isCpassword = false;
  String customerType = 'buyer';
  bool enableDoneButton = false;
  bool passwordVisible = false;

  // login new

  TextEditingController emailLoginControllerN = TextEditingController();
  TextEditingController phonenumberLoginControllerN = TextEditingController();
  bool currentLoginTypeEmail = false;
  String displayPasswordAndNextButton = '';

  String displayOnlyEmail = '';
  String displayOnlyotp = '';
  bool enableLoginButton = false;
  // use these for all validation from API
  bool displayErrorMsg = false;
  String errorMsg = '';

  bool disableSubmit = false;
  final FocusNode focusNodeDisplayFirstname = FocusNode();
  final FocusNode focusNodeDisplayLastname = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeTypePassword = FocusNode();
  final FocusNode focusNodeReenterPassword = FocusNode();

  LatLng selectedLocation = const LatLng(12.3362056, 76.5850493);

  bool displayErr = false;
  String errMsg = '';
  bool loadingPageGoogle = false;
  //  add address

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone1 = TextEditingController();
  TextEditingController phone2 = TextEditingController();
  TextEditingController locationController1 = TextEditingController();
  TextEditingController locationController2 = TextEditingController();
  TextEditingController zipcode = TextEditingController();
  TextEditingController landmark = TextEditingController();
  String selectedCountryCode = '+91';

  bool switchValue = false;
  int selectedAddressTypeValue = 1;

  Future<void> sendOtp(text, selectedCountryCode, context) async {
    var jsonData = await ApiService.sendOtp(text, selectedCountryCode);
    if (jsonData != null) {
      if (jsonData["code"] == 400) {
        sendOtpSuccessMsg = jsonData['message'];

        update();
      } else if (jsonData != null && jsonData["code"] == 200) {
        tokenController.text = jsonData['data']['token'];
        Get.toNamed('/loginReg-verification');
        isPhonenumberEntered = false;

        update();
      }
    }
  }

  Future<void> verifyOtp(context, selectedCountryCode) async {
    var jsonData = await ApiService.verifyOtp(phonenumberController.text,
        entercodeController.text, tokenController.text, selectedCountryCode);
    var displayMessage = '';
    if (jsonData['code'] == 200) {
      displayMessage = jsonData['message'];
      var authToken = jsonData['data']['token'];
      Auth.setAuthCode(authToken);
      Auth.setLoginDetail(true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(displayMessage),
      ));
      Get.toNamed('/loginReg-userDetails');
      entercodeController.clear();
      isVerificationCodeEntered = false;
      update();
    } else {
      displayErr = true;
      errMsg = jsonData['message'];
      displayMessage = jsonData['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(displayMessage),
      ));
      update();
    }
  }

  Future updateUserInfo(BuildContext context) async {
    final userInfo = UserInfo(
      displayFirstName: displayFirstNameController.text.trim(),
      displayLastName: displayLastNameController.text.trim(),
      confirmPassword: passwordoneController.text,
      email: emailController.text,
    );
    var response = await ApiService.updateUserInfoWhileRegistering(userInfo);
    if (response != null &&
        response["data"] != null &&
        response['code'] == 200) {
      Map<String, dynamic> data = response["data"];

      String cusFname = data["cus_fname"];
      String cusId = data["cus_id"].toString();

      Auth.setUserName(cusFname);
      Auth.setUserId(cusId);
      displayFirstNameController.clear();
      displayLastNameController.clear();
      passwordoneController.clear();
      emailController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CustomGoogleMap(
            isEdit: false,
            setDefault: true,
            routeTo: "intrested",
            routeFrom: "",
            customerAddress: {},
          ),
        ),
      );

      return true;
    } else if (response['code'] == 400 || response['code'] == 500) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['message']),
      ));
      return false;
    }
  }

  void phoneNumberEntered() {
    sendOtpSuccessMsg = null;
    if (phonenumberController.text.isNotEmpty &&
        phonenumberController.text.length == 10) {
      isPhonenumberEntered = true;
    } else {
      isPhonenumberEntered = false;
    }
    update();
  }

  void verificationCodeEntered() {
    isVerificationCodeEntered = true;
    if (entercodeController.text.isEmpty) {
      disableSubmit = true;
    } else {
      disableSubmit = false;
    }
    displayErr = false;
    update();
  }

  void onEnteringVerificaionCode() {
    isloginVerificationCodeEnteredLogin = true;
    update();
  }

  acceptTermsAndCondition() async {}

  getMainCategoriesList() async {
    var jsonData = await ApiService.getProductsCategoriesList();
    return jsonData;
  }

  getSubCategoryProducts(String id) async {
    var jsonData = await ApiService.getSubCategoryList(id.toString(), 'false');
    return jsonData;
  }

  void toggleLoginOption(int val) {
    if (val == 1) {
      displayFirstSection = true;
    } else {
      displayFirstSection = false;
    }
    update();
  }

  void displayF() {
    if (displayFirstNameController.text.isEmpty ||
        displayFirstNameController.text == '') {
      isDisplayF = true;
    } else {
      isDisplayF = false;
    }
    update();
  }

  void displayL() {
    if (displayLastNameController.text.isEmpty ||
        displayLastNameController.text == '') {
      isDisplayL = true;
    } else {
      isDisplayL = false;
    }
    update();
  }

  void emailValidation() {
    if (emailController.text.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(emailController.text)) {
      isEmailValid1 = true;
    } else {
      isEmailValid1 = false;
    }
    update();
  }

  void password1() {
    passwordoneController.clear();

    if (passwordController.text.isEmpty ||
        passwordController.text == '' ||
        !RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,}$')
            .hasMatch(passwordController.text)) {
      ispassword = true;
    } else {
      ispassword = false;
    }
    update();
  }

  void confirmPassword() {
    if (passwordController.text == passwordoneController.text &&
        passwordoneController.text.isNotEmpty) {
      isCpassword = true;
    } else {
      isCpassword = false;
    }
    update();
  }

  Future<void> customerLoginType(String val, BuildContext context) async {
    customerType = val;
    var response = await ApiService.customerLoginType(customerType);
    Map<String, dynamic> data = response["data"];
    var msg = response["message"];

    if (msg != '') {
      const snackBar = SnackBar(
        content: Text('Profile updated successfully'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Get.toNamed('/customerProductInterests',
        arguments: {'fromDashboard': 'false'});
  }

  Future<String?> getUserNameFromSession() async {
    var cusName = await Auth.getUserName();
    var cusId = await Auth.getUserId();
    currentUserName.text = cusName!;
    currentUserId.text = cusId!;
    update();
    return null;
  }

  Future loginWithEmail(BuildContext context, String val) async {
    String passwordB;
    String emailB;
    if (val == "nandeesh") {
      emailB = "nandeesh@clinconsent.com";
      // emailB = "yadhu@clinconsent.com";
      // emailB = "pradeep@marjins.com";
      // emailB = "starla@healios.co";
      // emailB = "maryvimala27@gmail.com";

      passwordB = '123456';

      // passwordB = 'Happy@123';
    } else if (val == "sagar") {
      emailB = "Sagar18zzz@gmail.com";
      passwordB = '123456';
    } else {
      emailB = emailLoginControllerN.text;
      passwordB = passworForEmailLoginControllerN.text;
    }

    final userEmailInfo = EmailLogin(
      password: passwordB,
      email: emailB,
    );

    var jsonData = await ApiService.loginWithEmail(userEmailInfo);
    print(jsonData);
    var displayMessage = '';
    if (jsonData['data'] != null && jsonData['code'] == 200) {
      var authToken = jsonData['data']['token'];
      var cusFname = jsonData['data']['user_name'];
      var cusId = jsonData['data']['user_id'];
      Auth.setAuthCode(authToken);
      Auth.setLoginDetail(true);
      Auth.setUserName(cusFname);
      Auth.setUserId(cusId.toString());

      displayErrorMsg = false;
      Get.toNamed('/dashboard');
      return false;
    } else {
      errorMsg = jsonData['message'];
      displayMessage = jsonData['message'];
      update();
      return true;
    }
  }

  Future userEmailCheck(BuildContext context) async {
    var jsonData = await ApiService.userEmailCheck(emailLoginControllerN.text);
    var displayMessage = '';
    if (jsonData['data'] != null && jsonData['code'] == 200) {
      return true;
    } else {
      displayMessage = jsonData['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(displayMessage),
      ));
      return false;
    }
  }

  Future<void> googleLogin(context, userInfo) async {
    try {
      _showLogoutDialog(context);
      var jsonData = await ApiService.googleLogin(userInfo);
      await GoogleSignInApi.logout();
      loadingPageGoogle = false;
      var displayMessage = '';
      if (jsonData['data'] != null && jsonData['code'] == 200) {
        displayMessage = jsonData['message'];
        var authToken = jsonData['data']['token'];
        var cusFname = jsonData['data']['user_name'];
        var cusId = jsonData['data']['user_id'].toString();
        Auth.setAuthCode(authToken);
        Auth.setLoginDetail(true);
        Auth.setUserName(cusFname);
        Auth.setUserId(cusId.toString());

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(displayMessage),
        ));
        if (jsonData['hasAddress'] == false ||
            jsonData['hasAddress'] == 'false') {
          Get.to(() => CustomGoogleMap(
                isEdit: false,
                setDefault: true,
                routeTo: jsonData['hasInterestedCategories'] == true
                    ? "dashboard"
                    : "intrested",
                routeFrom: "googleLogin",
                customerAddress: const {},
              ));
        } else {
          if (jsonData['hasInterestedCategories'] == true) {
            Get.toNamed('/dashboard');
          } else {
            Get.toNamed('/customerProductInterests',
                arguments: {'fromDashboard': 'false'});
          }
        }
      } else {
        loadingPageGoogle = false;
        displayMessage = jsonData['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(displayMessage),
        ));
      }
      loadingPageGoogle = false;
      update();
    } catch (error) {
      print("Error during Google login: $error");
      return; // Return null in case of an error
    }
    return;
  }

  _showLogoutDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 150.0,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (loadingPageGoogle == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/bunny_Logo11.png",
                        width: 150,
                        height: 60,
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 5,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xffAF6CDA)),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Logging in...",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> facebookLogin(facebookUserInfo) async {
    bool val = await ApiService.facebookLogin(facebookUserInfo);

    await FacebookAuth.instance.logOut();
    Get.toNamed('/customerProductInterests',
        arguments: {'fromDashboard': 'false'});
    return val;
  }

  createStore() {
    // Get.toNamed('/storeRegistrationPage');
    Get.toNamed('/storeDashboardIndividual');
  }

  Future<String> loginSendOtp(text, context) async {
    var jsonData = await ApiService.loginSendService(text);
    if (jsonData['code'] == 400 || jsonData['resp'] == -1) {
      loginSendOtpSuccessMsg = jsonData['message'];
      // ispnumberEntered = false;
      update();
      return 'true';
    } else {
      loginTokenController.text = jsonData['data']['token'];
      isverificationcoderecived = true;
      update();
      return 'false';
    }
  }

  // Future<void> loginVerifyOtp(context) async {
  //   var jsonData = await ApiService.loginVerifyOtp(
  //       phonenumberLoginController.text,
  //       entercodeLoginController.text,
  //       loginTokenController.text);

  //   var displayMessage = '';
  //   if (jsonData['data'] != null && jsonData['code'] == 200) {
  //     displayMessage = jsonData['message'];
  //     var authToken = jsonData['data']['token'];
  //     Auth.setAuthCode(authToken);
  //     Auth.setLoginDetail(true);
  //     phonenumberLoginController.clear();
  //     entercodeLoginController.clear();
  //     isverificationcoderecived = false;

  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(displayMessage),
  //     ));
  //     Get.toNamed('/dashboard');
  //   } else {
  //     displayMessage = jsonData['message'];
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(displayMessage),
  //     ));
  //   }
  //   update();
  // }

  Future loginVerifyOtp(context, mobileNumber, otp, token) async {
    var jsonData = await ApiService.loginVerifyOtp(mobileNumber, otp, token);

    return jsonData;
  }

  Future mobileNumberzOtp(text, context) async {
    var jsonData = await ApiService.loginSendService(text);

    return jsonData;
  }

  void onEnteredEmail(text) {
    passworForEmailLoginControllerN.clear();
    if (text.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(text)) {
      isEmailValid11 = true;
      update();
    } else {
      isEmailValid11 = false;
      update();
      if (isEmailValid11 == false) {
        phonenumberLoginControllerN.clear();
        passworForEmailLoginControllerN.clear();
        currentLoginTypeEmail = true;
      }
    }
  }

  void onEnteredPhoneNumber() {
    loginSendOtpSuccessMsg = null;
    emailLoginControllerN.clear();
    currentLoginTypeEmail = false;
    update();
  }

  onClickNextButton(BuildContext context) async {
    bool val = await userEmailCheck(context);
    if (val == false) {
      if (kDebugMode) {
        print("email not registored");
      }
    } else {
      if (currentLoginTypeEmail == true) {
        displayOnlyEmail = 'yes';
        displayOnlyotp = 'no';
        displayPasswordAndNextButton = 'email';
        update();
      } else {
        var val = await loginSendOtp(phonenumberLoginControllerN.text, context);
        if (val != 'true') {
          displayOnlyEmail = 'no';
          displayOnlyotp = 'yes';
          displayPasswordAndNextButton = 'otp';
          update();
        }
      }
    }
  }

  void onEnteredPassword() {
    enableLoginButton = true;
    update();
  }

  void onClickLogIn() {
    loginSendOtpSuccessMsg = '';
    displayOnlyEmail = '';
    displayOnlyotp = '';
    displayPasswordAndNextButton = '';
    emailLoginControllerN.clear();
    currentLoginTypeEmail = false;
    phonenumberLoginControllerN.clear();
    passworForEmailLoginControllerN.clear();
    enableLoginButton = false;
    isShowPassword1 = true.obs;
    entercodeLoginController.clear();
    isEmailValid11 = false;
    update();
    // Get.toNamed('/login2');
    Get.toNamed('/loginPage');
    // Get.toNamed('/checkout');
  }

  Future forgotPassword() async {
    var jsonData = await ApiService.forgotPassword(
      forgotPasswordController.text,
    );
    displayErrorMsg = false;
    if (jsonData['data'] != null && jsonData['code'] == 200) {
    } else {
      displayErrorMsg = true;
      errorMsg = jsonData['message'];
    }
    update();
    return true;
  }

  Future updateInitialLatLog(
    LatLng latLng,
  ) async {
    selectedLocation = latLng;
    update();
  }

  getstoreproducts(String storeId) async {
    var jsonData = await ApiService.getstoreproducts(storeId);

    return jsonData;
  }

  Future addCustomerAddressToShipping(
      BuildContext context,
      String shShipId,
      routeTo,
      bool fromGoogle,
      String routeFrom,
      String navigateAfterSuccess) async {
    var shShipIdInput = shShipId == '' ? '' : shShipId;
    final locationUpdate = LocationCheckOutPage(
        lang: "en",
        shCusFname: firstName.text != '' ? firstName.text : "",
        shCusLname: routeFrom == "googleLogin"
            ? ""
            : lastName.text.isEmpty == true
                ? ""
                : lastName.text,
        shCusEmail: email.text,
        shPhone1: routeFrom == "googleLogin" ? phone2.text : phone1.text,
        shPhone2: phone2.text,
        shLocation: locationController1.text,
        shLocation1: locationController2.text,
        shLatitude: selectedLocation.latitude.toString(),
        shLongitude: selectedLocation.longitude.toString(),
        shZipcode: zipcode.text,
        shLandmark: landmark.text,
        shShipId: shShipIdInput,
        shCity: cityController.text,
        shState: stateController.text,
        shCountry: countryController.text,
        shLabel: "$selectedAddressTypeValue",
        shDefaultId: "$switchValue");
    // shDefaultId: fromGoogle == true ? "$switchValue" : "0");
    var jsonData =
        await ApiService.addCustomerAddressToShipping(locationUpdate);
    if (jsonData != null && jsonData['code'] == 400) {
      showCustomDialog("Error", jsonData['message'], context, true);
    } else {
      streetNameController.clear();
      locationController.clear();
      areaCodeController.clear();
      addressController.clear();
      // add address

      firstName.clear();
      lastName.clear();
      email.clear();
      phone1.clear();
      phone2.clear();
      locationController1.clear();
      locationController2.clear();
      zipcode.clear();
      landmark.clear();
      cityController.clear();
      stateController.clear();
      countryController.clear();
      if (navigateAfterSuccess == "checkout") {
        Get.back();
      } else {
        if (routeTo == "intrested") {
          Get.toNamed('/customerProductInterests',
              arguments: {'fromDashboard': 'false'});
        } else {
          Get.offAndToNamed('/dashboard');
        }
      }
    }
  }

  getMyWallet() async {
    var jsonData = await ApiService.getMyWallet();
    return jsonData;
  }

  getAddress() async {
    var jsonData = await ApiService.customerShipAddress();
    return jsonData;
  }

  getOrderHistory() async {
    var jsonData = await ApiService.getOrderHistory();
    return jsonData;
  }
}

class LocationCheckOutPage {
  String shCusFname;
  String shCusLname;
  String shCusEmail;
  String shPhone1;
  String shPhone2;
  String shLocation;
  String shLocation1;
  String shLatitude;
  String shLongitude;
  String shZipcode;
  String lang;
  String shLandmark;
  String shShipId;
  String shCity;
  String shState;
  String shCountry;
  String shDefaultId;
  String shLabel;

  LocationCheckOutPage({
    required this.shCusFname,
    required this.shCusLname,
    required this.shCusEmail,
    required this.shPhone1,
    required this.shPhone2,
    required this.shLocation,
    required this.shLocation1,
    required this.shLatitude,
    required this.shLongitude,
    required this.shZipcode,
    required this.lang,
    required this.shLandmark,
    required this.shShipId,
    required this.shCity,
    required this.shState,
    required this.shCountry,
    required this.shDefaultId,
    required this.shLabel,
  });
}

class LocationData {
  final String lang;
  final String location;
  final String address;
  final String searchLatitude;
  final String searchLongitude;
  final String zipcode;
  final String shLabel;
  final String shCustomLabel;

  LocationData({
    required this.lang,
    required this.location,
    required this.address,
    required this.searchLatitude,
    required this.searchLongitude,
    required this.zipcode,
    required this.shLabel,
    required this.shCustomLabel,
  });
}

class UserInfo {
  final String displayFirstName;
  final String displayLastName;
  final String confirmPassword;
  final String email;

  UserInfo({
    required this.displayFirstName,
    required this.displayLastName,
    required this.confirmPassword,
    required this.email,
  });
}

class EmailLogin {
  final String password;
  final String email;

  EmailLogin({required this.email, required this.password});
}
