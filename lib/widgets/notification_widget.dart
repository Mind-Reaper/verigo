import 'package:flutter/material.dart';
import 'package:verigo/screens/notifications_screen.dart';


import '../constants.dart';
import 'my_container.dart';

class Notification extends StatelessWidget {
  final String title;
  final String message;
  final String date;
  final String time;

  const Notification({Key key, this.title, this.message, this.date, this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: GestureDetector(
        onTap: () {
          pushPage(
              context,
              NotificationDetail(
                time: time,
                title: title,
                date: date,
                message: message,
              ));
        },
        child: Container(
          constraints: BoxConstraints.loose(Size(
            double.infinity,
            100,
          )),
          width: double.infinity,
          child: Center(
            child: FloatingContainer(
                child: Center(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.mail_outline_rounded, size: 30, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 5),
                        Text(
                          message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "$date | $time ",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )
                      ]),
                )
              ]),
            )),
          ),
        ),
      ),
    );
  }
}
