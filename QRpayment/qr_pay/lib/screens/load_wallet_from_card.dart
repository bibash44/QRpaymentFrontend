import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:qr_pay/screens/navigation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/userAPI.dart';

class LoadWalletFromCard extends StatefulWidget {
  const LoadWalletFromCard({super.key});

  @override
  State<LoadWalletFromCard> createState() => _LoadWalletFromCardState();
}

class _LoadWalletFromCardState extends State<LoadWalletFromCard> {
  int primaryColor = 0xFFCF2027;
  final loadWalletFormKey = GlobalKey<FormState>();
  String? cardName, cardNumber, cardSecurityCode, userid;
  double amount = 0;
  bool isLoading = false;

  @override
  void initState() {
    retriveLoggedInUserDatFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: Color(primaryColor))),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Load wallet"),
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NavigationPage()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              height: 500,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: loadWalletFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter name on card *";
                            } else if (!RegExp(
                                    r'^([A-Za-z]{1,16})([ ]{0,1})([A-Za-z]{1,16})?([ ]{0,1})?([A-Za-z]{1,16})?([ ]{0,1})?([A-Za-z]{1,16})')
                                .hasMatch(value)) {
                              return "Please enter a valid name *";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          onSaved: (newValue) => cardName = newValue,
                          onChanged: (newValue) {
                            loadWalletFormKey.currentState!.save();
                            if (loadWalletFormKey.currentState!.validate()) {
                            } else {}
                          },
                          decoration: const InputDecoration(
                              labelText: "Name on card",
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              prefixIcon: Icon(FontAwesomeIcons.user),
                              iconColor: Colors.black,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 192, 192, 192))),
                              filled: true,
                              fillColor: Color.fromARGB(255, 230, 230, 230)),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter card number *";
                            } else if (!RegExp(r'^[0-9]{16}$')
                                .hasMatch(value)) {
                              return "Please enter a valid card number *";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          onSaved: (newValue) => cardNumber = newValue,
                          onChanged: (newValue) {
                            loadWalletFormKey.currentState!.save();
                            if (loadWalletFormKey.currentState!.validate()) {
                            } else {}
                          },
                          decoration: const InputDecoration(
                              labelText: "16 digit card number",
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              prefixIcon: Icon(FontAwesomeIcons.creditCard),
                              iconColor: Colors.black,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 192, 192, 192))),
                              filled: true,
                              fillColor: Color.fromARGB(255, 230, 230, 230)),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter security code *";
                            } else if (!RegExp(r'^[0-9]{3}$').hasMatch(value)) {
                              return "Please enter 3 digit code *";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          onSaved: (newValue) => cardNumber = newValue,
                          onChanged: (newValue) {
                            loadWalletFormKey.currentState!.save();
                            if (loadWalletFormKey.currentState!.validate()) {
                            } else {}
                          },
                          decoration: const InputDecoration(
                              labelText: "CVV",
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              prefixIcon: Icon(Icons.numbers_sharp),
                              iconColor: Colors.black,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 192, 192, 192))),
                              filled: true,
                              fillColor: Color.fromARGB(255, 230, 230, 230)),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter amount *";
                            } else if (!RegExp(
                                    r'^\d{1,5}$|(?=^.{1,5}$)^\d+\.\d{0,3}$')
                                .hasMatch(value)) {
                              return "Please enter a valid amount *";
                            } else if (double.parse(value!) <= 0.1) {
                              return "Amount must be more than 0.1";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          onSaved: (newValue) {
                            if (newValue!.isEmpty || newValue == null) {
                              setState(() {
                                amount = 0.0;
                              });
                            } else {
                              setState(() {
                                amount = double.parse(newValue);
                              });
                            }
                          },
                          onChanged: (newValue) {
                            if (newValue.isEmpty || newValue == null) {
                              setState(() {
                                amount = 0.0;
                              });
                            } else {
                              setState(() {
                                amount = double.parse(newValue);
                              });
                            }

                            loadWalletFormKey.currentState!.save();
                            if (loadWalletFormKey.currentState!.validate()) {
                            } else {}
                          },
                          decoration: const InputDecoration(
                              labelText: "Amount",
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              iconColor: Colors.black,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 192, 192, 192))),
                              filled: true,
                              fillColor: Color.fromARGB(255, 230, 230, 230)),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: isLoading
                              ? const SpinKitCircle(color: Colors.black)
                              : ElevatedButton(
                                  onPressed: () async {
                                    if (loadWalletFormKey.currentState!
                                        .validate()) {
                                      loadWalletFormKey.currentState!.save();
                                      setState(() {
                                        isLoading = true;
                                      });

                                      loadWallet();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(primaryColor),
                                      padding: const EdgeInsets.all(20),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)))),
                                  child: const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Confirm and load",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      )),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  loadWallet() async {
    var requestBody = jsonEncode({
      "totalamount": amount,
    });

    try {
      // load wallet
      var resposeData = await UserApi().updateUser(userid!, requestBody);

      bool responseStatus = resposeData['success'];
      if (responseStatus == true) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: resposeData['msg'],
            gravity: ToastGravity.CENTER_LEFT,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 13.0);

        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NavigationPage()));
      } else if (responseStatus == false) {
        Fluttertoast.showToast(
            msg: resposeData['msg'],
            gravity: ToastGravity.CENTER_LEFT,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 13.0);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          gravity: ToastGravity.CENTER_LEFT,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 13.0);
    }
  }

  retriveLoggedInUserDatFromServer() async {
    SharedPreferences sharedPreferenceUserData =
        await SharedPreferences.getInstance();

    String? _userid = sharedPreferenceUserData.getString("_id");

    setState(() {
      userid = _userid;
    });
  }
}
