import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'my_container.dart';

enum AlertType { debit, credit }

class TransactionHistory extends StatelessWidget {
  final String date;
  final String time;
  final String amount;
  final AlertType alertType;
  final String transId;
  final String ref;

  const TransactionHistory(
      {Key key,
      this.date,
      this.time,
      this.amount,
      this.alertType,
      this.transId,
      this.ref})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: FloatingContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Flexible(
                child: Text(
                  "$date  $time",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              SizedBox(width: 20),
              Text(amount,
                  style: Theme.of(context).textTheme.headline3.copyWith(
                        color: alertType == AlertType.credit
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w600,
                      )),
            ]),
            SizedBox(height: 8),
            DottedBorder(
                padding: EdgeInsets.zero,
                color: Colors.grey,
                dashPattern: [2, 6],
                child: Container()),
            SizedBox(height: 8),
            Text(
              "E-wallet trans-$transId",
              style: TextStyle(color: Color(0xff414141)),
            ),
            SizedBox(height: 8),
            Text(ref),
          ],
        ),
      ),
    );
  }
}
