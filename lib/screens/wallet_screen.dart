import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';
import 'package:verigo/models/card_model.dart';
import 'package:verigo/providers/card_provider.dart';
import 'package:verigo/providers/state_provider.dart';
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
          if(!walletOption)
          walletOption = true;
        });
      } else if (pageController.page == 1) {
        setState(() {
          if(walletOption)
          walletOption = false;
        });
      }
    });
    if(widget.walletOption == false ) {
      Timer(Duration(seconds: 1), ()
      {
        if (pageController.hasClients)
          pageController.animateToPage(1,
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Theme.of(context).primaryColor)),
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
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Theme.of(context).primaryColor)),
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
          children: [Transfer(), FundWallet()],
        )),
      ]),
    );
  }
}



class Transfer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: ListView(children: [
        TextField(
          keyboardType: TextInputType.number,
          decoration: fieldDecoration.copyWith(
            hintText: 'Mobile number of recipient',
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 15),
        TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [MoneyInputFormatter()],
          decoration: fieldDecoration.copyWith(
            hintText: 'Amount',
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 15),
        TextField(
          minLines: 4,
          maxLines: 4,
          decoration: fieldDecoration.copyWith(
            hintText: 'Description',
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: RoundedButton(
            active: true,
            title: 'Send',
          ),
        )
      ]),
    );
  }
}

class FundWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isSelected = Provider.of<StateProvider>(context).selectedCard != null;
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
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                pushPage(context, NewCardScreen());
              },
              child: DottedBorder(
                dashPattern: [3, 5],
                borderType: BorderType.RRect,
                color: Theme.of(context).primaryColor,
                radius: const Radius.circular(15),
                child: Container(
                  height: 50,
                  width: 150,
                  child: Center(
                    child: Text("+ Add a new card",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        )),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            keyboardType: TextInputType.number,
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
            active: isSelected,
            title: 'Fund',
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}


