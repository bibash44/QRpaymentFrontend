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

  Future sendEmail(String email, String subject, String description) async {
    var requestBody = jsonEncode({
      "email": email,
      "subject": subject,
      "description": description,
    });

    try {
      http.Response response = await http.post(
          Uri.parse('${url}user/sendemail'),
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

  Future updateUser(String userid, var requestBody) async {
    try {
      http.Response response = await http.put(Uri.parse('${url}user/$userid'),
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

  Future getUserData(String userid) async {
    try {
      http.Response response = await http.get(Uri.parse('${url}user/$userid'),
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
