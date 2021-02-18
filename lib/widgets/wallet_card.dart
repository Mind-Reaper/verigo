import 'package:flutter/material.dart';

import 'my_container.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingContainer(
      child: Row(children: [
        Container(
            height: 70,
            width: 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logo.png')))),
        SizedBox(width: 20),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Wallet Balance',
            style: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(color: Theme.of(context).primaryColor),
          ),
          SizedBox(height: 5),
          Text(
            "N60,000.75",
            style: Theme.of(context).textTheme.headline2.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ])
      ]),
    );
  }
}