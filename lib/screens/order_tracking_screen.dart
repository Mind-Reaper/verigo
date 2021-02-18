import 'package:flutter/material.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/buttons.dart';
import 'package:verigo/widgets/my_container.dart';

enum StatusProgress { pending, progress, done }



class TrackingScreen extends StatefulWidget {
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}



StatusProgress orderPlacedStatus = StatusProgress.done;
StatusProgress pendingStatus = StatusProgress.done;
StatusProgress enrouteStatus = StatusProgress.done;
StatusProgress deliveredStatus = StatusProgress.done;

class _TrackingScreenState extends State<TrackingScreen> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Color(0xfff6f6f6),
      appBar: appBar(context,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          title: 'Tracking ID-58398595',
          centerTitle: false,
          blackTitle: true),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingContainer(
                width: double.infinity,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  OrderStatus(
                    title: 'Order Placed',
                    statusProgress: orderPlacedStatus,


                    date: 'Wednesday 13-01',
                  ),
                  OrderStatus(
                    title: 'Pending Confirmation',
                    statusProgress: pendingStatus,

                    date: 'Wednesday 13-01',
                  ),
                  OrderStatus(
                    title: 'Shipment Enroute',
                    statusProgress: enrouteStatus,

                    date: 'Wednesday 13-01',
                  ),
                  OrderStatus(
                    title: 'Parcel Delivered',
                    statusProgress: deliveredStatus,

                    date: 'Wednesday 13-01',
                    showDivider: false,
                  ),


                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: RoundedButton(
              active: true,
              title: 'Rate Your Experience',
              onPressed: () {

              },
            ),
          )
        ],
      ),
    );
  }
}

class OrderStatus extends StatelessWidget {
  final String title;
  final bool showDivider;

  final StatusProgress statusProgress;
  final String date;

  const OrderStatus({Key key, this.title, this.showDivider: true,  this.statusProgress, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
           statusProgress == StatusProgress.done ?  Icons.check_circle_rounded
               : statusProgress == StatusProgress.pending ? Icons.swap_horizontal_circle
              :  Icons.swap_horizontal_circle ,
              color: statusProgress == StatusProgress.done ? showDivider ? primaryColor : Colors.green
                  : statusProgress == StatusProgress.pending ? Colors.grey :

              primaryColor,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer(title: title,
                  color: statusProgress == StatusProgress.done ? showDivider ? primaryColor : Colors.green
                  : statusProgress == StatusProgress.pending ? Colors.grey :

                primaryColor,),
                SizedBox(height: 5,),
                Text(date)
              ],
            ),
          ],
        ),
      if(showDivider)  SpaceDivider( color: statusProgress == StatusProgress.done ? showDivider ? primaryColor : Colors.green
          : statusProgress == StatusProgress.pending ? Colors.grey :

      primaryColor,)
      ],
    );
  }
}

class SpaceDivider extends StatelessWidget {
  final Color color;

  const SpaceDivider({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(width: 6.5,),
          SizedBox(
            height: 40,

            child: VerticalDivider(
              thickness: 2.5,
              color: color,
            ),
          )
        ],
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String title;
  final Color color;

  const CustomContainer({Key key, this.title, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
