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
    int primaryColor = 0xFFCF2027;
    return MaterialApp(
      title: 'QRpay',
      theme: ThemeData(primaryColor: Color(primaryColor)),
      home: Scaffold(
        backgroundColor: Color(primaryColor),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'images/QR2.png',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {},
                      icon: Tab(
                          icon: Image.asset(
                        "images/google.png",
                        width: 30,
                        fit: BoxFit.fitHeight,
                      )),
                      label: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Sign-in with google",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(10),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                  ),
                  const SizedBox(height: 15),
                  actionButtons("Sign-in to continue", Icons.login,
                      Colors.white, Colors.black, Colors.white),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {},
                      icon: const FaIcon(
                        FontAwesomeIcons.userAlt,
                        size: 25,
                        color: Colors.white,
                      ),
                      label: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Signup as new user",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(primaryColor),
                          padding: const EdgeInsets.all(20),
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                  ),
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
        icon: FaIcon(btnIcon, size: 25),
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
                borderRadius: BorderRadius.all(Radius.circular(15)))),
      ),
    );
  }
}
