import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_pay/screens/signin.dart';
import 'package:qr_pay/screens/signup.dart';

void main() {
  runApp(const Landing());
}

class Landing extends StatelessWidget {
  const Landing({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    int primaryColor = 0xFFCF2027;
    return MaterialApp(
      title: 'QRpay',
      theme: ThemeData(
          primaryColor: Color(primaryColor),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: Color(primaryColor))),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int primaryColor = 0xFFCF2027;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(primaryColor),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'images/QR2.png',
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigator.pushNamed(context, '/signup');
                    },
                    icon: Tab(
                        icon: Image.asset(
                      "images/google.png",
                      width: 30,
                      fit: BoxFit.fitHeight,
                    )),
                    label: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Sign-in with google",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(10),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signin()));
                    },
                    icon: const FaIcon(Icons.login, size: 25),
                    label: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Sign-in to continue",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.all(20),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signup()));
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.userAlt,
                      size: 25,
                      color: Colors.white,
                    ),
                    label: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Signup as new user",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(primaryColor),
                        padding: const EdgeInsets.all(20),
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
