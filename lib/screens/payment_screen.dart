import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verigo/constants.dart';
import 'package:verigo/models/card_model.dart';
import 'package:verigo/providers/booking_provider.dart';
import 'package:verigo/providers/card_provider.dart';
import 'package:verigo/providers/payment_provider.dart';
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

  List<String> reasons = [
    'Wrong booking information',
    'Preferred payment method not avaialble',
    'Logistic fee to expensive',
    'Selected wrong logistic',
    'Total fee to expensive',
    'Changed my mind',
  ];

  bankPay()  {
    var booking = Provider.of<BookingProvider>(context, listen: false);
    booking.updateBooking(context, 3).then((value) {
      if(value) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        pushPage(
            context,
            AfterPaymentScreen(
              paymentComplete: false,
              trackingId: booking.bookingReference,
            ));
      }
    });
  }

  payOnDelivery() {
    var booking = Provider.of<BookingProvider>(context, listen: false);
    booking.updateBooking(context, 3).then((value) {
      if(value) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        pushPage(
            context,
            AfterPaymentScreen(
              paymentComplete: false,
              cod: true,
              trackingId: booking.bookingReference,
            ));
      }
    });
  }

  walletPay() async {
    var result = await showTextInputDialog(
        context: context,
        title: 'Verify Payment',
        message: 'Insert your wallet pin',
        okLabel: 'Pay',
        textFields: [
          DialogTextField(
            obscureText: true,
            hintText: '••••',
          )
        ]);
    print(result);
    if (result != null) {
      var payment = Provider.of<PaymentProvider>(context, listen: false);
      var booking = Provider.of<BookingProvider>(context, listen: false);
      payment
          .payWithWallet(
        context,
        reference: booking.bookingId,
        amount: booking.total,
        pin: result[0],
      )
          .then((value) {
        if (value) {
          print(value);
          Navigator.of(context).popUntil((route) => route.isFirst);
          pushPage(
              context,
              AfterPaymentScreen(
                paymentComplete: true,
                trackingId: payment.trackingId,
              ));
        }
      });
    } else {
      showSnackBar(context, 'Payment Cancelled');
    }
  }

  paystackPay() {
    var payment = Provider.of<PaymentProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    var booking = Provider.of<BookingProvider>(context, listen: false);
    booking
        .updatePaymentPaystack(context,
            amount: booking.total.toInt(), email: userProvider.currentUser.emailAddress)
        .then((value) {
      if (value) {
        print(value);
        Navigator.of(context).popUntil((route) => route.isFirst);
        pushPage(
            context,
            AfterPaymentScreen(
              paymentComplete: true,
              trackingId: payment.trackingId,
            ));
      }
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
    var userProvider = Provider.of<UserProvider>(context);
    var payment = Provider.of<PaymentProvider>(context);
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
                        icon: ImageIcon(
                          AssetImage('assets/images/paystack.png'),
                          size: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: 'Paystack',
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
                          payment.getBanks(context);
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
                  child: Container(),
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
                  child: PaymentFour(),
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
                    title: 'Logistics Fee',
                    price: '${booking.serviceProvider.partnerFee}',
                  ),
                  PaymentDetail(
                    title: 'Service Fee',
                    price: '${booking.serviceFee}',
                  ),
                  PaymentDetail(title: 'Verisure', price: '${booking.veriSure}'),
                  PaymentDetail(
                    title: 'VAT (7.5%)',
                    price: '${booking.vat}',
                  ),
                  PaymentDetail(
                    title: 'Discount',
                    price: 'N${booking.discount ?? "0.00"}',
                    discount: true,
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
                                  .copyWith(fontWeight: FontWeight.w600, fontSize: 23),
                            ),
                            Text(
                              'N${booking.total}',
                              style: Theme.of(context).textTheme.headline3.copyWith(
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
                    onTap: () async {
                      var result = await showOkCancelAlertDialog(
                        context: context,
                        title: 'Cancel Booking',
                        message: 'Are you sure you want to cancel this booking?',
                        cancelLabel: 'No',
                        okLabel: 'Yes',
                      );
                      print(result.index);
                      if (result.index == 0) {
                     var reason =   await showModalActionSheet(
                            context: context,
                            title: 'Cancel Booking',
                            message: "Please tell us why you want to cancel this booking",
                            actions: [
                              SheetAction(label: reasons[0], key: 0),
                              SheetAction(label: reasons[1], key: 1),
                              SheetAction(label: reasons[2], key: 2),
                              SheetAction(label: reasons[3], key: 3),
                              SheetAction(label: reasons[4], key: 4),
                              SheetAction(label: reasons[5], key: 5),
                            ]);
                     booking.cancelBooking(context, reasons[reason]);
                     print(reasons[reason]);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                HomeScreen()),
                                (Route<dynamic> route) => false);
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                          child: Text('Cancel',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: Theme.of(context).primaryColor))),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: RoundedButton(
                    active: paymentMethod == 'E-Wallet'
                        ? userProvider.currentUser.walletBalance > booking.total
                            ? true
                            : false
                        : paymentMethod == 'Pay On Delivery'
                            ? booking.serviceProvider.cod
                                ? true
                                : false
                            : true,
                    title:
                        paymentMethod == 'E-Wallet' || paymentMethod == 'Paystack' ? 'Pay' : 'Done',
                    onPressed: () {
                      int method;
                      if (paymentMethod == 'E-Wallet') {
                        method = 1;
                      } else if (paymentMethod == 'Paystack') {
                        method = 2;
                      } else if (paymentMethod == 'Bank Transfer') {
                        method = 3;
                      } else if(paymentMethod == 'Pay On Delivery') {
                        method = 4;
                      }
                      if (method == 1) {
                        walletPay();
                      }
                      if (method == 2) {
                        paystackPay();
                      }
                      if(method ==3) {
                        bankPay();
                      }
                      if(method == 4) {
                        payOnDelivery();
                      }
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

  const PaymentDetail({Key key, this.title, this.price, this.discount: false}) : super(key: key);

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
                  style:
                      Theme.of(context).textTheme.headline3.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                discount ? "- $price" : "N$price",
                style: Theme.of(context).textTheme.headline3.copyWith(fontWeight: FontWeight.w500),
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

  const PaymentMethod({Key key, this.title, this.icon, this.onPressed}) : super(key: key);

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
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(color: Theme.of(context).primaryColor, fontSize: 16),
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

class PaymentOne extends StatefulWidget {
  @override
  _PaymentOneState createState() => _PaymentOneState();
}

class _PaymentOneState extends State<PaymentOne> {
  double amount = 0.00;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var booking = Provider.of<BookingProvider>(context);
    var payment = Provider.of<PaymentProvider>(context);
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: FloatingContainer(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  Container(
                      height: 70,
                      width: 50,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/images/logo.png')))),
                  SizedBox(width: 20),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      'Wallet Balance',
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(height: 5),
                    FittedBox(
                      child: Text(
                        "N${userProvider.currentUser.walletBalance}",
                        style: Theme.of(context).textTheme.button.copyWith(
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
            ]),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              child: booking.total > userProvider.currentUser.walletBalance
                  ? Stack(
                      children: [
                        TextField(
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true, decimal: true),
                          inputFormatters: [MoneyInputFormatter()],
                          onChanged: (value) {
                            setState(() {
                              String finalInput = value.replaceAll('.00', '').replaceAll(',', '');
                              amount = double.parse(finalInput);
                            });
                          },
                          decoration: fieldDecoration.copyWith(
                            fillColor: Colors.white,
                            hintText: 'Enter amount you want to add to wallet',
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              if (amount >= 100) {
                                payment.fundWallet(
                                    context, amount.toInt(), userProvider.currentUser.emailAddress);
                              }
                            },
                            child: Container(
                              height: 44,
                              width: 80,
                              decoration: BoxDecoration(
                                  color:
                                      amount >= 100 ? Theme.of(context).primaryColor : Colors.grey,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    topRight: Radius.circular(18),
                                    bottomRight: Radius.circular(18),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: FittedBox(
                                    child: Text(
                                      'Fund',
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            )),
      ],
    );
  }
}

class PaymentTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cardModel = Provider.of<CreditCardProvider>(context);
    return ListView(shrinkWrap: true, physics: NeverScrollableScrollPhysics(), children: [
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
    var booking = Provider.of<BookingProvider>(context);
    var payment = Provider.of<PaymentProvider>(context);
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
                  "After making bank deposit into any of the accounts listed below using '${booking.bookingReference}' as the reference, send a note to payments@verigo.com",
                  style: TextStyle(height: 1, fontSize: 17, color: Color(0xff414141)),
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

class PaymentFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var booking = Provider.of<BookingProvider>(context);
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
                  booking.serviceProvider.cod
                      ? 'Pay when your parcels get delivered'
                      : 'Pay On Delivery is not available for this logistic provider.',
                  style: TextStyle(height: 1, fontSize: 17, color: Color(0xff414141)),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
