import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_expiration_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_number_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:verigo/models/card_model.dart';
import 'package:verigo/providers/card_provider.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';


import '../constants.dart';
import 'login_screen.dart';

class NewCardScreen extends StatefulWidget {

final String cardHolder;
final String cardNumber;

final String expiryDate;
final String cardIssuer;
final int index;

  const NewCardScreen({Key key, this.cardHolder, this.cardNumber, this.expiryDate, this.index, this.cardIssuer}) : super(key: key);

  @override
  _NewCardScreenState createState() => _NewCardScreenState();
}

class _NewCardScreenState extends State<NewCardScreen> {
  String cardType;
  String cardHolderError = '';
  String cardNumberError = '';
  String cardExpiryDateError = '';
  String cardCVVError = '';

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController cvv = TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(cardNumberError != null) {
      setState(() {


      name.text = widget.cardHolder;
      date.text = widget.expiryDate;
      cardType = widget.cardIssuer;
      number.text = widget.cardNumber;
      cardExpiryDateError = null;
      cardNumberError = null;
      cardHolderError = null;

        });
    }

    number.addListener(() {
      if (number.text.trim().length < 16 ) {
        setState(() {
          cardNumberError = 'Invalid Number';
        });
      } else {
        cardNumberError = null;
      }
      });
    name.addListener(() {
      if (name.text.trim().length < 7 ) {
        setState(() {
          cardHolderError = 'Input Full Name';
        });
      } else {
        setState(() {
          cardHolderError = null;
        });
      }
    });

    date.addListener(() {
      if (date.text.trim().length < 4 ) {
        setState(() {
          cardExpiryDateError = 'Add Complete Expiry Date';
        });
      } else {
       setState(() {
         cardExpiryDateError = null;
       });
      }
    });

    cvv.addListener(() {
      if (cvv.text.trim().length < 3 ) {
        setState(() {
          cardCVVError = 'CVV should be at least 3 characters';
        });
      } else {
       setState(() {
         cardCVVError = null;
       });
      }
    });





  }

UserCreditCard card;
  void compileCard() {
    card = UserCreditCard(cardHolder: name.text, cardIssuer: cardType, cardNumber: number.text, cvv: cvv.text, expiryDate: date.text);
  }

  @override
  Widget build(BuildContext context) {
   var cardModel = Provider.of<CreditCardProvider>(context);
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
                    controller: name,
                    decoration: fieldDecoration.copyWith(
                      errorText: cardHolderError,
                      hintText: 'Card Holder Name',
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: number,
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
                      errorText: cardNumberError,
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
                        controller: date,
                        keyboardType: TextInputType.number,
                        inputFormatters: [CreditCardExpirationDateFormatter()],
                        decoration: fieldDecoration.copyWith(
                          errorText: cardExpiryDateError,
                          hintText: 'Expiry Date',
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: cvv,
                        keyboardType: TextInputType.number,
                        inputFormatters: [CreditCardCvcInputFormatter()],
                        decoration: fieldDecoration.copyWith(
                          errorText: cardCVVError,
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
                active: cardNumberError == null && cardHolderError == null && cardCVVError == null && cardExpiryDateError == null ? true : false
            ,
                onPressed: () {
                  compileCard();
                  if(widget.cardNumber != null) {

                    cardModel.updateItem(widget.index, card);
                  } else if(cardModel.creditCardList.contains(card)) {
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Card Already Exists')));
                  }
                  else {

                    cardModel.addItem(card);

                  }
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ));
  }
}
