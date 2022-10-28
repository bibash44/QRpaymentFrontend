import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'BASEURL.dart';

class TransactionApi {
  final url = BASEURL().setBASEURL();
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future makeTranscation(sender, recipient, amount, remarks) async {
    var requestBody = jsonEncode({
      "sender": sender,
      "recipient": recipient,
      "amount": amount,
      "remarks": remarks
    });

    try {
      http.Response response = await http.post(Uri.parse('${url}transaction'),
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

  Future getTransactionData(String transactionid) async {
    try {
      http.Response response = await http.get(
          Uri.parse('${url}transaction/$transactionid'),
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
          Uri.parse('${url}transaction/verifyqrdata'),
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

  Future signInOrSignUpGoogleTransaction(String email, String fullname) async {
    var requestBody = jsonEncode({"email": email, "fullname": fullname});

    try {
      http.Response response = await http.post(
          Uri.parse('${url}transaction/signinorsignupgoogletransaction'),
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
