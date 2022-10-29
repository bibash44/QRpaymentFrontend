import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_pay/screens/dynamic_dr.dart';
import 'package:qr_pay/screens/qr_scan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/userAPI.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool? isUserLoggedIn;
  String fullname = "";
  double totalAmount = 0.0;

  // ignore: non_constant_identifier_names
  _HomepageState() {
    // getUserLoggedInStatus();
    retriveLoggedInUserDatFromServer();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [walletCard(), userFunctions()],
        ),
      ),
    );
  }

  retriveLoggedInUserDatFromServer() async {
    SharedPreferences sharedPreferenceUserData =
        await SharedPreferences.getInstance();

    String? userid = sharedPreferenceUserData.getString("_id");

    // print("USERIDFORWALLETINFORMATION " + userid!);

    var responseData = await UserApi().getUserData(userid!);

    bool responseStatus = responseData['success'];
    if (responseStatus == true) {
      var userData = responseData['data'];
      // ignore: no_leading_underscores_for_local_identifiers
      String _fullname = userData['fullname'];
      double _totalamount = userData['totalamount'].toDouble();

      setState(() {
        fullname = _fullname;
        totalAmount = _totalamount;
      });
      // ignore: use_build_context_synchronously

    } else if (responseStatus == false) {}
  }

  Widget walletCard() {
    return Container(
      width: double.infinity,
      height: 180,
      child: Card(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Your wallet ",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        if (totalAmount.toString().length >= 6)
                          Text(
                            "£${totalAmount.toString().replaceRange(6, totalAmount.toString().length, "")}",
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          )
                        else
                          Text(
                            "£${totalAmount.toString()}",
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        const Text("Balance",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        generateColorizedNameImage(),
                        SizedBox(height: 15),
                        // ignore: prefer_interpolation_to_compose_strings
                        Text(fullname,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget generateColorizedNameImage() {
    if (fullname == null || fullname == "") {
      fullname = "XXX";
    }
    bool googleuser = false;
    if (FirebaseAuth.instance.currentUser != null) {
      googleuser = true;
    }
    return GestureDetector(
      onTap: () {
        // print(vaccinationCentreList[index].id);
      },
      child: GestureDetector(
        onTap: () {},
        child: googleuser
            ? CircleAvatar(
                radius: 30, // Image radius
                backgroundImage:
                    NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
              )
            : Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)]),
                child: Text(
                  fullname[0],
                  style: const TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
      ),
    );
  }

  Widget userFunctions() {
    return Container(
      width: double.infinity,
      height: 180,
      child: Card(
          child: Padding(
        padding: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QRScan()));
                    },
                    child: Column(
                      children: const [
                        Icon(Icons.qr_code_2_sharp,
                            size: 35, color: Colors.green),
                        Text("QR scan",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DynamicQr()));
                    },
                    child: Column(
                      children: const [
                        Icon(Icons.qr_code, size: 35, color: Colors.green),
                        Text("Dynamic QR",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
