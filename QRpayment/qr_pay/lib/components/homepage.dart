import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_pay/Utils/CustomWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/ExternalFunctions.dart';
import '../services/userAPI.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool? isUserLoggedIn;
  String fullname = "";
  String _id = "";
  double totalAmount = 0.0;

  // ignore: non_constant_identifier_names
  _HomepageState() {
    // getUserLoggedInStatus();
    retriveLoggedInUserDatFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [walletCard()],
      ),
    );
  }

  retriveLoggedInUserDatFromServer() async {
    SharedPreferences sharedPreferenceUserData =
        await SharedPreferences.getInstance();

    String? userid = sharedPreferenceUserData.getString("_id");

    print("USERIDFORWALLETINFORMATION " + userid!);

    var responseData = await UserApi().getUserData(userid);

    bool responseStatus = responseData['success'];
    if (responseStatus == true) {
      var userData = responseData['data'];
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
}
