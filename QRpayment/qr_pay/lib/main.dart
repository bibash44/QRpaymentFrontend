import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:qr_pay/Auth/google_auth_service.dart';
import 'package:qr_pay/Utils/ExternalFunctions.dart';
import 'package:qr_pay/screens/navigation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int primaryColor = 0xFFCF2027;

  bool isUserLoggedIn = false;
  String userType = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'QRpay',
        theme: ThemeData(
            primaryColor: Color(primaryColor),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: Color(primaryColor))),
        home: GoogleAuthService().handleAuthService());
  }
}

// ignore: must_be_immutable
