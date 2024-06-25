import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("push Notifications in Flutter")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(onPressed: (){
                FirebaseMessaging.instance.subscribeToTopic("announcements");
              }, child:  Text("subscribe")),
              SizedBox(width: 20,),
              OutlinedButton(onPressed: (){
                FirebaseMessaging.instance.unsubscribeFromTopic("announcements");
              }, child: const Text("unsubscribe")),

            ],
          )
        ],
      ),
    );
  }
}
