import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verigo/constants.dart';
import 'package:verigo/models/card_model.dart';
import 'package:verigo/providers/booking_provider.dart';
import 'package:verigo/providers/card_provider.dart';
import 'package:verigo/providers/state_provider.dart';
import 'package:verigo/providers/user_provider.dart';
import 'package:verigo/screens/after_payment_screen.dart';

import 'package:verigo/screens/new_card_screen.dart';
import 'package:verigo/screens/wallet_screen.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/card.dart';
import 'package:verigo/widgets/custom_page_view.dart';
import 'package:verigo/widgets/my_container.dart';
import 'package:verigo/widgets/wallet_card.dart';

import 'home_screen.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PageController pageController;
  double pageHeight;

  switchPage(int index) async {
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    });
  }

  setPageHeight(double height) {
    if (mounted)
      setState(() {
        pageHeight = height;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
    var stateProvider = Provider.of<StateProvider>(context, listen: false);
    stateProvider.changeSelectedPayment('E-Wallet');
  }

  @override
  Widget build(BuildContext context) {
    String paymentMethod = Provider.of<StateProvider>(context).selectedPayment;
    var booking = Provider.of<BookingProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xfff6f6f6),
      appBar: appBar(
        context,
        backgroundColor: Colors.transparent,
        title: 'Payment Method',
        blackTitle: true,
        centerTitle: false,
        brightness: Brightness.light,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: PaymentMethod(
                        icon: Image(
                          image: AssetImage('assets/images/logo.png'),
                          height: 25,
                        ),
                        title: 'E-Wallet',
                        onPressed: () {
                          switchPage(0);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: PaymentMethod(
                        icon: Icon(
                          FontAwesomeIcons.creditCard,
                          size: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: 'Card',
                        onPressed: () {
                          switchPage(1);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: PaymentMethod(
                        icon: Image(
                          image: AssetImage('assets/images/bank.png'),
                          height: 25,
                        ),
                        title: 'Bank Transfer',
                        onPressed: () {
                          switchPage(2);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: PaymentMethod(
                        icon: Image(
                          image: AssetImage('assets/images/naira.png'),
                          height: 25,
                        ),
                        title: 'Pay On Delivery',
                        onPressed: () {
                          switchPage(3);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: pageHeight,
            child: ExpandablePageView(
              pageController: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                SizeReportingWidget(
                  child: PaymentOne(),
                  onSizeChange: (size) {
                    setPageHeight(size.height);
                  },
                ),
                SizeReportingWidget(
                  child: PaymentTwo(),
                  onSizeChange: (size) {
                    setPageHeight(size.height);
                  },
                ),
                SizeReportingWidget(
                  child: PaymentThree(),
                  onSizeChange: (size) {
                    setPageHeight(size.height);
                  },
                ),
                SizeReportingWidget(
                  child: PaymentThree(),
                  onSizeChange: (size) {
                    setPageHeight(size.height);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingContainer(
              child: Column(
                children: [
                  PaymentDetail(
                    title: 'Service Fee',
                    price: '${booking.serviceFee}',
                  ),
                  PaymentDetail(
                    title: 'Verisure (Premium Protection)',
                    price: '${booking.veriSure}'
                  ),
                  PaymentDetail(
                    title: 'Discount',
                    price: '${booking.couponValue?? '0.00'}',
                    discount: true,
                  ),
                  PaymentDetail(
                    title: 'VAT (7.5%)',
                    price: '100',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 24,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 23),
                            ),
                            Text(
                              'N${booking.serviceProvider.total}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 23,
                                      color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false);
                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                          child: Text('Cancel',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(
                                      color: Theme.of(context).primaryColor))),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: RoundedButton(
                    active: true,
                    title:
                        paymentMethod == 'E-Wallet' || paymentMethod == 'Card'
                            ? 'Pay'
                            : 'Done',
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      pushPage(
                          context,
                          AfterPaymentScreen(
                            paymentComplete: paymentMethod == 'E-Wallet' ||
                                    paymentMethod == 'Card'
                                ? true
                                : false,
                            trackingId: '47498285837',
                          ));
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PaymentDetail extends StatelessWidget {
  final String title;
  final String price;
  final bool discount;

  const PaymentDetail({Key key, this.title, this.price, this.discount: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                discount ? "- N$price" : "N$price",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          DottedBorder(
              padding: EdgeInsets.zero,
              color: Colors.grey,
              dashPattern: [2, 6],
              child: Container()),
        ],
      ),
    );
  }
}

class PaymentMethod extends StatelessWidget {
  final String title;
  final Widget icon;
  final Function onPressed;

  const PaymentMethod({Key key, this.title, this.icon, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stateProvider = Provider.of<StateProvider>(context);
    String selectedPayment = stateProvider.selectedPayment;
    return GestureDetector(
      onTap: () {
        stateProvider.changeSelectedPayment(title);
        onPressed();
      },
      child: FloatingContainer(
        border: title == selectedPayment,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                SizedBox(
                  height: 10,
                ),
                FittedBox(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline3.copyWith(
                        color: Theme.of(context).primaryColor, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: GestureDetector(
            onTap: () {
              pushPage(
                  context,
                  WalletScreen(
                    walletOption: false,
                  ));
            },
            child: FloatingContainer(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            height: 70,
                            width: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/logo.png')))),
                        SizedBox(width: 20),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wallet Balance',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                        color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(height: 5),
                              FittedBox(
                                child: Text(
                                  "N${userProvider.currentUser.walletBalance}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ]),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    )
                  ]),
            ),
          ),
        ),
      ],
    );
  }
}

class PaymentTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cardModel = Provider.of<CreditCardProvider>(context);
    return ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 20,
          ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
            child: DottedButton(
              title: '+ Add a new card',
              onPressed: () {
                pushPage(context, NewCardScreen());
              },
            ),
          )
        ]);
  }
}

class PaymentThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: FloatingContainer(
            child: Column(
              children: [
                Text(
                  'After making bank deposit into any of the accounts listed below using 00001 as the reference, send a note to payments@verigo.com',
                  style: TextStyle(
                      height: 1, fontSize: 17, color: Color(0xff414141)),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "FCMB - 056165165465465\nAccess - 65456456465\nUBA - 56456767564",
                  style: TextStyle(
                      height: 1.5,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
