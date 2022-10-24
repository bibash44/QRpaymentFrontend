import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_pay/Auth/google_auth_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int primaryColor = 0xFFCF2027;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: Color(primaryColor))),
        home: Scaffold(
            backgroundColor: Color(primaryColor),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Text(FirebaseAuth.instance.currentUser!.displayName!),
                  Image.network(FirebaseAuth.instance.currentUser!.photoURL!),
                  Text(FirebaseAuth.instance.currentUser!.email!),
                  ElevatedButton(
                      onPressed: () {
                        GoogleAuthService().googleSignOut();
                      },
                      child: const Text("Logout"))
                ],
              ),
            )));
  }
}
