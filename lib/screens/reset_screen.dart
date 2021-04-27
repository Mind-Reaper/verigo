import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:verigo/constants.dart';
import 'package:verigo/providers/authentication_provider.dart';
import 'package:verigo/screens/login_screen.dart';
import 'package:verigo/screens/verification_screen.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {

  String emailError = '';

  TextEditingController emailController = TextEditingController();


   getCode() async {


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.addListener(() {
      setState(() {
        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailController.text)) {
          emailError = 'Invalid email address';
        } else {
          emailError = null;
        }
      });

    });
  }

  @override
  Widget build(BuildContext context) {
     var authProvider = Provider.of<AuthenticationProvider>(context);
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
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: fieldDecoration.copyWith(
                errorText: emailError,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: RoundedButton(
              title: 'Reset Password',
              active: emailError == null,
              onPressed: () {
//
authProvider.forgotPassword(context, emailController.text).then((userId) {
  if(userId!=null) {
    pushPage(context, VerificationScreen(
                  header: 'Password Reset',
                  longCode: true,
                  info: 'Please input the recovery code sent to your email address/mobile number to proceed with your password reset.',

                  onSubmitted: (code) {
                  authProvider.verifyCode(context, userId, code).then((value) {
                    if(value) {
                      pushPage(context, PasswordReset(userId: userId,));
                    }
                  });


                  },
                ));
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


class PasswordReset extends StatefulWidget {

  final int userId;

  const PasswordReset({Key key, this.userId}) : super(key: key);


  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {

  TextEditingController newPass = TextEditingController();
  String newPassError = '';
  bool obscureText = true;
  IconData passIcon = Icons.visibility;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

    });
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthenticationProvider>(context);
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
                    controller: newPass,
                    obscureText: obscureText,
                      decoration:
                      fieldDecoration.copyWith(hintText: 'New Password',
                        errorText: newPassError,
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
                      )),

                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RoundedButton(title: 'Reset Password',
            active: newPassError == null,
              onPressed: ()  {
              authProvider.resetPassword(context, widget.userId , newPass.text).then((value) async {
                if(value) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen()),
                       );
                  await Future.delayed(Duration(seconds: 1));
                EasyLoading.showSuccess('Password Reset Successful');

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
