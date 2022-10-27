import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'BASEURL.dart';

class UserApi {
  final url = BASEURL().setBASEURL();
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future signUpUser(String fullname, String email, String phonenumber,
      String address, String password) async {
    var requestBody = jsonEncode({
      "fullname": fullname,
      "email": email,
      "phonenumber": phonenumber,
      "address": address,
      "password": password,
    });

    try {
      http.Response response = await http.post(Uri.parse('${url}user'),
          body: requestBody, headers: requestHeaders);

      if (response.statusCode == 200) {
        String responseData = response.body;
        var jsonDeocedResponse = jsonDecode(responseData);

        return jsonDeocedResponse;
      } else {}
    } catch (e) {
      var responseData = {
        'msg': '$e Error connecting to internet ',
        'success': false
      };
      print(e);

      return responseData;
    }
  }

  Future signInUser(String email, password) async {
    if (email.contains("@gmail.com")) {
      password = null;
    }

    var requestBody = jsonEncode({"email": email, "password": password});

    try {
      http.Response response = await http.post(Uri.parse('${url}user/signin'),
          body: requestBody, headers: requestHeaders);

      if (response.statusCode == 200) {
        String responseData = response.body;
        var jsonDeocedResponse = jsonDecode(responseData);

        return jsonDeocedResponse;
      } else {}
    } catch (e) {
      var responseData = {
        'msg': '$e Error connecting to internet ',
        'success': false
      };
      print(e);

      return responseData;
    }
  }

  Future verifyQrData(String receipentid, String senderid) async {
    var requestBody =
        jsonEncode({"receipentid": receipentid, "senderid": senderid});

    try {
      http.Response response = await http.post(
          Uri.parse('${url}user/verifyqrdata'),
          body: requestBody,
          headers: requestHeaders);

      if (response.statusCode == 200) {
        String responseData = response.body;
        var jsonDeocedResponse = jsonDecode(responseData);

        return jsonDeocedResponse;
      } else {}
    } catch (e) {
      var responseData = {
        'msg': '$e Error connecting to internet ',
        'success': false
      };
      print(e);

      return responseData;
    }
  }

  Future signInOrSignUpGoogleUser(String email, String fullname) async {
    var requestBody = jsonEncode({"email": email, "fullname": fullname});

    try {
      http.Response response = await http.post(
          Uri.parse('${url}user/signinorsignupgoogleuser'),
          body: requestBody,
          headers: requestHeaders);

      if (response.statusCode == 200) {
        String responseData = response.body;
        var jsonDeocedResponse = jsonDecode(responseData);

        return jsonDeocedResponse;
      } else {}
    } catch (e) {
      var responseData = {
        'msg': '$e Error connecting to internet ',
        'success': false
      };
      print(e);

      return responseData;
    }
  }
}
