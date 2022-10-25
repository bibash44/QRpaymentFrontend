import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_pay/Auth/google_auth_service.dart';
import 'package:qr_pay/Utils/ExternalFunctions.dart';
import 'package:qr_pay/screens/navigation_page.dart';
import 'package:qr_pay/screens/signin.dart';
import 'package:qr_pay/screens/signup.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});
  int primaryColor = 0xFFCF2027;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'QRpay',
        theme: ThemeData(
            primaryColor: Color(primaryColor),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: Color(primaryColor))),
        home: const LandingPage());
  }
}

// ignore: must_be_immutable
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int primaryColor = 0xFFCF2027;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // GoogleAuthService().handleAuthService(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ExternalFunctions()
                          .signInWithGoogleAndRedirectToHomePage(context);
                    },
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signin()));
                    },
                    icon: const FaIcon(Icons.login, size: 25),
                    label: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Sign-in to continue",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.all(20),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signup()));
                    },
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
    );
  }
}
