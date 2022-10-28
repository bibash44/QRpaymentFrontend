// ignore: file_names
import 'dart:math';

import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qr_pay/Utils/ExternalFunctions.dart';

import '../services/userAPI.dart';

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

  Widget generateColorizedNameImage(context, sendername) {
    if (sendername == null || sendername == "") {
      sendername = "XXX";
    }
    bool googleuser = false;
    if (FirebaseAuth.instance.currentUser != null) {
      googleuser = true;
    }
    return GestureDetector(
      onTap: () {
        // print(vaccinationCentreList[index].id);
      },
      child: GestureDetector(
        onTap: () {},
        child: googleuser
            ? CircleAvatar(
                radius: 30, // Image radius
                backgroundImage:
                    NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
              )
            : Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)]),
                child: Text(
                  sendername[0],
                  style: const TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
      ),
    );
  }
}
