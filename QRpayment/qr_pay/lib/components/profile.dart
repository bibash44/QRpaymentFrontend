import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/ExternalFunctions.dart';
import '../services/userAPI.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int primaryColor = 0xFFCF2027;
  bool? isUserLoggedIn;
  String userid = "";
  String fullname = "";
  String address = "";
  String phonenumber = "";
  String email = "";
  bool isUpdateLoading = false;
  bool isEmailSentLoading = false;
  bool isEmailVerifiedLoading = false;
  bool isProfileDataLoading = true;

  String? updateFullname, updatePhonenumber, updateAddress;

  int verificationCode = 0;
  bool emailverified = false;

  bool showVerificationForm = false;
  bool showActionButtons = true;
  bool showUpdateForm = false;

  TextEditingController emailVerificationController = TextEditingController();

  TextEditingController editFullNameController = TextEditingController();
  TextEditingController editPhoneNumberController = TextEditingController();
  TextEditingController editAddressController = TextEditingController();
  final updateFormKey = GlobalKey<FormState>();

  List placesList = [];

  _ProfileState() {
    retriveLoggedInUserDatFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return isProfileDataLoading
        ? const SpinKitThreeBounce(color: Colors.black, size: 50)
        : SingleChildScrollView(
            child: Column(
              children: [
                userdetails(),
                showActionButtons ? actionButtons() : Container(),
                showVerificationForm ? emailVerificationForm() : Container(),
                showUpdateForm ? updateForm() : Container()
              ],
            ),
          );
  }

  void getAddressSuggestion(String query) async {
    var response = await ExternalFunctions().getPlacesSuggestionAPI(query);
    setState(() {
      placesList = response;
    });
  }

  retriveLoggedInUserDatFromServer() async {
    SharedPreferences sharedPreferenceUserData =
        await SharedPreferences.getInstance();
    String? _token = sharedPreferenceUserData.getString("_token");
    String? _userid = sharedPreferenceUserData.getString("_id");

    var responseData = await UserApi().getUserData(_userid!);

    bool responseStatus = responseData['success'];
    if (responseStatus == true) {
      setState(() {
        isProfileDataLoading = false;
      });
      var userData = responseData['data'];
      // ignore: no_leading_underscores_for_local_identifiers

      String _fullname = userData['fullname'];
      String _phonenumber = userData['phonenumber'];
      String _email = userData['email'];
      String _address = userData['address'];
      bool _emailverified = userData['emailverified'];

      setState(() {
        fullname = _fullname;
        phonenumber = _phonenumber;
        email = _email;
        address = _address;
        emailverified = _emailverified;
        userid = _userid;
        editFullNameController.text = _fullname;
        editPhoneNumberController.text = _phonenumber;
        editAddressController.text = _address;
      });
    } else if (responseStatus == false) {}
  }

  sentVerificationCode() async {
    int _verificationCode = Random().nextInt(999999);
    setState(() {
      verificationCode = _verificationCode;
    });
    var subject = "Email verification";
    var description = "Your verification code is $verificationCode";

    try {
      var resposeData = await UserApi().sendEmail(email, subject, description);

      bool responseStatus = resposeData['success'];
      if (responseStatus == true) {
        setState(() {
          showActionButtons = false;
          showVerificationForm = true;
          showUpdateForm = false;
          isEmailSentLoading = false;
        });
        Fluttertoast.showToast(
            msg: resposeData['msg'],
            gravity: ToastGravity.CENTER_LEFT,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 13.0);
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

  verifyEmail() async {
    var userInputCode = emailVerificationController.text;

    if (verificationCode.toString() != userInputCode) {
      setState(() {
        isEmailVerifiedLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Code didnot match , please try again",
          gravity: ToastGravity.CENTER_LEFT,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 13.0);
    } else {
      bool emailVerifiedSuccessfully = true;

      var requestBody = jsonEncode({
        "emailverified": emailVerifiedSuccessfully,
      });

      try {
        // verify email
        var resposeData = await UserApi().updateUser(userid, requestBody);

        bool responseStatus = resposeData['success'];
        if (responseStatus == true) {
          setState(() {
            showActionButtons = true;
            emailverified = true;

            showVerificationForm = false;
            showUpdateForm = false;
            isEmailVerifiedLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Email verified",
              gravity: ToastGravity.CENTER_LEFT,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 13.0);
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
  }

  updateProfile() async {
    var requestBody = jsonEncode({
      "fullname": updateFullname,
      "phonenumber": updatePhonenumber,
      "address": updateAddress
    });

    try {
      // verify email
      var resposeData = await UserApi().updateUser(userid, requestBody);

      bool responseStatus = resposeData['success'];
      if (responseStatus == true) {
        setState(() {
          showActionButtons = true;
          showVerificationForm = false;
          showUpdateForm = false;
          isUpdateLoading = false;
          address = updateAddress!;
          fullname = updateFullname!;
          phonenumber = updatePhonenumber!;
        });
        Fluttertoast.showToast(
            msg: resposeData['msg'],
            gravity: ToastGravity.CENTER_LEFT,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 13.0);
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

  openUpdateForm() {
    setState(() {
      showActionButtons = false;
      showVerificationForm = false;
      showUpdateForm = true;
    });
  }

  Widget generateColorizedNameImage() {
    if (fullname == null || fullname == "") {
      fullname = "XXX";
    }

    if (email == null || email == "") {
      email = "XXX";
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

  Widget userdetails() {
    return Container(
      width: double.infinity,
      height: 350,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: generateColorizedNameImage(),
                ),
                const SizedBox(height: 10),
                emailverified
                    ? const Center(
                        child: Icon(
                          FontAwesomeIcons.solidCheckCircle,
                          color: Colors.green,
                        ),
                      )
                    : const Center(
                        child: Text(
                          "Not verified",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                const SizedBox(height: 5),
                // userdetails(),
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(FontAwesomeIcons.user),
                        const SizedBox(width: 15),
                        Text(fullname,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        const Icon(FontAwesomeIcons.envelope),
                        const SizedBox(width: 15),
                        Text(email,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        const Icon(FontAwesomeIcons.mobileAlt),
                        const SizedBox(width: 15),
                        if (phonenumber.isEmpty)
                          InkWell(
                              child: const Text(
                                "Phone number found, click here to update ",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic),
                              ),
                              onTap: () {
                                openUpdateForm();
                              })
                        else
                          Text("+44  $phonenumber",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        const Icon(FontAwesomeIcons.mapMarkerAlt),
                        const SizedBox(width: 15),
                        if (address.isEmpty)
                          InkWell(
                              child: const Text(
                                "Address not found, click here to update",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic),
                              ),
                              onTap: () {
                                openUpdateForm();
                              })
                        else if (address.length >= 36)
                          Text(
                              address.toString().replaceRange(
                                  36, address.toString().length, ". . ."),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16))
                        else
                          Text(address,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget actionButtons() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  openUpdateForm();
                },
                icon: const FaIcon(Icons.edit_sharp, size: 25),
                label: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Edit profile",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.all(20),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),
            ),
            const SizedBox(height: 15),
            emailverified
                ? Container()
                : isEmailSentLoading
                    ? const SpinKitCircle(color: Colors.black)
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            setState(() {
                              isEmailSentLoading = true;
                            });
                            sentVerificationCode();
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.envelope,
                            size: 25,
                            color: Colors.black,
                          ),
                          label: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Verify email",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.all(20),
                              shape: const RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.black, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget emailVerificationForm() {
    return Container(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: emailVerificationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Enter verification code",
                    labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                    iconColor: Colors.black,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 192, 192, 192))),
                    filled: true,
                    fillColor: Color.fromARGB(255, 230, 230, 230)),
              ),
              const SizedBox(height: 15),
              isEmailVerifiedLoading
                  ? const SpinKitCircle(color: Colors.black)
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isEmailVerifiedLoading = true;
                          });
                          verifyEmail();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(primaryColor),
                            padding: const EdgeInsets.all(20),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Verify",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            )),
                      ),
                    ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      showActionButtons = true;
                      showVerificationForm = false;
                      showUpdateForm = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.all(20),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget updateForm() {
    return Container(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: updateFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: editFullNameController,
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
                  onSaved: (newValue) => updateFullname = newValue,
                  onChanged: (newValue) {
                    updateFormKey.currentState!.save();
                    if (updateFormKey.currentState!.validate()) {
                    } else {}
                  },
                  decoration: const InputDecoration(
                      labelText: "Fullname",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                      prefixIcon: Icon(FontAwesomeIcons.user),
                      iconColor: Colors.black,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 192, 192, 192))),
                      filled: true,
                      fillColor: Color.fromARGB(255, 230, 230, 230)),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: editPhoneNumberController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your phone number *";
                    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return "Please enter a valid phone number *";
                    }
                    return null;
                  },
                  onSaved: (newValue) => updatePhonenumber = newValue,
                  onChanged: (newValue) {
                    updateFormKey.currentState!.save();
                    if (updateFormKey.currentState!.validate()) {
                    } else {}
                  },
                  decoration: const InputDecoration(
                      labelText: "Phone number",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                      prefixIcon: Icon(FontAwesomeIcons.mobileAlt),
                      iconColor: Colors.black,
                      prefixText: '+44',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 192, 192, 192))),
                      filled: true,
                      fillColor: Color.fromARGB(255, 230, 230, 230)),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: editAddressController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your adress *";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onSaved: (newValue) => updateAddress = newValue,
                  onChanged: (newValue) {
                    getAddressSuggestion(newValue);
                    updateFormKey.currentState!.save();
                    if (updateFormKey.currentState!.validate()) {
                    } else {}
                  },
                  decoration: const InputDecoration(
                      labelText: "Address",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                      prefixIcon: Icon(FontAwesomeIcons.mapMarkerAlt),
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
                          generateAddressDisplayCard(context, index)),
                    ),
                  ),
                ),
                if (placesList.isEmpty) const SizedBox(height: 15),
                isUpdateLoading
                    ? const SpinKitCircle(color: Colors.black)
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (updateFormKey.currentState!.validate()) {
                              updateFormKey.currentState!.save();
                              setState(() {
                                isUpdateLoading = true;
                              });
                              // Calling user register function to send user datas
                              updateProfile();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(primaryColor),
                              padding: const EdgeInsets.all(20),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                          child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Update ",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              )),
                        ),
                      ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        showActionButtons = true;
                        showUpdateForm = false;
                        showVerificationForm = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.all(20),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                    child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget generateAddressDisplayCard(BuildContext context, int index) {
    String displayText = placesList[index]['description'];
    return GestureDetector(
      onTap: () {
        setState(() {
          editAddressController.text = displayText;
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
}
