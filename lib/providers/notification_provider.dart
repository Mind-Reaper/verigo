
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'authentication_provider.dart';
import 'user_provider.dart';

class NotificationProvider with ChangeNotifier {

  List<NotificationMessage> notifications = [];

  getNotifications(context) async {
    String accessToken = Provider
        .of<UserProvider>(context, listen: false)
        .currentUser
        .accessToken;
    print(accessToken);
    try {
      Response response = await dio.get(
        '/api/services/app/Account/GetMessages',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      List result = await response.data['result']['data'];
      if (result != null) {
        notifications = result.map((doc) {
          return NotificationMessage.fromDocument(doc);
        }).toList();
        notifyListeners();
      } else {
        notifications = [];
        notifyListeners();
      }

      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  readMessage(context, String id) async {
    String accessToken = Provider
        .of<UserProvider>(context, listen: false)
        .currentUser
        .accessToken;
    print(accessToken);
    try {
      Response response = await dio.get(
        '/api/services/app/Account/GetMessage',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        queryParameters: {
          'messageId': id,
        }

      );
      print(response.data);
      Map doc = await response.data['result']['data'];
      int index = notifications.indexWhere((e) => e.id == id);
      notifications.removeWhere((e) => e.id == id );
      notifications.insert(index, NotificationMessage(
        id: doc['id'],
        subject: doc['subject'],
        message: doc['content'],
        createdOn: doc['createdon'],
        isRead: true,
      ));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

class NotificationMessage {
  final String id;
  final String subject;
  final String message;
  final String createdOn;
  final bool isRead;

  NotificationMessage({this.id, this.subject, this.message, this.createdOn, this.isRead: true});

  factory NotificationMessage.fromDocument(doc) {
    return NotificationMessage(
      id: doc['id'],
      subject: doc['subject'],
      message: doc['content'],
      createdOn: doc['createdOn'],
      isRead: doc['isRead']?? true,
    );
  }
}