import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:push_notifications/fcm_helper.dart';

import 'firebase_options.dart';
import 'home_Screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FcmHelper fcm=FcmHelper();
  await fcm.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(


      home: HomeScreen()
    );
  }
}


