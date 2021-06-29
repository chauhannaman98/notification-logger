import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:android_notification_listener2/android_notification_listener2.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AndroidNotificationListener _notifications;
  late StreamSubscription<NotificationEventV2> _subscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startListening();
  }

  void onData(NotificationEventV2 event) {

    // print(event);
    if(!event.packageName.contains(new RegExp(r'com.android', caseSensitive: false))) {
      // ignoring system app notifications
      print("App: " + event.packageName);
      print("Timestamp: " + event.timeStamp.toString());
      print("Text: " + event.packageText);
      print("Message: " + event.packageMessage);
      print("Extra: " + event.packageExtra);
      print("----------------------------------------------------------------");
    }

    // print('converting package extra to json');
    // var jsonDatax = json.decode(event.packageExtra);
    // print(jsonDatax);
  }

  void startListening() {
    _notifications = new AndroidNotificationListener();
    try {
      _subscription = _notifications.notificationStream.listen(onData);
    } on NotificationExceptionV2 catch (exception) {
      print(exception);
    }
  }

  void stopListening() {
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
      ),
    );
  }
}