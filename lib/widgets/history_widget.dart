import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'my_container.dart';

class OrderHistory extends StatelessWidget {
  final String orderId;
  final String timestamp;
  final String orderStatus;
  final String logistics;
  final bool verisure;

  const OrderHistory(
      {Key key,
      this.orderId,
      this.timestamp,
      this.orderStatus,
      this.logistics,
      this.verisure: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(timestamp);
    return FloatingContainer(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 25),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Ref-$orderId',
                    style: Theme.of(context).textTheme.bodyText1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    Jiffy(dateTime).format('MMMM d, hh:mm a'),
                    // style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageIcon(
                    AssetImage('assets/images/delivered.png'),
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text(orderStatus,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xff414141))),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Logistics',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff414141))),
                                SizedBox(height: 3),
                                Text(logistics),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Verisure Premium',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff414141))),
                                SizedBox(height: 3),
                                Text(verisure? 'Yes': 'No'),
                              ],
                            )
                          ])
                    ],
                  )
                ])
          ],
        ));
  }
}
