import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_pay/Utils/CustomWidgets.dart';
import 'package:qr_pay/Utils/ExternalFunctions.dart';

class StaticPayment extends StatefulWidget {
  String qId;
  String qrFullname;
  String qRamount;
  String senderName;
  int totalamount;

  StaticPayment(this.qId, this.qrFullname, this.qRamount, this.senderName,
      this.totalamount,
      {Key? key})
      : super(key: key);

  @override
  State<StaticPayment> createState() => _StaticPaymentState();
}

class _StaticPaymentState extends State<StaticPayment> {
  int primaryColor = 0xFFCF2027;
  final paymentFormKey = GlobalKey<FormState>();
  String? remarks;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: Color(primaryColor))),
      home: Scaffold(
          appBar: AppBar(title: Text("Payment details")),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  walletCard(widget.senderName, widget.totalamount, context),
                  const SizedBox(height: 20),
                  CustomWidgets().paymentDetailsCard(
                      widget.qId, widget.qrFullname, widget.qRamount, context),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: Card(
                        child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Form(
                          key: paymentFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter amount *";
                                  } else if (!RegExp(r'^[1-9][0-9]*$')
                                      .hasMatch(value)) {
                                    return "Please enter a valid amount *";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                onSaved: (newValue) =>
                                    widget.qRamount = newValue!,
                                onChanged: (newValue) {
                                  if (widget.qRamount.isEmpty ||
                                      widget.qRamount == "") {
                                    setState(() {
                                      widget.qRamount = "0";
                                    });
                                  }
                                  setState(() {
                                    widget.qRamount = newValue;
                                  });

                                  paymentFormKey.currentState!.save();
                                  if (paymentFormKey.currentState!.validate()) {
                                  } else {}
                                },
                                decoration: const InputDecoration(
                                    labelText: "Amount",
                                    labelStyle: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    iconColor: Colors.black,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 192, 192, 192))),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 230, 230, 230)),
                              ),
                              const SizedBox(height: 20),

                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter remarks or purpose *";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.multiline,
                                maxLength: 80,
                                maxLines: 3,
                                onSaved: (newValue) => remarks = newValue,
                                onChanged: (newValue) {
                                  remarks = newValue;
                                  paymentFormKey.currentState!.save();
                                  if (paymentFormKey.currentState!.validate()) {
                                  } else {}
                                },
                                decoration: const InputDecoration(
                                    labelText: "Remarks or purpose",
                                    labelStyle: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 192, 192, 192))),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 230, 230, 230)),
                              ),
                              SizedBox(height: 20),
                              // Payment button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(primaryColor),
                                      padding: const EdgeInsets.all(20),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)))),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Confirm and pay",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
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
                        Text("£$totalAmount",
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
}
