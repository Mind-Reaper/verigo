import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:verigo/screens/reset_screen.dart';
import 'package:verigo/screens/verification_screen.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/my_container.dart';
import '../constants.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String emailError = '';
  String passwordError;
  String password;
  IconData passIcon = Icons.visibility;
  bool obscureText = true;
  String code = '0000';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              namedLogo(),
              Text(
                'Sign In',
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: ListView(
              children: [
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
                SizedBox(height: 20),
                RoundedButton(
                    title: 'Sign In',
                    active: true,
                     // emailError == null && passwordError == null,
                    onPressed: () {
                      pushPage(context, VerificationScreen(
                        header: 'Verification',
                        info: 'Please verify the 4-digits code sent to your mobile number',



                        onSubmitted: (value) {
    if (value.length == 4) {
        if (value == code) {
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
       builder: (context) => HomeScreen()
     ),
             (Route<dynamic> route) => false
     );
        }
      }
                        },
                      ));
                    }),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    pushPage(context, ResetScreen());
                  },
                  child: Center(
                    child: Text('Forgot Password?',
                        style: TextStyle(color: Color(0xff414141), fontSize: 18)),
                  ),
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
                        child: Icon(FontAwesomeIcons.facebookF,
                            color: Colors.blue),
                      ),
                    ),
                  )
                ]),
                SizedBox(height: 20),
                Center(
                  child: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText2,
                        children: [
                          TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => pushPage(context, SignupScreen()),
                          )
                        ]),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
