import 'package:flutter/material.dart';

class AccountingScreen extends StatefulWidget {
  const AccountingScreen({super.key});

  @override
  State<AccountingScreen> createState() => _AccountingScreenState();
}

class _AccountingScreenState extends State<AccountingScreen> {
  List<String> accounting = [
    "Daily Statement",
    "Expense Voucher",
    "Due Collection",
    "Due Payment",
    "Money Transfer",
    "Money Adjustment",
    "Ledger",
    "Trial Balance",
    "Profit or Loss",
    "Balance Sheet",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBar(
          title: Text('Accounting'),
          centerTitle: true,
        ),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        childAspectRatio: 166/53,
        children: <Widget>[
          ...accounting.map((e) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Color(0xffFF9000), width: .5)
              ),
              child: Center(child: Text(e))),)
        ],
      )
    );
  }
}
