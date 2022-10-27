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

  Widget paymentDetailsCard(qId, qrFullname, qrAmount, context) {
    return Container(
      width: double.infinity,
      height: 180,
      child: Card(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("£$qrAmount",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Text(qrFullname,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Text("QR ID : $qId",
                  style: const TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 25),
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
}
