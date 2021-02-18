import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:verigo/constants.dart';
import 'package:verigo/screens/invite_screen.dart';
import 'package:verigo/screens/wallet_screen.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/my_container.dart';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f6f6),
      appBar: appBar(context,
          backgroundColor: Colors.transparent,
          title: 'More',
          blackTitle: true,
          centerTitle: false,
          brightness: Brightness.light,
        showbackArrow: false
      ),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: GestureDetector(
              onTap: () {
                pushPage(context, WalletScreen());
              },
              child: FloatingContainer(
                color: Theme.of(context).primaryColor,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                              height: 70,
                              width: 50,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/logo_white.png')))),
                          SizedBox(width: 20),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Wallet Balance',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .copyWith(color: Colors.white),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "N60,000.75",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ]),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                      )
                    ]),
              ),
            ),
          ),
          SizedBox(height: 10,),
          MoreOption(
            title: 'Push Notifications',
            icon: Icons.notifications_active_outlined,
            onPressed: () {},
          ),
          MoreOption(
            title: 'Privacy Policy',
            icon: Icons.policy_outlined,
            onPressed: () {},
          ),
          MoreOption(
            title: 'Terms and Conditions',
            icon: FontAwesomeIcons.fileContract,
            onPressed: () {},
          ),
          MoreOption(
            title: 'Frequently Asked Questions',
            icon: FontAwesomeIcons.questionCircle,
            onPressed: () {},
          ),
          MoreOption(
            title: 'Invite Friends',
            icon: Icons.share_outlined,
            onPressed: () {
              pushPage(context, InviteScreen());
            },
          ),
          MoreOption(
            title: 'About Verigo',
            icon: FontAwesomeIcons.infoCircle,
            onPressed: () {},
          ),
          MoreOption(
            title: 'Rate Our App',
            icon: FontAwesomeIcons.star,
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RoundedButton(
              title: 'Logout',
              active: true,

            ),
          )
        ],
      ),
    );
  }
}

class MoreOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onPressed;

  const MoreOption({Key key, this.title, this.icon, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16 ,top: 24,),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Theme.of(context).primaryColor,
                      size: 27,
                    ),
                    SizedBox(width: 20),
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 17,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            DottedBorder(
                padding: EdgeInsets.zero,
                color: Colors.grey,
                dashPattern: [2, 6],
                child: Container()),
          ],
        ),
      ),
    );
  }
}
