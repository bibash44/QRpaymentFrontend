import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qr_pay/Auth/google_auth_service.dart';
import 'package:qr_pay/provider/google_sign_in.dart';
import 'package:qr_pay/screens/homepage.dart';
import 'package:qr_pay/screens/signin.dart';
import 'package:qr_pay/screens/signup.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

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
        home: GoogleAuthService().handleAuthService());
  }
}

// ignore: must_be_immutable
