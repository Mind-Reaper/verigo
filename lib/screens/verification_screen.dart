import 'package:code_fields/code_fields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:verigo/widgets/appbar.dart';

import '../constants.dart';
import 'home_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String header;
  final String info;
  final bool longCode;
  final ValueChanged<String> onSubmitted;
  final Function onResendCode;

  const VerificationScreen(
      {Key key, this.header, this.info, this.onSubmitted, this.onResendCode, this.longCode: false})
      : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      // border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
      color: Color(0xfff6f6f6),
    );
  }

  bool showCountdown = true;
  bool canSendCode = true;
  CountdownController countdownController = CountdownController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,
          title: 'Verify Mobile Number', brightness: Brightness.light),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
               widget.info,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.0
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: PinPut(
                keyboardType:  widget.longCode ? TextInputType.text : TextInputType.number,
                  fieldsCount: widget.longCode ? 7 : 4,
                  obscureText: widget.longCode ? null : "●",
                  textStyle: TextStyle(color: Colors.white, fontSize: 20),
                  // inputDecoration: fieldDecoration.copyWith(hintText: ''),
                  eachFieldHeight: widget.longCode ? null : 50,
                  eachFieldWidth: widget.longCode ? null : 50,
                  submittedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Theme.of(context).primaryColor,
                  ),
                  selectedFieldDecoration: _pinPutDecoration,
                  followingFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onSubmit: widget.onSubmitted

                  // eachFieldPadding: EdgeInsets.all(8),
                  // onChanged: (value) {
                  //
                  //   if (value.length == 4) {
                  //     if (value == code) {
                  //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  //    builder: (context) => HomeScreen()
                  //  ),
                  //          (Route<dynamic> route) => false
                  //  );
                  //     }
                  //   }
                  // },
                  ),
              ),

            SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {

                  if(!showCountdown) {
                 widget.onResendCode();
                   if(canSendCode) {
                     setState(() {
                   showCountdown = true;

                 });
                     } else {
                     print('error');
                   }



                  }
                },
                child: Text(
                showCountdown ?   'Resend code in' : 'Resend Code',
                  style: TextStyle(
                    fontSize: 20,
                    color: showCountdown ? Colors.grey : Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(width: 5,),
        if(showCountdown  )    Countdown(seconds: 60,
                  controller: countdownController,
                  onFinished: () {
setState(() {
  showCountdown = false;

});
                  },
                  build: (_, double time) {
                return Text(
                '0:${time.toInt().toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20
                  ),
                );
                  }
              )
            ],
          )
          ],
        ),
      ),
    );
  }
}
