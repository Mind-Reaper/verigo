import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'my_container.dart';

enum AlertType { debit, credit }

class TransactionHistory extends StatelessWidget {
  final String date;

  final double amount;
  final AlertType alertType;
  final String transId;

  final String sender;
  final String receiver;

  const TransactionHistory(
      {Key key,
      this.date,

      this.amount,
      this.alertType,
      this.transId,
       this.sender, this.receiver})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
   DateTime dateTime = DateTime.parse(date);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: FloatingContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Flexible(
                child: Text(
                  "${Jiffy(dateTime).format("MMMM d, hh:mm a")}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              SizedBox(width: 20),
              Text('N${amount}0',
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
              "Trans ID: $transId",
              style: TextStyle(color: Color(0xff414141)),


            ),
            if(alertType == AlertType.credit )     SizedBox(height: 8),
      if(alertType == AlertType.credit )     Text('From: $sender'),
            if(alertType == AlertType.debit )   SizedBox(height: 8),
            if(alertType == AlertType.debit )       Text('To: $receiver'),
          ],
        ),
      ),
    );
  }
}
