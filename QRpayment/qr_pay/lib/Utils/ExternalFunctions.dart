// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_pay/screens/navigation_page.dart';
import 'package:qr_pay/screens/landing.dart';
import 'package:qr_pay/services/userAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../Auth/google_auth_service.dart';

class ExternalFunctions {
  var uuid = const Uuid();
  String _sessionToken = "326412";
  List placesList = [];
  var sharedPreferenceUserData;

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
        var responseData = await UserApi().signInOrSignUpGoogleUser(
            FirebaseAuth.instance.currentUser!.email!,
            FirebaseAuth.instance.currentUser!.displayName!);

        // print("Response data " + responseData['data'].toString());

        bool responseStatus = responseData['success'];

        if (responseStatus == true) {
          var userData = responseData['data'];

          String _id = userData['_id'];
          String _fullname = userData['fullname'];
          String _email = userData['email'];
          String _phonenumber = userData['phonenumber'];
          String _address = userData['address'];
          int _totalamount = userData['totalamount'];
          String _usertype = "google";

          print("totalamount" + _totalamount.toString());

          await saveUserDataAfterLogin(
              _id, _fullname, _email, _phonenumber, _address, _totalamount);
          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NavigationPage()));
        } else if (responseStatus == false) {}
      } catch (e) {}

      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const NavigationPage();
        },
      ));
    }
  }

  signoutUserFromTheSystem() async {}

  signoutUser(context) async {
    sharedPreferenceUserData = await SharedPreferences.getInstance();

    sharedPreferenceUserData.clear();
    sharedPreferenceUserData.setBool("_isUserLoggedIn", false);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LandingPage()));
  }

  saveUserDataAfterLogin(
      _id, _fullname, _email, _phonenumber, _address, _totalamount) async {
    sharedPreferenceUserData = await SharedPreferences.getInstance();

    // // print("name " + _fullname);
    // print("sachikeisaving $_fullname $_id $_email");

    sharedPreferenceUserData.setString("_id", _id);
    sharedPreferenceUserData.setString("_fullname", _fullname);
    sharedPreferenceUserData.setString("_email", _email);
    sharedPreferenceUserData.setString("_phone", _phonenumber);
    sharedPreferenceUserData.setString("_address", _address);
    sharedPreferenceUserData.setString("_totalamount", _totalamount);
    sharedPreferenceUserData.setBool("_isUserLoggedIn", true);
  }

  getUserLoggedInId() async {
    sharedPreferenceUserData = await SharedPreferences.getInstance();

    String? id = sharedPreferenceUserData.getString("_id");
    return id;
  }

  getUserLoggedInFullname() async {
    sharedPreferenceUserData = await SharedPreferences.getInstance();

    String? fullname = sharedPreferenceUserData.getString("_fullname");
    return fullname;
  }

  getUserLoggedInEmail() async {
    sharedPreferenceUserData = await SharedPreferences.getInstance();

    String? email = sharedPreferenceUserData.getString("_email");
    return email;
  }

  getUserLoggedInPhonenumber() async {
    sharedPreferenceUserData = await SharedPreferences.getInstance();

    String? phonenumber = sharedPreferenceUserData.getString("_phonenumber");
    return phonenumber;
  }

  getUserLoggedInAddress() async {
    sharedPreferenceUserData = await SharedPreferences.getInstance();

    String? address = sharedPreferenceUserData.getString("_address");
    return address;
  }

  getUserLoggedInUsertype() async {
    sharedPreferenceUserData = await SharedPreferences.getInstance();

    String? usertype = sharedPreferenceUserData.getString("_usertype");
    return usertype;
  }

  getLoggedInUserStatus() async {
    sharedPreferenceUserData = await SharedPreferences.getInstance();

    bool? isUserLoggedIn = sharedPreferenceUserData.getBool("_isUserLoggedIn");
    return isUserLoggedIn;
  }
}
