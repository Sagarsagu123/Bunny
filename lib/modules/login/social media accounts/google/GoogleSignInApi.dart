import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static const _clientIdWeb =
      "65589676700-3i59gjg60b7dvter0mjb2dfjsrbutj5j.apps.googleusercontent.com";

  static final _googleSignIn = GoogleSignIn(clientId: _clientIdWeb);

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future<GoogleSignInAccount?> logout() => _googleSignIn.disconnect();
}
