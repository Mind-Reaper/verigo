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


  const LogisticWidget({Key key, this.logName, this.price, this.rating, this.totalDeliveries, this.distance, this.index}) : super(key: key);

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
                    Image(

                      image: AssetImage('assets/images/logo.png'),
                      height: 45,

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
                                  child: rating < 1 ? Text('None') :ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: rating,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 2),
                                          child: Icon(Icons.star,
                                            size: 10,
                                            color: Colors.yellow[700],
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
                                Text('Total Deliveries'),
                                Text('$totalDeliveries')
                              ],
                            ),
                            SizedBox(width: 15),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Distance'),
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