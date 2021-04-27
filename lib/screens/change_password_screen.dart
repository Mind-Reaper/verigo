import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verigo/pages/profile_page.dart';
import 'package:verigo/providers/authentication_provider.dart';
import 'package:verigo/providers/user_provider.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';


import '../constants.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {

  final BuildContext context;


  const ChangePasswordScreen({Key key, this.context}) : super(key: key);


  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}


class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  TextEditingController current = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirm = TextEditingController();


  String confirmError = '';
  String currentError = '';
  String newPassError = '';
  bool buttonActive = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    current.addListener(() {
      setState(() {


      if(current.text.trim().length < 8) {
        currentError = 'Password is too short';
      } else {
        currentError = null;
      }
      });
      activateButton();
    });
    newPass.addListener(() {
      Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
      setState(() {


        if(newPass.text.trim().length < 8) {
          newPassError = 'Password is too short';
        } else if(!RegExp(pattern).hasMatch(newPass.text)) {
          newPassError = 'Password must contain a lowercase, uppercase, and number';
        }
        else
          {
          newPassError = null;
        }
      });
      activateButton();
    });
    confirm.addListener(() {
      setState(() {


        if(confirm.text != newPass.text) {
          confirmError = 'Please ensure password do match';
        }
        else {
          confirmError = null;
        }
      });
      activateButton();
    });
  }

  activateButton() {
    if(newPassError == null && currentError ==null && confirmError == null  ) {
      setState(() {
        buttonActive = true;

      });
    } else {
      setState(() {
        buttonActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var authProvider  = Provider.of<AuthenticationProvider>(context);
    var userProvider  = Provider.of<UserProvider>(context);
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
                    controller: current,
                      obscureText: true,
                      decoration: fieldDecoration.copyWith(
                        errorText: currentError,
                          hintText: 'Current Password')),
                  SizedBox(height: 20),
                  TextField(
                    controller: newPass,
                      obscureText: true,
                      decoration:
                          fieldDecoration.copyWith(

                            errorText: newPassError,
                              hintText: 'New Password')),
                  SizedBox(height: 20),
                  TextField(
                    controller: confirm,
                      obscureText: true,
                      decoration: fieldDecoration.copyWith(
                        errorText: confirmError,
                          hintText: 'Confirm New Password')),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 24),
            child: RoundedButton(title: 'Change Password',
              active: buttonActive,
              onPressed: ()  {
              authProvider.changePassword(context,
                accessToken: userProvider.currentUser.accessToken,
                currentPassword: current.text,
                newPassword: newPass.text,
              ).then((value) async {
                if(value)  {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Future.delayed(Duration(seconds: 1));
                  showSnackBarSuccess(widget.context,  'Password changed successfully');
                }
              });
              },

            ),
          )
        ],
      ),
    );
  }
}
