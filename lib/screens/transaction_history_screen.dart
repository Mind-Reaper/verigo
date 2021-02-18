import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/transaction_history_widget.dart';


class TransactionHistoryScreen extends StatefulWidget {
  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Color(0xfff6f6f6),
        appBar: appBar(
          context,
          title: 'Transaction History',
          blackTitle: true,
          centerTitle: false,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
        ),
        body: ListView(children: [
          TransactionHistory(
            date: "21/01/2021",
            time: "11:57:22",
            amount: "N17,000.00",
            alertType: AlertType.credit,
            transId: "43657657554566NIG",
            ref: "Ref-55654495966966040403455",
          ),
          TransactionHistory(
            date: "21/01/2021",
            time: "11:57:22",
            amount: "N58,037.00",
            alertType: AlertType.debit,
            transId: "43657657554566NIG",
            ref: "Ref-55654495966966040403455",
          ),
          TransactionHistory(
            date: "21/01/2021",
            time: "11:57:22",
            amount: "N204,030.00",
            alertType: AlertType.credit,
            transId: "43657657554566NIG",
            ref: "Ref-55654495966966040403455",
          )
        ]));
  }
}
