import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/user_provider.dart';

import 'my_container.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return FloatingContainer(
      child: Row(children: [
        Container(
            height: 70,
            width: 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logo.png')))),
        SizedBox(width: 20),
        Expanded(
          child:
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
              "N${userProvider.currentUser.walletBalance}",
              style: Theme.of(context).textTheme.headline2.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ]),
        )
      ]),
    );
  }
}
