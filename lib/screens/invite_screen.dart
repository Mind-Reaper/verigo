import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:verigo/providers/state_provider.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';

import '../constants.dart';

class InviteScreen extends StatelessWidget {
  TextEditingController textController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    textController.text = Provider.of<StateProvider>(context).referralCode;
    return Scaffold(
      backgroundColor: Color(0xfff6f6f6),
      appBar: appBar(context,
      title: 'Invite A Friend',
        centerTitle: false,
        blackTitle: true,
          backgroundColor: Colors.transparent,
        brightness: Brightness.light
      ),
      body: ListView(
        children: [
          SizedBox(height: 50,),
          Image(
            image: AssetImage('assets/images/broadcast.png'),
            height: 120,
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'Invite a friend and get N200 when they sign up with your referral code and make their first delivery request.',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Stack(
                  children: [
                    Container(
height: 50,
                      width: double.infinity,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'VERIME2021',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),

                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          copy(context, 'VERISURE');
                        },
                        child: Container(
height: 50,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                topRight: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  'Copy',
                                  style: Theme.of(context).textTheme.button,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(height: 100,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DottedBorder(
                padding: EdgeInsets.zero,
              color: Colors.grey,
                dashPattern: [2, 6],
                child: Container()),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RoundedButton(
              title: 'Share',
              active: true,
              onPressed: () {
                Share.share('VERIME2021', subject: 'Join Verigo with my referral code');
              },
            ),
          )
        ],
      ),
    );
  }
}
