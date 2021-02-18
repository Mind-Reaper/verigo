import 'package:flutter/material.dart';


import 'buttons.dart';
import 'my_container.dart';

class OrderWidget extends StatelessWidget {
  final String username;
  final String orderId;
  final String pickupAddress;
  final String dropoffAddress;
  final String estimatedTime;
  final String distance;
  final String buttonText;
  final Function onPressed;

  const OrderWidget(
      {Key key,
      this.username,
      this.orderId,
      this.pickupAddress,
      this.dropoffAddress,
      this.estimatedTime,
      this.distance,
      this.buttonText,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FloatingContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Flexible(
                child: Text(
                  username,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              SizedBox(width: 20),
              Text('Order ID-$orderId')
            ]),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.radio_button_checked,
                      color: Theme.of(context).primaryColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: SizedBox(
                          height: 50,
                          child: VerticalDivider(
                            thickness: 3.0,
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                  ],
                ),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(pickupAddress,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xff414141))),
                )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estimated Time',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xff414141))),
                        SizedBox(height: 3),
                        Text(estimatedTime),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Distance',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xff414141))),
                        SizedBox(height: 3),
                        Text(distance),
                      ],
                    )
                  ],
                )
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Icon(
                Icons.location_on_outlined,
                color: Theme.of(context).primaryColor,
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(dropoffAddress,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Color(0xff414141))),
              )),
              SizedBox(width: 80),
            ]),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: RoundedButton(
                title: buttonText,
                active: true,
                onPressed: onPressed,
              ),
            )
          ],
        ),
      ),
    );
  }
}
