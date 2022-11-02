import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_pay/screens/navigation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/userAPI.dart';

class Statement extends StatefulWidget {
  String userIdToReceiveData;
  bool isReceived;
  String transactionId;
  double amount;
  String date;
  String time;
  String remarks;

  Statement(this.userIdToReceiveData, this.isReceived, this.transactionId,
      this.amount, this.date, this.time, this.remarks,
      {Key? key})
      : super(key: key);

  @override
  State<Statement> createState() => _StatementState();
}

class _StatementState extends State<Statement> {
  int primaryColor = 0xFFCF2027;
  String userFullNameForStatement = "";
  String userEmailForStatement = "";
  double totalAmount = 0.0;
  bool isStatementDataLoading = true;

  @override
  void initState() {
    retriveLoggedInUserDatFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: Color(primaryColor))),
        home: Scaffold(
          appBar: AppBar(
              title: const Text("Statement"),
              leading: BackButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  })),
          body: isStatementDataLoading
              ? const SpinKitThreeBounce(
                  size: 50,
                  color: Colors.black,
                )
              : SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              widget.isReceived
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: const [
                                        Text("Received",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold)),
                                        Icon(
                                          Icons.arrow_drop_down_outlined,
                                          color: Colors.green,
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: const [
                                        Text("Sent",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold)),
                                        Icon(
                                          Icons.arrow_drop_up_outlined,
                                          color: Colors.red,
                                        )
                                      ],
                                    ),
                              const SizedBox(height: 10),
                              const Text("Transaction id :",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16)),
                              Text(widget.transactionId,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              const SizedBox(height: 30),
                              widget.isReceived
                                  ? const Text("Received from : ",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16))
                                  : const Text("Sent to :",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16)),
                              Text(userFullNameForStatement,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              const SizedBox(height: 30),
                              const Text("Email :",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16)),
                              Text(userEmailForStatement,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              const SizedBox(height: 30),
                              const Text("Amount :",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16)),
                              Text("£${widget.amount}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              const SizedBox(height: 30),
                              const Text("Date :",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16)),
                              Text(widget.date,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              const SizedBox(height: 30),
                              const Text("Time :",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16)),
                              Text(widget.time,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              const SizedBox(height: 30),
                              const Text("Remarks :",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16)),
                              if (widget.remarks == null ||
                                  widget.remarks == "")
                                const Text("No remarks",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 18))
                              else
                                Text(widget.remarks,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }

  retriveLoggedInUserDatFromServer() async {
    SharedPreferences sharedPreferenceUserData =
        await SharedPreferences.getInstance();
    String? _token = sharedPreferenceUserData.getString("_token");
    var responseData = await UserApi().getUserData(widget.userIdToReceiveData);

    bool responseStatus = responseData['success'];
    if (responseStatus == true) {
      setState(() {
        isStatementDataLoading = false;
      });
      var userData = responseData['data'];
      String _fullname = userData['fullname'];
      String _email = userData['email'];
      double _totalamount = userData['totalamount'].toDouble();

      setState(() {
        userFullNameForStatement = _fullname;
        totalAmount = _totalamount;
        userEmailForStatement = _email;
      });
      // ignore: use_build_context_synchronously

    } else if (responseStatus == false) {}
  }
}
