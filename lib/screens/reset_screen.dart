import 'package:flutter/material.dart';
import 'package:verigo/constants.dart';
import 'package:verigo/screens/verification_screen.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String code = '0000';

   getCode() async {


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: appBar(context,
brightness: Brightness.light,

),
      body: Column(

        children: [
          SizedBox(height: 30,),
          Center(
            child: Text('Password Reset',
            style: Theme.of(context).textTheme.headline2.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor
            ),
            ),

          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: fieldDecoration,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: RoundedButton(
              title: 'Reset Password',
              active: true,
              onPressed: () {
                pushPage(context, VerificationScreen(
                  header: 'Password Reset',
                  info: 'Please input the 4-digit recovery code sent to your email address/mobile number to proceed with your password reset.',
                  onResendCode: getCode(),
                  onSubmitted: (value) {
                    if(value == code ) {
pushPage(context, PasswordReset());
                    }
                  },
                ));
              },
            ),
          )
        ],

      ),
    );
  }
}


class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: appBar(context,
title: 'Password Reset',
brightness: Brightness.light
),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Container(
                      height: 70,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/padlock.png')))),
                  SizedBox(height: 20),

                  TextField(
                      decoration:
                      fieldDecoration.copyWith(hintText: 'New Password')),
                  SizedBox(height: 20),
                  TextField(
                      decoration: fieldDecoration.copyWith(
                          hintText: 'Confirm New Password')),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RoundedButton(title: 'Reset Password',
            active: true,
            ),
          )
        ],
      ),
    );
  }
}
