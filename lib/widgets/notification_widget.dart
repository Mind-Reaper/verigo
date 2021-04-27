import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:verigo/screens/notifications_screen.dart';


import '../constants.dart';
import 'my_container.dart';

class Notification extends StatelessWidget {
  final String title;
  final String message;
  final String date;
 final bool isRead;
 final String id;

  const Notification({Key key, this.title, this.message, this.date,  this.isRead: true, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(date);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: GestureDetector(
        onTap: () {
          pushPage(
              context,
              NotificationDetail(
               id: id,
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
                Icon(isRead ? Icons.mark_email_read_outlined :Icons.mark_email_unread_outlined, size: 30, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: 23,
                                fontWeight: isRead ? FontWeight.w500: FontWeight.w700,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 5),
                        Text(
                          message,
                          style: TextStyle(
                            fontWeight: isRead ? FontWeight.w400: FontWeight.bold,
                            color: isRead ? Colors.grey : Color(0xff414141)
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${Jiffy(dateTime).format("MMMM d | hh:mm a")}",
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
