import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';

import '../constants.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String email;
  String emailError;
  String firstname;
  String firstnameError;
  String passwordError;
  String password;
  IconData passIcon = Icons.visibility;
  String confirmPasswordError;
  String confirmPassword;
  bool obscureText = true;
  String phoneNumber;
  String phoneError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context,
        brightness: Brightness.light
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: ListView(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Sign Up',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                          )),
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    firstname = value;
                  });
                },
                decoration: fieldDecoration.copyWith(
                    errorText: firstnameError, hintText: 'Your first name'),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                decoration: fieldDecoration.copyWith(errorText: emailError),
              ),
              SizedBox(height: 10),
              TextField(
                inputFormatters: [PhoneInputFormatter()],
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
                decoration: fieldDecoration.copyWith(
                    errorText: phoneError,
                    hintText: "start with country code e.g '+234'"),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: obscureText,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                decoration: fieldDecoration.copyWith(
                  errorText: passwordError,
                  hintText: 'Password',
                  suffix: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (obscureText) {
                          obscureText = false;
                          passIcon = Icons.visibility_off;
                        } else {
                          obscureText = true;
                          passIcon = Icons.visibility;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(passIcon, size: 15, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: obscureText,
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
                  });
                },
                decoration: fieldDecoration.copyWith(
                  errorText: confirmPasswordError,
                  hintText: 'Confirm Password',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {});
                },
                decoration: fieldDecoration.copyWith(
                    hintText: 'Referral Code(Optional)'),
              ),
              SizedBox(height: 20),
              RoundedButton(
                  title: 'Sign Up',
                  active: emailError == null &&
                      passwordError == null &&
                      confirmPasswordError == null),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Divider()),
                  SizedBox(
                    child: Center(child: Text('Or')),
                    width: 40,
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                RaisedButton(
                  shape: CircleBorder(),
                  color: Colors.white,
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 30,
                      child: Image(
                        image: AssetImage('assets/images/google.png'),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 0),
                RaisedButton(
                  shape: CircleBorder(),
                  color: Colors.white,
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 30,
                      child:
                          Icon(FontAwesomeIcons.facebookF, color: Colors.blue),
                    ),
                  ),
                )
              ]),
              SizedBox(height: 20),
            ],
          ),
        ));
  }
}
