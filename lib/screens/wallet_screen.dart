import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';
import 'package:verigo/models/card_model.dart';
import 'package:verigo/pages/order_page.dart';
import 'package:verigo/providers/card_provider.dart';
import 'package:verigo/providers/payment_provider.dart';
import 'package:verigo/providers/state_provider.dart';
import 'package:verigo/providers/user_provider.dart';
import 'package:verigo/screens/transaction_history_screen.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/card.dart';
import 'package:verigo/widgets/expanded_section.dart';
import 'package:verigo/widgets/my_container.dart';
import 'package:verigo/widgets/wallet_card.dart';

import '../constants.dart';
import 'new_card_screen.dart';

class WalletScreen extends StatefulWidget {
  final bool walletOption;

  const WalletScreen({Key key, this.walletOption: true}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  PageController pageController = PageController();
  bool walletOption = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pageController.addListener(() {
      if (pageController.page == 0) {
        setState(() {
          if (!walletOption) walletOption = true;
        });
      } else if (pageController.page == 1) {
        setState(() {
          if (walletOption) walletOption = false;
        });
      }
    });
    if (widget.walletOption == false) {
      Timer(Duration(seconds: 1), () {
        if (pageController.hasClients)
          pageController.animateToPage(1,
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var payment = Provider.of<PaymentProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Color(0xfff6f6f6),
        appBar: appBar(context,
            title: 'Wallet',
            blackTitle: true,
            centerTitle: false,
            backgroundColor: Colors.transparent,
            brightness: Brightness.light,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.history,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  pushPage(context, TransactionHistoryScreen());
                },
              )
            ]),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: WalletCard(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        walletOption = true;
                      });
                      pageController.animateToPage(0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.fastOutSlowIn);
                    },
                    child: FloatingContainer(
                      height: 50,
                      border: walletOption,
                      child: Center(
                        child: Text('Transfer',
                            style: Theme.of(context).textTheme.button.copyWith(
                                color: Theme.of(context).primaryColor)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        walletOption = false;
                      });
                      pageController.animateToPage(1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.fastOutSlowIn);
                    },
                    child: FloatingContainer(
                      height: 50,
                      border: !walletOption,
                      child: Center(
                        child: Text('Fund Wallet',
                            style: Theme.of(context).textTheme.button.copyWith(
                                color: Theme.of(context).primaryColor)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: PageView(
            controller: pageController,
            // physics: NeverScrollableScrollPhysics(),
            children: [KeepAlivePage(child: Transfer()), KeepAlivePage(child: FundWallet())],
          )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RoundedButton(
              title: 'Change Wallet Pin',
              active: true,
onPressed: () async {
  var result = await showTextInputDialog(
      context: context,
      title: 'Change Wallet Pin',
      message: 'Insert your current pin and old pin',
      okLabel: 'Change',
      textFields: [
        DialogTextField(
          obscureText: true,

          hintText: 'Current 4-digit Pin',
        ),
        DialogTextField(
          obscureText: true,
          hintText: 'New 4-digit Pin',
        )
      ]);
  if(result!=null) {

      if(result[0].length == 4 && result[1].length == 4) {
        print(result);
        payment.changeWalletPin(context, result[0], result[1]).then((value) {
          if(value) {
            showSnackBarSuccess(context, 'Wallet Pin Updated');
          }
        });
      } else {
        showSnackBar(context, 'Pins must be 4 digits');
      }

  }
},
            ),
          ),
          SizedBox(height: 10,)
        ]),
      ),
    );
  }
}

class Transfer extends StatefulWidget {
  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  TextEditingController recipient = TextEditingController();
  int amount = 0;
  String recipientError = '';

  changeAmount(String input) {
    setState(() {
      if (input.length > 0) {
        String finalInput = input.replaceAll('.00', '').replaceAll(',', '');
        amount = int.parse(finalInput);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recipient.addListener(() {
      setState(() {
        if (recipient.text.trim().length < 11 ||
            recipient.text.trim().length > 11) {
          recipientError = 'Mobile number is too short';
        } else if (!recipient.text.trim().startsWith('0')) {
          recipientError = 'Begin number with 0';
        }
        else {
          recipientError = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var payment = Provider.of<PaymentProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: ListView(children: [
        SizedBox(
          height: 20,
        ),
        TextField(
          controller: recipient,
        maxLength: 11,
          keyboardType: TextInputType.number,
          decoration: fieldDecoration.copyWith(
            hintText: 'Mobile number of recipient',
            errorText: recipientError,

            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          inputFormatters: [MoneyInputFormatter()],
          onChanged: (input) {
            changeAmount(input);
          },
          decoration: fieldDecoration.copyWith(
            hintText: 'Amount',
            fillColor: Colors.white,
          ),
        ),
        // SizedBox(height: 15),
        // TextField(
        //   minLines: 4,
        //   maxLines: 4,
        //   decoration: fieldDecoration.copyWith(
        //     hintText: 'Description',
        //     fillColor: Colors.white,
        //   ),
        // ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: RoundedButton(
            active: recipientError == null && amount >= 10,
            title: 'Send',
            onPressed: () async {
              var result = await showTextInputDialog(
                  context: context,
                  title: 'Verify Transfer',
                  message: 'Do you want to pay N$amount to ${recipient.text}',
                  okLabel: 'Send',
                  textFields: [
                    DialogTextField(
                      obscureText: true,
                      hintText: 'Enter Wallet Pin',
                    )
                  ]);
              print(result);
              if (result != null) {
                payment.transferWallet(context, amount,
                    formatPhoneNumber(recipient.text), result[0]).then((value) {
                      if(value) {
                        print(value);

                        showSnackBarSuccess(context, 'N$amount has been sent to ${recipient.text}');

                      } else {
                       Timer(Duration(seconds: 3), () {
                         EasyLoading.dismiss();
                       });
                      }
                });
              } else {
                showSnackBar(context, 'Payment Cancelled');
              }
            },
          ),
        )
      ]),
    );
  }
}

class FundWallet extends StatefulWidget {
  @override
  _FundWalletState createState() => _FundWalletState();
}

class _FundWalletState extends State<FundWallet> {
  TextEditingController controller = TextEditingController();

  double amount = 0.00;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      setState(() {
        String finalInput =
            controller.text.replaceAll('.00', '').replaceAll(',', '');
        amount = double.parse(finalInput);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var payment = Provider.of<PaymentProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    // bool isSelected = Provider.of<StateProvider>(context).selectedCard != null;
    var cardModel = Provider.of<CreditCardProvider>(context);
    return ListView(
      children: [
        SizedBox(height: 20),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: cardModel.creditCardList.length,
            itemBuilder: (context, index) {
              UserCreditCard card = cardModel.creditCardList[index];
              return CreditCard(
                cardHolder: card.cardHolder,
                cardIssuer: card.cardIssuer,
                cardNumber: card.cardNumber,
                cvv: card.cvv,
                expiryDate: card.expiryDate,
                index: index,
              );
            }),
        SizedBox(height: 15),
        // Center(
        //
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: controller,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            inputFormatters: [MoneyInputFormatter()],
            decoration: fieldDecoration.copyWith(
              hintText: 'Amount',
              fillColor: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 56.0),
          child: RoundedButton(
            active: amount >= 500,
            title: 'Fund',
            onPressed: () {
              payment
                  .fundWallet(context, amount.toInt(),
                      userProvider.currentUser.emailAddress)
                  .then((value) {
                if (value) {
                  showSnackBarSuccess(context, 'Wallet Funded Successfully');
                }
              });
            },
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
