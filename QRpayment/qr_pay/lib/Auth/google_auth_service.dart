import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qr_pay/screens/navigation_page.dart';
import 'package:qr_pay/screens/landing.dart';

class GoogleAuthService {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  handleAuthService() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const NavigationPage();
          } else {
            return const LandingPage();
          }
        });
  }

  signInWithGoogle() async {
    // Trigger the auth flow

    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final userSignedInWIthCredentail =
          FirebaseAuth.instance.signInWithCredential(credential);

      return userSignedInWIthCredentail;
    } on Exception {
      // print(e);
    }
  }

  googleSignOut() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
