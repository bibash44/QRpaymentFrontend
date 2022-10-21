import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_pay/screens/signin.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  int primaryColor = 0xFFCF2027;
  int _currentstep = 0;
  final signUpFormKey = GlobalKey<FormState>();
  String? fullname, phonenumber, email, address, password, cpassword;
  String _sessionToken = "326412";
  TextEditingController addressController = TextEditingController();
  var uuid = const Uuid();
  bool makePasswordVisible = false;
  bool isFormValidated = false;

  List<dynamic> placesList = [];

  @override
  void initState() {
    super.initState();
  }

  void getSuggestion(String query) async {
    setState(() {
      _sessionToken = uuid.v4();
    });
    String placeApiKey = "AIzaSyB2Q4az6sbEyA5MZuqKlnoMw_2ZwkSJ_GY";
    String baseUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request =
        '$baseUrl?input=$query&key=$placeApiKey&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      setState(() {
        placesList = jsonDecode(response.body.toString())["predictions"];
      });
    } else {
      throw Exception("Failed to load places");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: Color(primaryColor))),
        home: Scaffold(
          backgroundColor: Color(primaryColor),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  const Text(
                    "Signup as new user",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 500,
                    child: Card(
                      elevation: 5,
                      child: Form(
                        key: signUpFormKey,
                        child: Stepper(
                          steps: getSteps(),
                          type: StepperType.vertical,
                          currentStep: _currentstep,
                          onStepContinue: () {
                            final lastStep =
                                _currentstep == getSteps().length - 1;
                            if (lastStep) {
                              // print("completed");
                              // Send data to server
                            } else {
                              setState(() {
                                _currentstep += 1;
                              });

                              if (signUpFormKey.currentState!.validate()) {
                                signUpFormKey.currentState!.save();
                                setState(() {
                                  isFormValidated = true;
                                });
                              } else {
                                // Signupform not validated
                              }
                            }
                          },
                          onStepCancel: () {
                            _currentstep == 0
                                ? null
                                : setState(() {
                                    _currentstep -= 1;
                                  });
                          },
                          onStepTapped: (step) {
                            setState(() {
                              _currentstep = step;
                            });
                          },
                          controlsBuilder: (context, details) {
                            final islastStep =
                                _currentstep == getSteps().length - 1;
                            return Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: details.onStepContinue,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          padding: const EdgeInsets.all(15),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)))),
                                      child: Text(islastStep
                                          ? "Confirm & submit"
                                          : "Next"),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  if (_currentstep != 0)
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: details.onStepCancel,
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            padding: const EdgeInsets.all(15),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            side: const BorderSide(
                                                color: Colors.black, width: 2)),
                                        child: const Text(
                                          "Back",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Already a member ? ",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  InkWell(
                    child: const Text(
                      "Click here to sign in  ",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signin()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget generateCard(BuildContext context, int index) {
    String displayText = placesList[index]['description'];
    return GestureDetector(
      onTap: () {
        setState(() {
          addressController.text = displayText;
          placesList.clear();
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 233, 233, 233),
              borderRadius: BorderRadius.circular(5)),
          child: ListTile(
            title: Text(displayText),
          ),
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: _currentstep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentstep >= 0,
          title: const Text("Account"),
          content: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your name *";
                    } else if (!RegExp(
                            r'^([A-Za-z]{1,16})([ ]{0,1})([A-Za-z]{1,16})?([ ]{0,1})?([A-Za-z]{1,16})?([ ]{0,1})?([A-Za-z]{1,16})')
                        .hasMatch(value)) {
                      return "Please enter a valid name *";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  onSaved: (newValue) => fullname = newValue,
                  onChanged: (newValue) {
                    signUpFormKey.currentState!.save();
                    if (signUpFormKey.currentState!.validate()) {
                    } else {}
                  },
                  decoration: const InputDecoration(
                      labelText: "Fullname",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                      prefixIcon: Icon(Icons.person),
                      iconColor: Colors.black,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 192, 192, 192))),
                      filled: true,
                      fillColor: Color.fromARGB(255, 230, 230, 230)),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your email *";
                    } else if (!RegExp(
                            r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$')
                        .hasMatch(value)) {
                      return "Please enter a valid email *";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (newValue) => email = newValue,
                  onChanged: (newValue) {
                    signUpFormKey.currentState!.save();
                    if (signUpFormKey.currentState!.validate()) {
                    } else {}
                  },
                  decoration: const InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                      prefixIcon: Icon(Icons.email_outlined),
                      iconColor: Colors.black,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 192, 192, 192))),
                      filled: true,
                      fillColor: Color.fromARGB(255, 230, 230, 230)),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your phone number *";
                    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return "Please enter a valid phone number *";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  onSaved: (newValue) => phonenumber = newValue,
                  onChanged: (newValue) {
                    signUpFormKey.currentState!.save();
                    if (signUpFormKey.currentState!.validate()) {
                    } else {}
                  },
                  decoration: const InputDecoration(
                      labelText: "Phone number",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                      prefixIcon: Icon(Icons.phone),
                      iconColor: Colors.black,
                      prefixText: '+44',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 192, 192, 192))),
                      filled: true,
                      fillColor: Color.fromARGB(255, 230, 230, 230)),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _currentstep > 1 ? StepState.complete : StepState.indexed,
          isActive: _currentstep >= 1,
          title: const Text("Address"),
          content: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                TextFormField(
                  controller: addressController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your adress *";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onSaved: (newValue) => address = newValue,
                  onChanged: (newValue) {
                    getSuggestion(newValue);
                    signUpFormKey.currentState!.save();
                    if (signUpFormKey.currentState!.validate()) {
                    } else {}
                  },
                  decoration: const InputDecoration(
                      labelText: "Address",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                      prefixIcon: Icon(Icons.map),
                      iconColor: Colors.black,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 192, 192, 192))),
                      filled: true,
                      fillColor: Color.fromARGB(255, 230, 230, 230)),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: placesList.length * 75,
                    child: ListView.builder(
                      itemCount: placesList.length,
                      itemBuilder: ((context, index) =>
                          generateCard(context, index)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Step(
          state: _currentstep > 2 ? StepState.complete : StepState.indexed,
          isActive: _currentstep >= 2,
          title: const Text("Password"),
          content: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                TextFormField(
                  obscureText: !makePasswordVisible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your password *";
                    } else if (!RegExp(
                        // r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{6,}$')
                        r'^[A-Za-z0-9]+$').hasMatch(value)) {
                      return " Please enter only number and letters *";
                    }
                    return null;
                  },
                  onSaved: (newValue) => password = newValue,
                  onChanged: (newValue) {
                    signUpFormKey.currentState!.save();
                    if (signUpFormKey.currentState!.validate()) {
                    } else {}
                  },
                  decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle:
                          const TextStyle(color: Colors.black, fontSize: 16),
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
                            makePasswordVisible = !makePasswordVisible;
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
                      fillColor: const Color.fromARGB(255, 230, 230, 230)),
                ),

                // Confirm password form field
                const SizedBox(height: 15),
                TextFormField(
                  obscureText: !makePasswordVisible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please re-enter your password *";
                    } else if (value != password) {
                      return "Please re-enter same password *";
                    }
                    return null;
                  },
                  onSaved: (newValue) => cpassword = newValue,
                  onChanged: (newValue) {
                    signUpFormKey.currentState!.save();
                    if (signUpFormKey.currentState!.validate()) {
                    } else {}
                  },
                  decoration: InputDecoration(
                      labelText: "Confirm password",
                      labelStyle:
                          const TextStyle(color: Colors.black, fontSize: 16),
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
                            makePasswordVisible = !makePasswordVisible;
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
                      fillColor: const Color.fromARGB(255, 230, 230, 230)),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _currentstep > 3 ? StepState.complete : StepState.indexed,
          isActive: _currentstep >= 3,
          title: const Text("Complete"),
          content: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: !isFormValidated
                  ? const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Form not validated, please validate to continue *",
                        style: TextStyle(color: Colors.red),
                      ))
                  : null),
        ),
      ];
}
