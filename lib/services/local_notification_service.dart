import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static final onNotification = BehaviorSubject<String>();
  static Future initialize() async {
    final InitializationSettings initializationSettings = InitializationSettings(android: AndroidInitializationSettings("@drawable/main_logo_for_notif"));
    await _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        onNotification.add(payload);
        return null;
      },
    );
  }

//это просто надпись (можно стереть)
  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = NotificationDetails(
        iOS: IOSNotificationDetails(presentAlert: true, threadIdentifier: "smart.ios"),
        android: AndroidNotificationDetails(
          "smart.android",
          "smart.android channel",
          "this is channel for fcm",
          importance: Importance.max,
          priority: Priority.high,
          icon: "@drawable/main_logo_for_notif",
          color: Colors.blue,
        ),
      );

      if (message.notification != null) {
        String _dataToString = json.encode(message.data);
        await _notificationsPlugin.show(id, message.notification.title, message.notification.body, notificationDetails, payload: _dataToString);
        print(message.data);
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
