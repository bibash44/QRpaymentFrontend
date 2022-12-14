import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_pay/Utils/ExternalFunctions.dart';
import 'package:qr_pay/screens/navigation_page.dart';
import 'package:qr_pay/screens/signup.dart';
import 'package:qr_pay/services/userAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/CustomWidgets.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  int primaryColor = 0xFFCF2027;
  bool makePasswordVisible = false;
  // ignore: non_constant_identifier_names
  final SigninFormKey = GlobalKey<FormState>();
  String? email, password;

  bool isSigninButtonDisbaled = true;
  bool isLoading = false;
  bool isEmailGmail = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redirectLoggedInUserToHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: Color(primaryColor))),
      home: Scaffold(
        backgroundColor: Color(primaryColor),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    "Welcome back, please sign in to continue",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    elevation: 5,
                    child: Form(
                      key: SigninFormKey,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        child: Column(children: [
                          const SizedBox(
                            height: 20,
                          ),

                          // Email form field for Signin

                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your email";
                              } else if (!RegExp(
                                      r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$')
                                  .hasMatch(value)) {
                                return "Please enter valid email";
                              } else if (value.contains("@gmail.com")) {
                                setState(() {
                                  isEmailGmail = true;
                                });
                                return "Your are using gmail, please signin through google ";
                              }
                              setState(() {
                                isEmailGmail = false;
                              });
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (newValue) => email = newValue,
                            onChanged: (newValue) {
                              SigninFormKey.currentState!.save();
                              if (SigninFormKey.currentState!.validate()) {
                              } else {}
                            },
                            decoration: const InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                prefixIcon: Icon(Icons.email_outlined),
                                iconColor: Colors.black,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 192, 192, 192))),
                                filled: true,
                                fillColor: Color.fromARGB(255, 230, 230, 230)),
                          ),
                          if (isEmailGmail)
                            Column(
                              children: [
                                const SizedBox(height: 5),
                                CustomWidgets().linkTosignInWithGoogle(context)
                              ],
                            ),
                          // Input form passowrd field

                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your password *";
                              } else if (!RegExp(r'^[A-Za-z0-9]+$')
                                  .hasMatch(value)) {
                                return " Please enter only number and letters *";
                              }

                              return null;
                            },
                            obscureText: !makePasswordVisible,
                            onSaved: (newValue) => password = newValue,
                            onChanged: (newValue) {
                              SigninFormKey.currentState!.save();
                              if (SigninFormKey.currentState!.validate()) {
                              } else {}
                            },
                            decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                                prefixIcon: const Icon(Icons.lock_open_rounded),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    makePasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      makePasswordVisible =
                                          !makePasswordVisible;
                                    });
                                  },
                                ),
                                iconColor: Colors.black,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 192, 192, 192),
                                  ),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 230, 230, 230)),
                          ),

                          const SizedBox(height: 15),
                          // Signin button
                          isLoading
                              ? const SpinKitCircle(
                                  color: Colors.black,
                                  size: 30,
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: const EdgeInsets.all(15),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (SigninFormKey.currentState!
                                          .validate()) {
                                        SigninFormKey.currentState!.save();
                                        setState(() {
                                          isLoading = true;
                                        });
                                        // Calling user Signin function to send user datas
                                        signInUser(email, password);
                                      }
                                    },
                                    child: const Text(
                                      "Sign In",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 35),
                          const Text(
                            "Don't have a account ? ",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          InkWell(
                            child: const Text(
                              "Click here to register ",
                              style: TextStyle(
                                  color: Colors.blueAccent, fontSize: 18),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Signup()));
                            },
                          ),
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  signInUser(email, password) async {
    try {
      var responseData = await UserApi().signInUser(email, password);

      bool responseStatus = responseData['success'];
      print(responseData['success']);

      if (responseStatus == true) {
        var userData = responseData['data'];
        String _id = userData['_id'];
        String _fullname = userData['fullname'];
        String _email = userData['email'];
        String _phonenumber = userData['phonenumber'];
        String _address = userData['address'];
        double _totalamount = userData['totalamount'].toDouble();
        bool _emailverified = userData['emailverified'];
        String token = responseData['token'];

        ExternalFunctions().saveUserDataAfterLogin(_id, _fullname, _email,
            _phonenumber, _address, _totalamount, _emailverified, token);

        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(
            msg: responseData['msg'],
            gravity: ToastGravity.CENTER_LEFT,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 13.0);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const NavigationPage()));
      } else if (responseStatus == false) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: responseData['msg'],
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

  redirectLoggedInUserToHomePage() async {
    final sharedPreferenceUserData = await SharedPreferences.getInstance();

    bool? isUserLoggedIn = sharedPreferenceUserData.getBool("_isUserLoggedIn");
    String? _usertype = sharedPreferenceUserData.getString("_usertype");

    if (isUserLoggedIn!) {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const NavigationPage()));
    }
  }
}
