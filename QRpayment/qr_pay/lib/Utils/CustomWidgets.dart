// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_pay/Utils/ExternalFunctions.dart';

class CustomWidgets {
  Widget linkTosignInWithGoogle(context) {
    return Align(
      alignment: Alignment.topLeft,
      child: InkWell(
        child: const Text(
          "Click here to sign in with google ",
          style: TextStyle(color: Colors.blue, fontSize: 12),
        ),
        onTap: () async {
          ExternalFunctions().signInWithGoogleAndRedirectToHomePage(context);
        },
      ),
    );
  }
}
