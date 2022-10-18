import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRpay',
      theme: ThemeData(primaryColor: Color(0x00CF2027)),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'images/QRpay.png',
                    fit: BoxFit.cover,
                    width: 75,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {},
                      icon: Tab(
                          icon: Image.asset(
                        "images/google.png",
                        fit: BoxFit.fitHeight,
                      )),
                      label: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Signin with google",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(10),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)))),
                    ),
                  ),
                  const SizedBox(height: 15),
                  actionButtons("Login to continue", Icons.login, Colors.white,
                      Colors.black, Colors.white),
                  const SizedBox(height: 15),
                  actionButtons(
                      "Signup as new user",
                      FontAwesomeIcons.userCircle,
                      Colors.white,
                      Colors.red,
                      Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget actionButtons(btnLabel, btnIcon, iconColor, btnColor, textColor) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {},
        icon: FaIcon(btnIcon, size: 30),
        label: Align(
          alignment: Alignment.center,
          child: Text(
            btnLabel,
            style: TextStyle(fontSize: 18, color: textColor),
          ),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            padding: const EdgeInsets.all(20),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)))),
      ),
    );
  }
}
