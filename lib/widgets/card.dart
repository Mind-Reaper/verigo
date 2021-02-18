import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/state_provider.dart';
import 'package:verigo/screens/new_card_screen.dart';
import 'package:verigo/widgets/my_container.dart';

import '../constants.dart';
import 'buttons.dart';
import 'expanded_section.dart';

class CreditCard extends StatelessWidget {
  final String cardIssuer;
  final String cardNumber;
  final String cardId;
  final String cardHolder;

  const CreditCard(
      {Key key, this.cardIssuer, this.cardNumber, this.cardId, this.cardHolder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stateProvider = Provider.of<StateProvider>(context);
    bool expanded = stateProvider.expandedId == cardId;
    bool selected = stateProvider.selectedCard == cardId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          stateProvider.changeSelectedCard(cardId);
          if (expanded) {
            stateProvider.changeExpandedId('000');
          } else {
            stateProvider.changeExpandedId(cardId);
          }
        },
        child: FloatingContainer(
          border: selected,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image(
                        image: AssetImage('assets/images/$cardIssuer.png'),
                        width: 35,
                      ),
                      SizedBox(width: 10),
                      Text(
                          '•••••${cardNumber.substring(cardNumber.length - 4)}'),
                    ],
                  ),
                  Icon(
                      expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey),
                ],
              ),
              ExpandedSection(
                expand: expanded,
                child: Column(children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cardHolder,
                          style: Theme.of(context).textTheme.bodyText1
                        // .copyWith(fontSize: 20)
                      ),
                      Text(
                        cardIssuer.toUpperCase(),
                        // style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: RoundedButton(
                          title: 'Edit',
                          active: true,
                          onPressed: () {
                            pushPage(context, NewCardScreen());
                          },
                        ),
                      ),
                      SizedBox(width: 40),
                      Expanded(
                        child: RoundedButton(
                          title: 'Delete',
                          active: true,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}