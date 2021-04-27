import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:verigo/providers/notification_provider.dart';
import 'package:verigo/widgets/appbar.dart';
import 'package:verigo/widgets/notification_widget.dart' as notify;


import '../constants.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future yourFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reloadPage();
  }

  Future<void> reloadPage() async {
    var orderProvider = Provider.of<NotificationProvider>(context, listen: false);
    orderProvider.getNotifications(context);
    await Future.delayed(Duration(seconds: 8));
  }

  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<NotificationProvider>(context);
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
          body: RefreshIndicator(
            onRefresh: reloadPage,
            color: Theme.of(context).primaryColor,
            child: Builder(
              builder: (context) {
                if(orderProvider.notifications.isEmpty) {
                  return ListView(
                    children: [
                      SizedBox(height: 200,),
                      Text('You have no notifications!\nDrag page down to reload.',
                      textAlign: TextAlign.center,
                      )
                    ],
                  );

                }
                return Scrollbar(
                  child: ListView.builder(
                    itemCount: orderProvider.notifications.length,
                      itemBuilder: (context, index) {
                      NotificationMessage message = orderProvider.notifications[index];
                      return notify.Notification(
id: message.id,
                        message: message.message,
                        title: message.subject,
                        isRead: message.isRead,
                        date: message.createdOn,

                      );

                      }),
                );
              },
            ),
          ),
        ));
  }
}

class NotificationDetail extends StatefulWidget {
  final String title;
  final String message;
  final String date;
  final String id;

  const NotificationDetail(
      {Key key, this.title, this.message, this.date, this.id})
      : super(key: key);

  @override
  _NotificationDetailState createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var notifyProvider = Provider.of<NotificationProvider>(context, listen: false);
    notifyProvider.readMessage(context, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.date);
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: appBar(
          context,
          title: widget.title,

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
                  "${Jiffy(dateTime).format("MMMM d")}",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                Text(
                  "${Jiffy(dateTime).format("hh:mm a")}",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ]),
              SizedBox(height: 5),
              Text(
                widget.message,
                style:
                    Theme.of(context).textTheme.headline3.copyWith(height: 1.2),
              )
            ],
          ),
        ));
  }
}
