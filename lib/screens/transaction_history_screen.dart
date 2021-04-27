

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/payment_provider.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/transaction_history_widget.dart';


class TransactionHistoryScreen extends StatefulWidget {
  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {


  Future yourFuture;

  Future<void> reloadPage() async {
    var payment = Provider.of<PaymentProvider>(context, listen: false);
    yourFuture = payment.getWalletTransactions(context);
    await Future.delayed(Duration(seconds: 5));

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reloadPage();
  }


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
        body: RefreshIndicator(
          onRefresh: reloadPage,
          color: Theme
              .of(context)
              .primaryColor,
          child: FutureBuilder(
            future: yourFuture,
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                  ),
                );
              }
              if(snapshot.data.isEmpty) {
                return ListView(
                  children: [
                    Text('No transaction History!\nDrag page down to reload',
                      style: TextStyle(height: 1.2),
                      textAlign: TextAlign.center,
                    )
                  ],
                );
              }

              return ListView.builder(
                itemCount: snapshot.data.length,

                  itemBuilder: (context, index) {
                  WalletTransaction transaction = snapshot.data[index];

                  return TransactionHistory(
                    transId: transaction.id,
                    sender: transaction.sender,
                    date: transaction.createdOn,
                    receiver: transaction.receiver,
                    alertType: transaction.isCredit ? AlertType.credit : AlertType.debit,
                    amount: transaction.amount,
                  );
                  }
              );
            },
          )
        )
    );
  }
}
