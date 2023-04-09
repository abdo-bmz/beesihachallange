import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  static Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static void registerMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Got a message while in the foreground!");
      print("Message data: ${message.data}");
      print("Notification title: ${message.notification?.title}");
      print("Notification body: ${message.notification?.body}");
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Got a message while in the background!");
    print("Message data: ${message.data}");
    print("Notification title: ${message.notification?.title}");
    print("Notification body: ${message.notification?.body}");
  }
}
