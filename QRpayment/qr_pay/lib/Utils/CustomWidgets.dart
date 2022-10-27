// ignore: file_names
import 'dart:math';

import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qr_pay/Utils/ExternalFunctions.dart';

import '../services/userAPI.dart';

class CustomWidgets {
  String? fullname;
  int? totalAmount;

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

  Widget paymentDetailsCard(qId, qrFullname, qrAmount, context) {
    return Container(
      width: double.infinity,
      height: 200,
      child: Card(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Recipient details",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const Divider(
                color: Colors.grey,
              ),
              Text("£$qrAmount",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(qrFullname,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("QR ID : $qId",
                  style: const TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 20),
              const Text(
                  "Note : Once the payment has been made, it can be reverted back, please send only to the person you know ",
                  style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 186, 186, 186),
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      )),
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
