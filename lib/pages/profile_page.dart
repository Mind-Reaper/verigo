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
  String firstNameError;
  String lastNameError;

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
      mobileController.text = userProvider.currentUser.phoneNumber.replaceFirst('+234', '0');
      print(mobileController.text);
      emailController.text = userProvider.currentUser.emailAddress;
      firstnameController.text = userProvider.currentUser.name;
      lastnameController.text = userProvider.currentUser.surname;
    });

    firstnameController.addListener(() {
      setState(() {
        if (firstnameController.text.trim().length < 3 ||
            firstnameController.text.trim().length > 15) {
          firstNameError = 'Name is too short or long.';
        } else {
          firstNameError = null;
        }
      });
    });

    lastnameController.addListener(() {
      setState(() {
        if (lastnameController.text.trim().length < 3 ||
            lastnameController.text.trim().length > 15) {
          lastNameError = 'Surname is too short or long.';
        } else {
          lastNameError = null;
        }
      });
    });

    mobileController.addListener(() {
      setState(() {
        if (mobileController.text.trim().length < 11 || mobileController.text.trim().length > 11) {
          phoneError = 'Mobile number is too short';
        } else if (!mobileController.text.trim().startsWith('0')) {
          phoneError = 'Begin number with 0';
        } else {
          phoneError = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
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
                            bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Profile',
                          style:
                              Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
                        ),
                        SizedBox(),
                      ],
                    ),
                  ),
                  Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                              backgroundImage: AssetImage('assets/images/profilepic.jpg'),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 35,
                                width: 35,
                                child: Center(
                                  child: Icon(Icons.camera_alt, color: Color(0xff414141)),
                                ),
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
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
                            style: TextStyle(color: editName ? Color(0xff414141) : Colors.grey),
                            decoration: fieldDecoration.copyWith(
                                errorText: firstNameError,
                                fillColor: Colors.white,
                                hintText: 'Enter first name'),
                          ),
                        ),
                        IconButton(
                            icon: Icon(!editName ? Icons.edit_outlined : Icons.done,
                                color: Colors.grey),
                            onPressed: () {
                              if (firstNameError == null) {
                                setState(() {
                                  if (editName) {
                                    if(userProvider.currentUser.name != firstnameController.text) {
                                      userProvider.updateUserApi(
                                          context, name: firstnameController.text).then((value) {
                                        if (value) {
                                          editName = false;
                                          showSnackBarSuccess(context, 'Profile Updated');
                                        }
                                      });
                                    } else {
                                      editName = false;
                                    }

                                  } else {
                                    editName = true;
                                  }
                                });
                              }
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
                            style: TextStyle(color: editSurname ? Color(0xff414141) : Colors.grey),
                            decoration: fieldDecoration.copyWith(
                                errorText: lastNameError,
                                fillColor: Colors.white,
                                hintText: 'Enter last name'),
                          ),
                        ),
                        IconButton(
                            icon: Icon(!editSurname ? Icons.edit_outlined : Icons.done,
                                color: Colors.grey),
                            onPressed: () {
                              if (lastNameError == null) {
                                setState(() {
                                  if (editSurname) {
                                    if(userProvider.currentUser.surname != lastnameController.text) {
                                      userProvider.updateUserApi(
                                          context, surname: lastnameController.text).then((value) {
                                        if (value) {
                                          editSurname = false;
                                          showSnackBarSuccess(context, 'Profile Updated');
                                        }
                                      });
                                    } else {
                                      editSurname = false;
                                    }

                                  } else {
                                    editSurname = true;
                                  }
                                });
                              }
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
                            style: TextStyle(color: Colors.grey),
                            decoration: fieldDecoration.copyWith(
                                fillColor: Colors.white, hintText: 'Enter email address'),
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
                            style: TextStyle(color: editNumber ? Color(0xff414141) : Colors.grey),
                            maxLength: 11,
                            keyboardType: TextInputType.phone,
                            // onTap: () {
                            //   setState(() {
                            //     mobileController.clear();
                            //   });
                            // },
                            onChanged: (value) {
                              setState(() {
                                phoneNumber = formatPhoneNumber(value);

                              });
                            },
                            decoration: fieldDecoration.copyWith(
                                fillColor: Colors.white,
                                errorText: phoneError,
                                hintText: "e.g 08145357804"),
                          ),
                        ),
                        IconButton(
                            icon: Icon(!editNumber ? Icons.edit_outlined : Icons.done,
                                color: Colors.grey),
                            onPressed: () {
                              if (phoneError == null) {
                                setState(() {
                                  if (editNumber) {
                                    if(userProvider.currentUser.phoneNumber != phoneNumber) {
                                      userProvider.updateUserApi(
                                          context, mobileNumber: phoneNumber).then((value) {
                                        if (value) {
                                          editNumber = false;
                                          showSnackBarSuccess(context, 'Profile Updated');
                                        }
                                      });
                                    } else {
                                      editNumber = false;
                                    }

                                  } else {
                                    editNumber = true;
                                  }
                                });
                              }
                            })
                      ],
                    ),
                    SizedBox(height: 30),
                    RoundedButton(
                        title: 'Change Password',
                        active: true,
                        onPressed: () {
                          pushPage(context, ChangePasswordScreen(context: context,));
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
