// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_pay/screens/homepage.dart';
import 'package:qr_pay/services/userAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../Auth/google_auth_service.dart';

class ExternalFunctions {
  var uuid = const Uuid();
  String _sessionToken = "326412";
  List placesList = [];

  Future getPlacesSuggestionAPI(String query) async {
    _sessionToken = uuid.v4();

    String placeApiKey = "AIzaSyB2Q4az6sbEyA5MZuqKlnoMw_2ZwkSJ_GY";
    String baseUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request =
        '$baseUrl?input=$query&key=$placeApiKey&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      placesList = jsonDecode(response.body.toString())["predictions"];
      return placesList;
    } else {
      throw Exception("Failed to load places");
    }
  }

  signInWithGoogleAndRedirectToHomePage(context) async {
    await GoogleAuthService().signInWithGoogle();
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        var responseData = await UserApi().updateOrsignInWIthGoogle(
            FirebaseAuth.instance.currentUser!.email!,
            FirebaseAuth.instance.currentUser!.displayName!,
            "",
            "");

        bool responseStatus = responseData['success'];
        if (responseStatus == true) {
          var userData = responseData['data'];
          String _id = userData['_id'];
          String _fullname = userData['fullname'];
          String _email = userData['email'];
          String _phonenumber = userData['phonenumber'];
          String _address = userData['address'];

          ExternalFunctions()
              .saveUserData(_id, _fullname, _email, _phonenumber, _address);
          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Homepage()));
        } else if (responseStatus == false) {}
      } catch (e) {}

      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const Homepage();
        },
      ));
    }
  }

  logoutUserFromTheSystem() async {}

  saveUserData(_id, _fullname, _email, _phonenumber, _address) async {
    final sharedPreferenceUserData = await SharedPreferences.getInstance();

    sharedPreferenceUserData.setString("_id", _id);
    sharedPreferenceUserData.setString("_fullname", _fullname);
    sharedPreferenceUserData.setString("_email", _email);
    sharedPreferenceUserData.setString("_phone", _phonenumber);
    sharedPreferenceUserData.setString("_dob", _address);
    sharedPreferenceUserData.setBool("_isUserLoggedIn", true);
  }

  getUserLoggedInStatus(context) async {
    final sharedPreferenceUserData = await SharedPreferences.getInstance();

    bool? isUserLoggedIn = sharedPreferenceUserData.getBool("_isUserLoggedIn");

    if (isUserLoggedIn == true) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ));
    }
  }
}
