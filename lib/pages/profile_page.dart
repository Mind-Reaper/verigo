import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/user_provider.dart';
import 'package:verigo/screens/change_password_screen.dart';
import 'package:verigo/widgets/buttons.dart';

import '../constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String phoneNumber;
  String phoneError;
  bool editNumber = false;
  bool editName = false;
  bool editEmail = false;
  bool editSurname = false;
  FocusNode numberFocusNode = FocusNode();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userProvider = Provider.of<UserProvider>(context, listen: false);
        setState(() {
          mobileController.text = '+2348145350249';
          emailController.text = userProvider.email;
          firstnameController.text = userProvider.name;
          lastnameController.text = userProvider.surname;
        });

}
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(

          backgroundColor: Color(0xfff6f6f6),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3.6,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(60),
                            bottomRight: Radius.circular(60))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Profile',
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              .copyWith(color: Colors.white),
                        ),
                        SizedBox(),
                      ],
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height / 5),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 3, color: Colors.white),
                            ),
                            height: 100,
                            width: 100,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      AssetImage('assets/images/verigo_name.png'),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    child: Center(
                                      child: Icon(Icons.camera_alt,
                                          color: Color(0xff414141)),
                                    ),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])
                ],
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListView(
                  children: [
                    Text('Name'),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            enabled: editName,
                            controller: firstnameController,
                            // onChanged: (value) {
                            //   setState(() {
                            //     firstname = value;
                            //   });
                            // },
                            style: TextStyle(color: editName? Color(0xff414141): Colors.grey),
                            decoration: fieldDecoration.copyWith(
                                fillColor: Colors.white,
                                hintText: 'Enter first name'),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                                !editName ? Icons.edit_outlined : Icons.done,
                                color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                if(editName) {
                                  editName = false;
                                } else {
                                  editName = true;

                                }
                              });
                            })
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Surname'),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            enabled: editSurname,
                            controller: lastnameController,
                            // onChanged: (value) {
                            //   setState(() {
                            //     firstname = value;
                            //   });
                            // },
                            style: TextStyle(color: editSurname? Color(0xff414141): Colors.grey),
                            decoration: fieldDecoration.copyWith(
                                fillColor: Colors.white,
                                hintText: 'Enter last name'),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                                !editSurname ? Icons.edit_outlined : Icons.done,
                                color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                if(editSurname) {
                                  editSurname = false;
                                } else {
                                  editSurname = true;

                                }
                              });
                            })
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Email Address'),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            enabled: false,
                            controller: emailController,
                            // onChanged: (value) {
                            //   setState(() {
                            //     lastname = value;
                            //   });
                            // },
                            style: TextStyle(color:  Colors.grey),
                            decoration: fieldDecoration.copyWith(

                                fillColor: Colors.white,
                                hintText: 'Enter email address'),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Mobile number'),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            enabled: editNumber,
                            controller: mobileController,
                            focusNode: numberFocusNode,
                            style: TextStyle(color: editNumber? Color(0xff414141): Colors.grey),
                            inputFormatters: [PhoneInputFormatter()],
                            keyboardType: TextInputType.phone,
                            // onTap: () {
                            //   setState(() {
                            //     mobileController.clear();
                            //   });
                            // },
                            onChanged: (value) {
                              setState(() {
                                phoneNumber = value;
                              });
                            },
                            decoration: fieldDecoration.copyWith(
                                fillColor: Colors.white,
                                errorText: phoneError,
                                hintText: "start with country code e.g '234' "),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                                !editNumber ? Icons.edit_outlined : Icons.done,
                                color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                if(editNumber) {
                                  editNumber = false;
                                } else {
                                  editNumber = true;

                                }
                              });
                            })
                      ],
                    ),
                    SizedBox(height: 30),
                    RoundedButton(
                        title: 'Change Password',
                        active: true,
                        onPressed: () {
                          pushPage(context, ChangePasswordScreen());
                        }),
                    SizedBox(height: 20),
                  ],
                ),
              ))
            ],
          )),
    );
  }
}
