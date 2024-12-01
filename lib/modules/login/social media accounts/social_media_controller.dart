import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class SocialMediaLoginController extends GetxController {
  static const _clientIdWeb =
      "834606012591-0rm83ade8junsfbhd566ujjaus6btbiq.apps.googleusercontent.com";

  final GoogleSignIn _googleSignIn = GoogleSignIn(serverClientId: _clientIdWeb);

  // GoogleSignInAccount? _googleSignInAccount;

  // GoogleSignInAccount? get googleSignInAccount => _googleSignInAccount;

  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   clientId:
  //       "834606012591-0rm83ade8junsfbhd566ujjaus6btbiq.apps.googleusercontent.com", // Replace with your actual Client ID
  //   scopes: ['email'],
  // );

  // Future<dynamic>? googleSignIn() async {
  //   final GoogleSignInAccount? googleSignInAccount =
  //       await GoogleSignIn().signIn();

  //   print('Enterrrrr');
  //   if (googleSignInAccount != null) {
  //     print('User nnngned in: $googleSignInAccount');
  //     // User signed in, you can access user details via googleSignInAccount
  //     print('User signed in: ${googleSignInAccount.displayName}');
  //   } else {
  //     // User canceled the sign-in process.
  //     print('User canceled sign-in');
  //   }
  //   return null;
  // }

  Future<void> handleSignIn() async {
    try {
      print("sss");
      await _googleSignIn.signIn();
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  Future<void> getUserInfo() async {
    try {
      if (_googleSignIn.currentUser != null) {
        final user = _googleSignIn.currentUser!;
        print('Display Name: ${user.displayName}');
        print('Email: ${user.email}');
        print('ID: ${user.id}');
      } else {
        print('User is not signed in.');
      }
    } catch (error) {
      print('Error fetching user info: $error');
    }
  }
}
