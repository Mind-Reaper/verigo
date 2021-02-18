import 'package:flutter/material.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';


import '../constants.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        title: 'Change Password',
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
                      decoration: fieldDecoration.copyWith(
                          hintText: 'Current Password')),
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
            child: RoundedButton(title: 'Change Password'),
          )
        ],
      ),
    );
  }
}
