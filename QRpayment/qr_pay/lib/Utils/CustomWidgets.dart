// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Auth/google_auth_service.dart';
import '../screens/homepage.dart';

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
          await GoogleAuthService().signInWithGoogle();
          if (FirebaseAuth.instance.currentUser!.displayName != null &&
              FirebaseAuth.instance.currentUser!.email != null) {
            // ignore: use_build_context_synchronously
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const Homepage();
              },
            ));
          }
        },
      ),
    );
  }
}
