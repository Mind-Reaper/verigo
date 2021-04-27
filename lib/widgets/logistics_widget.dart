import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/booking_provider.dart';
import 'package:verigo/providers/state_provider.dart';
import 'package:verigo/widgets/my_container.dart';

class LogisticWidget extends StatelessWidget {
  final String logName;
  final int price;
  final int rating;
  final int totalDeliveries;
  final String distance;
  final int index;
  final bool cod;


  const LogisticWidget({Key key, this.logName, this.price, this.rating, this.totalDeliveries, this.distance, this.index, this.cod}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stateProvider = Provider.of<StateProvider>(context);
    var booking = Provider.of<BookingProvider>(context);
    int selectedLog = stateProvider.selectedLogistic;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: GestureDetector(
      onTap: ()
 {
   stateProvider.changeSelectedLogistic(index);

   booking.selectServiceProvider(index);

 }      ,  child: FloatingContainer(
border: index == selectedLog,
          padding: false,
          child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 30,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25) ,
                          topRight: Radius.circular(18)
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          'N$price',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:16.0),
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image(

                        image: AssetImage('assets/images/logo.png'),
                        height: 45,

                      ),
                    ),
                    SizedBox(width: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Text(
                            logName,
                            style: Theme.of(context).textTheme.button.copyWith(
                                fontWeight: FontWeight.w500, color: Color(0xff414141)
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Wrap(

                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Ratings'
                                ),
                                Container(
                                  height: 10,
                                  width: 80,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: NeverScrollableScrollPhysics(),
itemCount: 5,
                                      itemBuilder: (context, index) {

                                        return Padding(
                                          padding: const EdgeInsets.only(right: 2),
                                          child: Icon(Icons.star,
                                            size: 10,
                                            color: index  < rating ? Colors.yellow[700]: Colors.grey,
                                          ),
                                        );
                                      }

                                  ),
                                )
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text( 'COD'),
                                Text("${cod? 'Yes': 'No'}")
                              ],
                            ),
                            SizedBox(width: 15),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Distance Away'),
                                Text(distance)
                              ],
                            )
                          ],
                        ),

                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 16,)
            ],
          ),

        ),
      ),
    );
  }
}