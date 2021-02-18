import 'package:flutter/material.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/notification_widget.dart' as notify;


import '../constants.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'notify',
        child: Scaffold(
          backgroundColor: Color(0xfff6f6f6),
          appBar: appBar(
            context,
            title: 'Notifications',
            backgroundColor: Colors.transparent,
            centerTitle: false,
            blackTitle: true,
            brightness: Brightness.light
          ),
          body: ListView(children: [
            notify.Notification(
                time: '09:15',
                date: '12 Jan',
                title: 'Parcel Verification',
                message:
                    'Your parcel has been verified. Verification code is 4488548. '),
            notify.Notification(
                time: '09:15',
                date: '12 Jan',
                title: 'Parcel Verification',
                message:
                    'Your parcel has been verified. Verification code is 4488548. '),
            notify.Notification(
                time: '09:15',
                date: '12 Jan',
                title: 'Parcel Verification',
                message:
                    'Your parcel has been verified. Verification code is 4488548. '),
            notify.Notification(
                time: '09:15',
                date: '12 Jan',
                title: 'Parcel Verification',
                message:
                    'Your parcel has been verified. Verification code is 4488548. ')
          ]),
        ));
  }
}

class NotificationDetail extends StatelessWidget {
  final String title;
  final String message;
  final String date;
  final String time;

  const NotificationDetail(
      {Key key, this.title, this.message, this.date, this.time})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: appBar(
          context,
          title: title,

          centerTitle: false,
          blackTitle: true,
          brightness: Brightness.light
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  date,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                Text(
                  time,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ]),
              SizedBox(height: 5),
              Text(
                message,
                style:
                    Theme.of(context).textTheme.headline3.copyWith(height: 1.2),
              )
            ],
          ),
        ));
  }
}
