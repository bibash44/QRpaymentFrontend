import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:qr_pay/Utils/CustomWidgets.dart';
import 'package:qr_pay/Utils/ExternalFunctions.dart';
import 'package:qr_pay/screens/navigation_page.dart';
import 'package:qr_pay/services/transactionAPi.dart';

class StaticPayment extends StatefulWidget {
  String qrId;
  String qrFullname;
  double qRamount;
  String senderName;
  String senderId;
  double totalamount;
  bool isDynamic;

  StaticPayment(this.qrId, this.qrFullname, this.qRamount, this.senderName,
      this.senderId, this.totalamount, this.isDynamic,
      {Key? key})
      : super(key: key);

  @override
  State<StaticPayment> createState() => _StaticPaymentState();
}

class _StaticPaymentState extends State<StaticPayment> {
  int primaryColor = 0xFFCF2027;
  final paymentFormKey = GlobalKey<FormState>();
  String? remarks;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: Color(primaryColor))),
      home: Scaffold(
          appBar: AppBar(title: const Text("Payment details")),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  walletCard(widget.senderName, widget.totalamount, context),
                  const SizedBox(height: 20),
                  paymentDetailsCard(),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: widget.isDynamic ? null : 300,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // For dynamic payment
                          widget.isDynamic
                              ? isLoading
                                  ? const SpinKitCircle(
                                      size: 30, color: Colors.black)
                                  : SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (widget.totalamount <
                                              widget.qRamount) {
                                            Fluttertoast.showToast(
                                                msg: "Not enough balance",
                                                gravity:
                                                    ToastGravity.CENTER_LEFT,
                                                toastLength: Toast.LENGTH_LONG,
                                                timeInSecForIosWeb: 5,
                                                backgroundColor: Colors.grey,
                                                textColor: Colors.white,
                                                fontSize: 13.0);
                                            setState(() {
                                              isLoading = false;
                                            });
                                          } else {
                                            makeTranscation();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color(primaryColor),
                                            padding: const EdgeInsets.all(20),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)))),
                                        child: const Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Pay",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            )),
                                      ),
                                    )

                              //  Static payment
                              : Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Form(
                                      key: paymentFormKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              ThousandsFormatter(
                                                  allowFraction: true)
                                            ],
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please enter amount *";
                                              } else if (!RegExp(
                                                      r'^\d{1,5}$|(?=^.{1,5}$)^\d+\.\d{0,3}$')
                                                  .hasMatch(value)) {
                                                return "Please enter a valid amount *";
                                              } else if (double.parse(value!) >
                                                  widget.totalamount) {
                                                return "Not enough balance";
                                              } else if (double.parse(value!) <=
                                                  0.1) {
                                                return "Amount must be more than 0.1";
                                              }
                                              return null;
                                            },
                                            onSaved: (newValue) {
                                              if (newValue!.isEmpty ||
                                                  newValue == null) {
                                                setState(() {
                                                  widget.qRamount = 0.0;
                                                });
                                              } else {
                                                setState(() {
                                                  widget.qRamount =
                                                      double.parse(newValue);
                                                });
                                              }
                                            },
                                            onChanged: (newValue) {
                                              if (newValue.isEmpty ||
                                                  newValue == null) {
                                                setState(() {
                                                  widget.qRamount = 0.0;
                                                });
                                              } else {
                                                setState(() {
                                                  widget.qRamount =
                                                      double.parse(newValue);
                                                });
                                              }

                                              paymentFormKey.currentState!
                                                  .save();
                                              if (paymentFormKey.currentState!
                                                  .validate()) {
                                              } else {}
                                            },
                                            decoration: const InputDecoration(
                                                labelText: "Amount",
                                                labelStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                                iconColor: Colors.black,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    192,
                                                                    192,
                                                                    192))),
                                                filled: true,
                                                fillColor: Color.fromARGB(
                                                    255, 230, 230, 230)),
                                          ),
                                          const SizedBox(height: 20),

                                          TextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please enter remarks or purpose *";
                                              }
                                              return null;
                                            },
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLength: 80,
                                            maxLines: 3,
                                            onSaved: (newValue) =>
                                                remarks = newValue,
                                            onChanged: (newValue) {
                                              remarks = newValue;
                                              paymentFormKey.currentState!
                                                  .save();
                                              if (paymentFormKey.currentState!
                                                  .validate()) {
                                              } else {}
                                            },
                                            decoration: const InputDecoration(
                                                labelText: "Remarks or purpose",
                                                labelStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    192,
                                                                    192,
                                                                    192))),
                                                filled: true,
                                                fillColor: Color.fromARGB(
                                                    255, 230, 230, 230)),
                                          ),
                                          SizedBox(height: 20),
                                          // Payment button
                                          isLoading
                                              ? const SpinKitCircle(
                                                  size: 30, color: Colors.black)
                                              : SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      if (paymentFormKey
                                                          .currentState!
                                                          .validate()) {
                                                        paymentFormKey
                                                            .currentState!
                                                            .save();
                                                        makeTranscation();
                                                      }
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Color(primaryColor),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20),
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        15)))),
                                                    child: const Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Confirm and pay",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget walletCard(fullname, totalAmount, context) {
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
                        if (totalAmount.toString().length >= 5)
                          Text(
                              "£${totalAmount.toString().replaceRange(5, totalAmount.toString().length, "")}",
                              style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold))
                        else
                          Text("£${totalAmount.toString()}",
                              style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold)),
                        const Text("Balance",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        CustomWidgets()
                            .generateColorizedNameImage(context, fullname),
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

  Widget paymentDetailsCard() {
    return Container(
      width: double.infinity,
      height: 200,
      child: Card(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Recipient details",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const Divider(
                color: Colors.grey,
              ),
              Text("£${widget.qRamount}",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(widget.qrFullname,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("QR ID : ${widget.qrId}",
                  style: const TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 20),
              const Text(
                  "Note : Once the payment has been made, it can be reverted back, please send only to the person you know ",
                  style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 186, 186, 186),
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      )),
    );
  }

  makeTranscation() async {
    if (remarks == null) {
      setState(() {
        remarks = "";
      });
    }

    try {
      var resposeData = await TransactionApi().makeTranscation(
          widget.senderId, widget.qrId, widget.qRamount, remarks);

      bool responseStatus = resposeData['success'];
      if (responseStatus == true) {
        Fluttertoast.showToast(
            msg: resposeData['msg'],
            gravity: ToastGravity.CENTER_LEFT,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 13.0);
        setState(() {
          isLoading = false;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NavigationPage()));
        });
      } else if (responseStatus == false) {
        Fluttertoast.showToast(
            msg: resposeData['msg'],
            gravity: ToastGravity.CENTER_LEFT,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 13.0);
        setState(() {
          isLoading = false;
        });
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
