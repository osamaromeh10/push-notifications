import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {



  print("Handling a background message: ${message.data.toString()}");
  Fluttertoast.showToast(msg: "on background message app",backgroundColor: Colors.green,gravity:ToastGravity.BOTTOM,timeInSecForIosWeb: 3,

      textColor: Colors.white,
      fontSize: 16.0 );

}

class FcmHelper {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.max,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  requestIosPermission() async {
    if (Platform.isIOS) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  }

  String? token;

  getToken() async {
    token = await messaging.getToken();
    print("Token $token");
  }

  init() async {
    await requestIosPermission();
    await getToken();
    await initializeForeground();
    await setForegroundIosOptions();
    await setForegroundAndroidOptions();
 return   FirebaseMessaging.onBackgroundMessage((message) => firebaseMessagingBackgroundHandler(message));
    }

  initializeForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.notification?.title}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon:"ic_stat_access_time",
                  // other properties...
                ),
              ));
        }
      }
    Fluttertoast.showToast(msg: "on message",backgroundColor: Colors.green,gravity:ToastGravity.BOTTOM,timeInSecForIosWeb: 1,

        textColor: Colors.white,
        fontSize: 16.0 );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
print(message.data.toString());
Fluttertoast.showToast(msg: "on message opened app",backgroundColor: Colors.green,gravity:ToastGravity.BOTTOM,timeInSecForIosWeb: 1,

    textColor: Colors.white,
    fontSize: 16.0 );

    });

  }

  setForegroundIosOptions() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  setForegroundAndroidOptions() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("ic_stat_access_time");
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

}
