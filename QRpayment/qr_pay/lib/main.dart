import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:qr_pay/Auth/google_auth_service.dart';

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
