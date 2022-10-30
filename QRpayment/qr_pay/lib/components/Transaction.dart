import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_pay/Model/userTransaction.dart';
import 'package:qr_pay/screens/statement.dart';
import 'package:qr_pay/services/transactionAPi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  String? fullname, userid;
  bool isReceived = false;
  final searchController = TextEditingController();
  List<UserTransaction> allTransaction = [];
  List<UserTransaction> transactionList = [
    UserTransaction("xxx", "xxx", "xxx", 0.0, "xxx", "xxx", "xxx"),
  ];
  String dateAndTime = "2022-10-30T01:13:41.900+00:00";
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
    String? userIdToReceiveData;
    bool? isReceived;

    if (userid == transactionList[index].sender) {
      userIdToReceiveData = transactionList[index].receipent!;
      isReceived = false;
    } else if (userid == transactionList[index].receipent) {
      userIdToReceiveData = transactionList[index].sender!;
      isReceived = true;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Statement(
                      userIdToReceiveData!,
                      isReceived!,
                      transactionList[index].id!,
                      transactionList[index].amount!,
                      transactionList[index].date!,
                      transactionList[index].time!,
                      transactionList[index].remarks!,
                    )));
      },
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
                    if (userid == transactionList[index].receipent)
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
                    Text("£${transactionList[index].amount}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    const SizedBox(height: 10),
                    Text(transactionList[index].date.toString(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 15)),
                    const SizedBox(height: 5),
                    Text(transactionList[index].time.toString(),
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
      userid = _id;
    });

    TransactionApi transactionAPi = TransactionApi();
    var data = await transactionAPi.getAllTransaction(_id!);
    for (var i = 0; i < data['data'].length; i++) {
      allTransaction.add(UserTransaction(
          data['data'][i]['_id'],
          data['data'][i]['sender'],
          data['data'][i]['recipient'],
          data['data'][i]['amount'].toDouble(),
          data['data'][i]['date'].split('T')[0],
          data['data'][i]['date'].split('T')[1].split('.')[0],
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
