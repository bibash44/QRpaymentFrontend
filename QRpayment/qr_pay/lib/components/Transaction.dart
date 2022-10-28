import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_pay/Model/userTransaction.dart';
import 'package:qr_pay/services/transactionAPi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  String? fullname, id;
  bool? isReceived;
  final searchController = TextEditingController();
  List<UserTransaction> allTransaction = [];
  List<UserTransaction> transactionList = [
    UserTransaction("xxx", "xxx", "xxx", 0.0, "xxx", "xxx"),
  ];

  _TransactionState() {
    loadTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              child: TextFormField(
                onChanged: searchTransactions,
                controller: searchController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    hintText: 'Search transactions. . .',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 128, 128, 128)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search_outlined),
                      onPressed: () {},
                    ),
                    iconColor: Colors.black,
                    filled: true,
                    fillColor: const Color.fromARGB(255, 230, 230, 230)),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: transactionList.length,
                    itemBuilder: (context, index) =>
                        generateTransactionCard(index)))
          ],
        ),
      ),
    );
  }

  Widget generateTransactionCard(index) {
    String dateAndTime = transactionList[index].date.toString();
    var splitDateAndTime = dateAndTime.split('T');
    String date = splitDateAndTime[0];
    var splitTime = splitDateAndTime[1].split('.');
    String time = splitTime[0];

    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 150,
        child: Padding(
            padding: EdgeInsets.all(5),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (id == transactionList[index].sender)
                      Row(
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
                    else
                      Row(
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
                    const SizedBox(height: 5),
                    Text("£${transactionList[index].amount}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    const SizedBox(height: 15),
                    Text(date.toString(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 15)),
                    const SizedBox(height: 5),
                    Text(time.toString(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void loadTransaction() async {
    SharedPreferences sharedPreferenceUserData =
        await SharedPreferences.getInstance();

    String? _fullname = sharedPreferenceUserData.getString("_fullname");
    String? _id = sharedPreferenceUserData.getString("_id");

    setState(() {
      fullname = _fullname;
      id = _id;
    });

    TransactionApi transactionAPi = TransactionApi();
    var data = await transactionAPi.getAllTransaction(_id!);
    for (var i = 0; i < data['data'].length; i++) {
      allTransaction.add(UserTransaction(
          data['data'][i]['_id'],
          data['data'][i]['sender'],
          data['data'][i]['recipient'],
          data['data'][i]['amount'].toDouble(),
          data['data'][i]['date'],
          data['data'][i]['remarks']));
    }

    setState(() {
      transactionList = allTransaction;
    });
  }

  void searchTransactions(String searchQuery) {
    final suggestionsList = allTransaction.where((transactions) {
      final searchtransactionInput =
          "${transactions.id!}${transactions.amount!}${transactions.date}"
              .toLowerCase();

      return searchtransactionInput.contains(searchQuery.toLowerCase());
    }).toList();

    setState(() {
      transactionList = suggestionsList;
    });
  }
}
