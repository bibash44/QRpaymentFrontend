import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:qr_pay/Auth/google_auth_service.dart';
import 'package:qr_pay/Utils/ExternalFunctions.dart';
import 'package:qr_pay/components/homepage.dart';
import 'package:qr_pay/components/profile.dart';
import 'package:qr_pay/components/Transaction.dart';
import 'package:qr_pay/screens/qr_scan.dart';
import 'package:qr_pay/screens/landing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int primaryColor = 0xFFCF2027;
  bool isUserLoggedIn = false;
  int _index = 0;
  String? fullname, _id;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  var bottomNavigationPages = [
    Homepage(),
    Transaction(),
    Profile(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: Color(primaryColor))),
        home: Scaffold(
          backgroundColor: const Color(0xFFF0F0F0),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            title: const Text(
              "QRpay",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    openSignoutDialouge();
                  },
                  icon: const Icon(
                    FontAwesomeIcons.powerOff,
                    size: 20,
                    color: Colors.black,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRScan()));
                  },
                  icon: const Icon(
                    Icons.qr_code_2,
                    size: 30,
                    color: Color(0xFFCF2027),
                  )),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: const Color(0xFFFF4A4A),
                hoverColor: const Color(0xFFFF812D),
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 200),
                tabBackgroundColor: Color(primaryColor),
                color: Colors.black,
                tabs: const [
                  GButton(
                    icon: Icons.home_filled,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.event_note_rounded,
                    text: 'Statement',
                  ),
                  GButton(
                    icon: FontAwesomeIcons.user,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _index,
                onTabChange: (index) {
                  setState(() {
                    _index = index;
                  });
                },
              ),
            ),
          ),
          body: bottomNavigationPages[_index],
        ));
  }

  getUserLoggedInStatus() async {
    SharedPreferences sharedPreferenceUserData =
        await SharedPreferences.getInstance();

    bool? _isUserLoggedIn = sharedPreferenceUserData.getBool("_isUserLoggedIn");
    String? _fullname = sharedPreferenceUserData.getString("_fullname");
    String? id = sharedPreferenceUserData.getString("_id");

    setState(() {
      isUserLoggedIn = _isUserLoggedIn!;
      fullname = fullname;
      _id = id;
    });
  }

  openSignoutDialouge() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Signout'),
        content: const Text('Are you sure to signout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              ExternalFunctions().signoutUser(context);
              GoogleAuthService().googleSignOut();
            },
            child: Text(
              'Signout',
              style: TextStyle(color: Color(primaryColor), fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
