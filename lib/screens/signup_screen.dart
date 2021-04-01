import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verigo/models/user_model.dart';
import 'package:verigo/providers/authentication_provider.dart';
import 'package:verigo/providers/user_provider.dart';
import 'package:verigo/screens/verification_screen.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';

import '../constants.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  String emailError = '';

  String firstnameError = '';

  String lastnameError = '';
  String passwordError = '';

  IconData passIcon = Icons.visibility;
  String confirmPasswordError = '';

  bool obscureText = true;

  String phoneError = '';
  String code = '0000';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstname.addListener(() {
      setState(() {
        if (firstname.text.trim().length < 3 ||
            firstname.text.trim().length > 20) {
          firstnameError = 'Name is too short or too long';
        } else {
          firstnameError = null;
        }
      });
      activateButton();
    });
    lastname.addListener(() {
      setState(() {
        if (lastname.text.trim().length < 3 ||
            lastname.text.trim().length > 20) {
          lastnameError = 'Name is too short or too long';
        } else {
          lastnameError = null;
        }
      });
      activateButton();
    });
    email.addListener(() {
      setState(() {
        if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email.text)) {
          emailError = 'Invalid email address';
        } else {
          emailError = null;
        }
      });
      activateButton();
    });
    phoneNumber.addListener(() {
      setState(() {

        if (phoneNumber.text.trim().replaceAll(' ', '').length < 14 ||
            phoneNumber.text.trim().replaceAll(' ', '').length > 14) {
          phoneError = 'Mobile number is too short or too long';
        } else {
          phoneError = null;
        }
      });
      activateButton();
    });
    password.addListener(() {
      setState(() {
        if (password.text.trim().length < 8) {
          passwordError = 'Password is too short or too long';
        } else {
          passwordError = null;
        }
      });
      activateButton();
    });
    confirmPassword.addListener(() {
      setState(() {
        if (confirmPassword.text.trim() != password.text.trim()) {
          confirmPasswordError = "Doesn't match above password";
        } else {
          confirmPasswordError = null;
        }
      });
      activateButton();
    });
  }

  bool buttonActive = false;

  activateButton() {
    if (firstnameError == null &&
        lastnameError == null &&
        emailError == null &&
        phoneError == null &&
        passwordError == null &&
        confirmPasswordError == null) {
      setState(() {
        buttonActive = true;
      });
    } else {
      setState(() {
        buttonActive = false;
      });
    }
  }

  signUp() async {
    var authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    await authProvider
        .createUserWithEmail(
      name: firstname.text,
      surname: lastname.text,
      email: email.text,
      phoneNumber: phoneNumber.text.replaceAll(' ', ''),
      password: password.text,
    )
        .then((value) {
      if (value) {
        pushPage(
            context,
            VerificationScreen(
              header: 'Verification',
              info:
                  'Please verify the 4-digits code sent to your mobile number',
              onSubmitted: (code) async {
                if (code.length == 4) {
                  await authProvider
                      .verifyPhoneNumber(otp: code)
                      .then((value) async {
                    if (value) {
                      await authProvider
                          .tokenAuth(email.text, password.text)
                          .then((value) async {
                        if (value.length > 5) {
                          EasyLoading.show(status: 'Signing in');
                          await userProvider.logout();
                          await userProvider.saveUser(User(accessToken: value));
                          await authProvider
                              .getCurrentUser(context)
                              .then((userMap) async {
                            if (userMap != null) {
                              await userProvider.updateUser(User(
                                name: userMap['name'],
                                surname: userMap['surname'],
                                emailAddress: userMap['emailAddress'],
                                id: userMap['id'],
                                walletBalance: userMap['wallatBalance'],
                                verigoNumber: userMap['affiliateCode'],
                              ));


                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                  (Route<dynamic> route) => false);
                              EasyLoading.dismiss();
                            } else {
                              EasyLoading.showInfo(
                                  "Couldn't Sign In Automatically, Go to Sign In page and log in to your account",
                                  duration: Duration(seconds: 3));
                              Navigator.pop(context);
                            }
                          });
                        } else {
                          EasyLoading.showInfo(
                              "Couldn't Sign In Automatically, Go to Sign In page and log in to your account",
                              duration: Duration(seconds: 3));
                          Navigator.pop(context);
                        }
                      });
                    } else {
                      EasyLoading.showError('Wrong OTP Code');
                    }
                  });
                } else {
                  EasyLoading.showToast('Invalid OTP');
                }
              },
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context, brightness: Brightness.light),
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
                controller: firstname,
                decoration: fieldDecoration.copyWith(
                    errorText: firstnameError, hintText: 'Your first name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: lastname,
                decoration: fieldDecoration.copyWith(
                    errorText: lastnameError, hintText: 'Your last name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: fieldDecoration.copyWith(errorText: emailError),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneNumber,
                inputFormatters: [PhoneInputFormatter()],
                keyboardType: TextInputType.phone,
                decoration: fieldDecoration.copyWith(
                    errorText: phoneError,
                    hintText:
                        "Mobile number (start with country code e.g '234')"),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: obscureText,
                controller: password,
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
                controller: confirmPassword,
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
                active: buttonActive,
                onPressed: () {
                  signUp();
                },
              ),
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
