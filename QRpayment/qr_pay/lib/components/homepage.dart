import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_pay/screens/dynamic_qr.dart';
import 'package:qr_pay/screens/load_wallet_from_card.dart';
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
  bool isWalletDataLoading = true;

  // ignore: non_constant_identifier_names
  _HomepageState() {
    // getUserLoggedInStatus();
    retriveLoggedInUserDatFromServer();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [walletCard(), userFunctions(), widgetFutureWork()],
          ),
        ),
      ),
    );
  }

  retriveLoggedInUserDatFromServer() async {
    SharedPreferences sharedPreferenceUserData =
        await SharedPreferences.getInstance();

    String? userid = sharedPreferenceUserData.getString("_id");

    String? _token = sharedPreferenceUserData.getString("_token");

    var responseData = await UserApi().getUserData(userid!);

    bool responseStatus = responseData['success'];
    if (responseStatus == true) {
      setState(() {
        isWalletDataLoading = false;
      });
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
      child: isWalletDataLoading
          ? const SpinKitThreeBounce(color: Colors.black, size: 50)
          : Card(
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
                              if (totalAmount.toString().length >= 5)
                                Text(
                                  "£${totalAmount.toString().replaceRange(5, totalAmount.toString().length, "")}",
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                )
                              else
                                Text(
                                  "£${totalAmount.toString()}",
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                              const Text("Balance",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          Column(
                            children: [
                              generateColorizedNameImage(),
                              SizedBox(height: 15),
                              // ignore: prefer_interpolation_to_compose_strings
                              Text(fullname,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
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
      height: 110,
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
                        SizedBox(height: 5),
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
                        SizedBox(height: 5),
                        Text("Dynamic QR",
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
                              builder: (context) =>
                                  const LoadWalletFromCard()));
                    },
                    child: Column(
                      children: const [
                        Icon(FontAwesomeIcons.creditCard,
                            size: 35, color: Colors.green),
                        SizedBox(height: 5),
                        Text("Load wallet ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget widgetFutureWork() {
    return Container(
      width: double.infinity,
      height: 420,
      child: Card(
          child: Padding(
        padding: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Future work for in app merchant payments",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const Divider(
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      showInformTiveMessage();
                    },
                    child: Column(
                      children: const [
                        Icon(FontAwesomeIcons.moneyBillAlt,
                            size: 35, color: Colors.green),
                        Text("Apply Credit",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showInformTiveMessage();
                    },
                    child: Column(
                      children: const [
                        Icon(FontAwesomeIcons.landmark,
                            size: 35, color: Colors.green),
                        SizedBox(height: 5),
                        Text("Bank transfer",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showInformTiveMessage();
                    },
                    child: Column(
                      children: const [
                        Icon(FontAwesomeIcons.landmark,
                            size: 35, color: Colors.green),
                        SizedBox(height: 5),
                        Text("Load wallet ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      showInformTiveMessage();
                    },
                    child: Column(
                      children: const [
                        Icon(FontAwesomeIcons.lightbulb,
                            size: 35, color: Colors.green),
                        SizedBox(height: 5),
                        Text("Electricity bill",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showInformTiveMessage();
                    },
                    child: Column(
                      children: const [
                        Icon(FontAwesomeIcons.shower,
                            size: 35, color: Colors.green),
                        SizedBox(height: 5),
                        Text("Water bill",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showInformTiveMessage();
                    },
                    child: Column(
                      children: const [
                        Icon(FontAwesomeIcons.wifi,
                            size: 35, color: Colors.green),
                        SizedBox(height: 5),
                        Text("Internet bill ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      showInformTiveMessage();
                    },
                    child: Column(
                      children: const [
                        Icon(FontAwesomeIcons.bus,
                            size: 35, color: Colors.green),
                        SizedBox(height: 5),
                        Text("Bus ticket ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showInformTiveMessage();
                    },
                    child: Column(
                      children: const [
                        Icon(FontAwesomeIcons.train,
                            size: 35, color: Colors.green),
                        SizedBox(height: 5),
                        Text("Train ticket",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showInformTiveMessage();
                    },
                    child: Column(
                      children: const [
                        Icon(FontAwesomeIcons.plane,
                            size: 35, color: Colors.green),
                        SizedBox(height: 5),
                        Text("Arlines ticket ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      showInformTiveMessage();
                    },
                    child: Column(
                      children: const [
                        Icon(FontAwesomeIcons.umbrella,
                            size: 35, color: Colors.green),
                        SizedBox(height: 5),
                        Text("Insurance ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showInformTiveMessage();
                    },
                    child: Column(
                      children: const [
                        Icon(FontAwesomeIcons.firstAid,
                            size: 35, color: Colors.green),
                        SizedBox(height: 5),
                        Text("Health",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showInformTiveMessage();
                    },
                    child: Column(
                      children: const [
                        Icon(FontAwesomeIcons.book,
                            size: 35, color: Colors.green),
                        SizedBox(height: 5),
                        Text("Education ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  showInformTiveMessage() {
    Fluttertoast.showToast(
        msg: "This feature is under development",
        gravity: ToastGravity.CENTER_LEFT,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        backgroundColor: Color.fromARGB(255, 255, 128, 59),
        textColor: Colors.white,
        fontSize: 13.0);
  }
}
