import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/userAPI.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int primaryColor = 0xFFCF2027;
  bool? isUserLoggedIn;
  String userid = "";
  String fullname = "";
  String address = "";
  String phonenumber = "";
  String email = "";
  bool emailverified = false;
  int verificationCode = 0;
  bool showVerificationForm = false;
  bool showActionButtons = true;
  TextEditingController emailVerificationController =
      new TextEditingController();

  _ProfileState() {
    retriveLoggedInUserDatFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 320,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: generateColorizedNameImage(),
                      ),
                      const SizedBox(height: 10),
                      emailverified
                          ? const Center(
                              child: Icon(
                                FontAwesomeIcons.solidCheckCircle,
                                color: Colors.green,
                              ),
                            )
                          : const Center(
                              child: Text(
                                "Not verified",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                      const SizedBox(height: 5),
                      userdetails(),
                    ],
                  ),
                ),
              )),
            ),
          ),
          showActionButtons ? actionButtons() : Container(),
          showVerificationForm ? emailVerificationForm() : Container()
        ],
      ),
    );
  }

  retriveLoggedInUserDatFromServer() async {
    SharedPreferences sharedPreferenceUserData =
        await SharedPreferences.getInstance();

    String? _userid = sharedPreferenceUserData.getString("_id");

    var responseData = await UserApi().getUserData(_userid!);

    bool responseStatus = responseData['success'];
    if (responseStatus == true) {
      var userData = responseData['data'];
      // ignore: no_leading_underscores_for_local_identifiers

      String _fullname = userData['fullname'];
      String _phonenumber = userData['phonenumber'];
      String _email = userData['email'];
      String _address = userData['address'];
      bool _emailverified = userData['emailverified'];

      setState(() {
        fullname = _fullname;
        phonenumber = _phonenumber;
        email = _email;
        address = _address;
        emailverified = _emailverified;
        userid = _userid;
      });
    } else if (responseStatus == false) {}
  }

  sentVerificationCode() async {
    int _verificationCode = Random().nextInt(999999);
    setState(() {
      verificationCode = _verificationCode;
    });
    var subject = "Email verification";
    var description = "Your verification code is $verificationCode";

    try {
      var resposeData = await UserApi().sendEmail(email, subject, description);

      bool responseStatus = resposeData['success'];
      if (responseStatus == true) {
        setState(() {
          showActionButtons = false;
          showVerificationForm = true;
        });
        Fluttertoast.showToast(
            msg: resposeData['msg'],
            gravity: ToastGravity.CENTER_LEFT,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 13.0);
      } else if (responseStatus == false) {
        Fluttertoast.showToast(
            msg: resposeData['msg'],
            gravity: ToastGravity.CENTER_LEFT,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 13.0);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          gravity: ToastGravity.CENTER_LEFT,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 13.0);
    }
  }

  verifyEmail() async {
    var userInputCode = emailVerificationController.text;

    if (verificationCode.toString() != userInputCode) {
      Fluttertoast.showToast(
          msg: "Code didnot match , please try again",
          gravity: ToastGravity.CENTER_LEFT,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 13.0);
    } else {
      bool emailVerifiedSuccessfully = true;

      var requestBody = jsonEncode({
        "emailverified": emailVerifiedSuccessfully,
      });

      try {
        // verify email
        var resposeData = await UserApi().updateUser(userid, requestBody);

        bool responseStatus = resposeData['success'];
        if (responseStatus == true) {
          setState(() {
            showActionButtons = true;
            showVerificationForm = false;
            emailverified = true;
          });
          Fluttertoast.showToast(
              msg: "Email verified",
              gravity: ToastGravity.CENTER_LEFT,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 13.0);
        } else if (responseStatus == false) {
          Fluttertoast.showToast(
              msg: resposeData['msg'],
              gravity: ToastGravity.CENTER_LEFT,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 13.0);
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: e.toString(),
            gravity: ToastGravity.CENTER_LEFT,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 13.0);
      }
    }
  }

  Widget generateColorizedNameImage() {
    if (fullname == null || fullname == "") {
      fullname = "XXX";
    }

    if (email == null || email == "") {
      email = "XXX";
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
                  fullname[0],
                  style: const TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
      ),
    );
  }

  Widget userdetails() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              const Icon(FontAwesomeIcons.user),
              const SizedBox(width: 15),
              Text(fullname,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              const Icon(FontAwesomeIcons.envelope),
              const SizedBox(width: 15),
              Text(email,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              const Icon(FontAwesomeIcons.mobileAlt),
              const SizedBox(width: 15),
              if (phonenumber.isEmpty)
                InkWell(
                    child: const Text(
                      "Phone number found, click here to update ",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 15,
                          fontStyle: FontStyle.italic),
                    ),
                    onTap: () {})
              else
                Text(phonenumber,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              const Icon(FontAwesomeIcons.mapMarkerAlt),
              const SizedBox(width: 15),
              if (address.isEmpty)
                InkWell(
                    child: const Text(
                      "Address not found, click here to update",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 15,
                          fontStyle: FontStyle.italic),
                    ),
                    onTap: () {})
              else
                Text(address,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget actionButtons() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const FaIcon(Icons.edit_sharp, size: 25),
                label: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Edit profile",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.all(20),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),
            ),
            const SizedBox(height: 15),
            emailverified
                ? Container()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        sentVerificationCode();
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.envelope,
                        size: 25,
                        color: Colors.black,
                      ),
                      label: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Verify email",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(20),
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget emailVerificationForm() {
    return Container(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: emailVerificationController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: "Enter verification code",
                    labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                    iconColor: Colors.black,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 192, 192, 192))),
                    filled: true,
                    fillColor: Color.fromARGB(255, 230, 230, 230)),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    verifyEmail();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(primaryColor),
                      padding: const EdgeInsets.all(20),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Verify",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      showActionButtons = true;
                      showVerificationForm = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.all(20),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
