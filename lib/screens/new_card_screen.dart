import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_expiration_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_number_input_formatter.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';


import '../constants.dart';
import 'login_screen.dart';

class NewCardScreen extends StatefulWidget {
  @override
  _NewCardScreenState createState() => _NewCardScreenState();
}

class _NewCardScreenState extends State<NewCardScreen> {
  String cardType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff6f6f6),
        appBar: appBar(context,
            title: 'Add New Card',
            blackTitle: true,
            centerTitle: false,
            brightness: Brightness.light,
            backgroundColor: Colors.transparent),
        body: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text('Card Details'),
                  SizedBox(height: 5),
                  TextField(
                    decoration: fieldDecoration.copyWith(
                      hintText: 'Card Holder Name',
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    inputFormatters: [
                      CreditCardNumberInputFormatter(
                          useSeparators: true,
                          onCardSystemSelected: (data) {
                            if (data.system == 'Visa') {
                              setState(() {
                                cardType = 'visa';
                              });
                            } else if (data.system == 'Mastercard') {
                              setState(() {
                                cardType = 'mastercard';
                              });
                            }
                          })
                    ],
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration.copyWith(
                      hintText: 'Card Number',
                      fillColor: Colors.white,
                      suffix: Image(
                          width: 40,
                          image: AssetImage('assets/images/$cardType.png')),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [CreditCardExpirationDateFormatter()],
                        decoration: fieldDecoration.copyWith(
                          hintText: 'Expiry Date',
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [CreditCardCvcInputFormatter()],
                        decoration: fieldDecoration.copyWith(
                          hintText: 'CVV',
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ])
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RoundedButton(
                title: 'Proceed',
                active: true,
              ),
            )
          ],
        ));
  }
}
