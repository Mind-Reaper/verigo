import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verigo/constants.dart';
import 'package:verigo/providers/state_provider.dart';
import 'package:verigo/screens/after_payment_screen.dart';

import 'package:verigo/screens/new_card_screen.dart';
import 'package:verigo/screens/wallet_screen.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/card.dart';
import 'package:verigo/widgets/my_container.dart';
import 'package:verigo/widgets/wallet_card.dart';

import 'home_screen.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PageController pageController;

  switchPage(int index) {
    setState(() {
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
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
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 115 / 80,
              ),
              shrinkWrap: true,
              children: [
                PaymentMethod(
                  icon: Image(
                    image: AssetImage('assets/images/logo.png'),
                    height: 25,
                  ),
                  title: 'E-Wallet',
                  onPressed: () {
                    switchPage(0);
                  },
                ),
                PaymentMethod(
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
                PaymentMethod(
                  icon: Image(
                    image: AssetImage('assets/images/bank.png'),
                    height: 25,
                  ),
                  title: 'Bank Transfer',
                  onPressed: () {
                    switchPage(2);
                  },
                ),
                PaymentMethod(
                  icon: Image(
                    image: AssetImage('assets/images/naira.png'),
                    height: 25,
                  ),
                  title: 'Pay On Delivery',
                  onPressed: () {
                    switchPage(3);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            constraints: BoxConstraints.loose(Size(double.infinity, 250)),
            child: PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                PaymentOne(),
                PaymentTwo(),
                PaymentThree(),
                PaymentThree(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingContainer(
              child: Column(
                children: [
                  PaymentDetail(
                    title: 'Service Fee + Vat',
                    price: '4000',
                  ),
                  PaymentDetail(
                    title: 'Insurance',
                    price: '50',
                  ),
                  PaymentDetail(
                    title: 'Discount',
                    price: '1000',
                    discount: true,
                  ),
                  PaymentDetail(
                    title: 'Home Delivery',
                    price: '500',
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
                              'N3500',
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
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AfterPaymentScreen(
                                paymentComplete:  paymentMethod == 'E-Wallet' || paymentMethod == 'Card'? true: false,
                                trackingId: '47498285837',
                              )),
                          (Route<dynamic> route) => false);
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
              SizedBox(width: 20,),
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
        padding: false,
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
    return ListView(
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: WalletCard(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
          child: DottedButton(
            title: 'Fund E-Wallet',
            onPressed: () {
              pushPage(context, WalletScreen(walletOption: false));
            },
          ),
        )
      ],
    );
  }
}

class PaymentTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      SizedBox(
        height: 20,
      ),
      CreditCard(
        cardHolder: 'Daniel Onadipe',
        cardId: '001',
        cardIssuer: 'mastercard',
        cardNumber: '5603584434936309',
      ),
      CreditCard(
        cardHolder: 'Lanre Ogundipe',
        cardId: '002',
        cardIssuer: 'visa',
        cardNumber: '6846456348672085',
      ),
      CreditCard(
        cardHolder: 'Kore Fadaini',
        cardId: '003',
        cardIssuer: 'visa',
        cardNumber: '6838592368394392',
      ),
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
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
