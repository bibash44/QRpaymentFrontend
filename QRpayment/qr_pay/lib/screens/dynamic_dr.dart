import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_pay/screens/navigation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicQr extends StatefulWidget {
  const DynamicQr({super.key});

  @override
  State<DynamicQr> createState() => _DynamicQrState();
}

class _DynamicQrState extends State<DynamicQr> {
  int primaryColor = 0xFFCF2027;
  String? senderId, fullname, email, phonenumber, address;
  double amount = 0;
  final dynamicQRForm = GlobalKey<FormState>();
  TextEditingController qrAmountInputController = new TextEditingController();
  @override
  void initState() {
    getAndSetLoggedInUserDetails();
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
            title: const Text(
              "Dynamic QR",
            ),
            leading: BackButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NavigationPage()));
            })),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("YOUR DYNAMIC QR CODE",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  if (fullname != null && senderId != null && amount >= 0.1)
                    generateQRCode()
                  else
                    Column(
                      children: const [
                        Text(
                          "Unable to load QR code",
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(height: 10),
                        SpinKitCubeGrid(
                          color: Colors.black,
                          size: 250,
                        )
                      ],
                    ),
                  const SizedBox(height: 15),
                  Text(
                      "Other users would pay you £$amount while scanning this code",
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic)),
                  const SizedBox(height: 50),
                  Form(
                    key: dynamicQRForm,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: qrAmountInputController,
                          validator: (value) {
                            double calcValue = double.parse(value!);
                            if (value.isEmpty) {
                              return "Please enter amount *";
                            } else if (!RegExp(
                                    r'^\d{1,5}$|(?=^.{1,5}$)^\d+\.\d{0,3}$')
                                .hasMatch(value)) {
                              return "Please enter a valid amount *";
                            } else if (calcValue <= 0.1) {
                              return "Amount must be more than 0.1";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          onSaved: (newValue) {
                            if (newValue!.isEmpty) return;
                            amount = double.parse(newValue);
                          },
                          onChanged: (newValue) {
                            if (newValue == "" || amount <= 0 || amount == "") {
                              setState(() {
                                amount = 0.0;
                              });
                            }

                            dynamicQRForm.currentState!.save();
                            if (dynamicQRForm.currentState!.validate()) {
                              setState(() {
                                amount = double.parse(newValue);
                              });
                              generateQRCode();
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

                        // Payment button
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget generateQRCode() {
    var data = {
      "_id": senderId,
      "fullname": fullname,
      "amount": amount,
      "dynamic": true
    };
    return QrImage(data: jsonEncode(data), size: 250);
  }

  getAndSetLoggedInUserDetails() async {
    SharedPreferences sharedPreferenceUserData =
        await SharedPreferences.getInstance();

    String? _fullname = sharedPreferenceUserData.getString("_fullname");
    String? _id = sharedPreferenceUserData.getString("_id");

    setState(() {
      fullname = _fullname;
      senderId = _id;
    });
  }
}
