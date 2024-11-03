import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/response/ticket_request.dart';
import 'package:ticket_resell/notification/notification_controller.dart';
import 'package:ticket_resell/notification/notification_read.dart';
import 'package:ticket_resell/notification/notification_screen.dart';
import 'package:ticket_resell/screens/request_ticket/ticket_request_detail.dart';
import 'package:ticket_resell/services/database_service.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'global_variables/fcm_token_manage.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  UserManager userManager = UserManager();
  late bool shouldCheckRequest;


  Future<void> initNotification() async {
    // Request notification permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission();

    // Print permission status
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User denied permission');
    }

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Notification tapped.");
        // Ensure shouldCheckRequest is set to true when notification is tapped
        shouldCheckRequest = true;
        if (response.payload != null) {
          print("Payload received on tap: ${response.payload}");
          final payload = jsonDecode(response.payload!);

          final remoteMessage = RemoteMessage(
            notification: RemoteNotification(
              title: payload['notification']['title'],
              body: payload['notification']['body'],
            ),
            data: Map<String, dynamic>.from(payload['data']),
          );

          // Pass the parsed RemoteMessage to handleMessage
          handleMessage(remoteMessage);
        }
      },
    );

    // Retrieve FCM token
    final fCMToken = await _firebaseMessaging.getToken();
    TokenManager().fcmToken = fCMToken;
    print('Token: $fCMToken');

    initPushNotification();
  }

  void handleMessage(RemoteMessage message) {
    // Directly access message properties instead of checking for null
    final title = message.notification?.title ?? 'Default Title';
    final body = message.notification?.body ?? 'Default Body';
    final ticketRequestId = message.data['ticketRequestId'] ?? 'Default Ticket Request ID';
    final notificationId = message.data['notificationId'] ?? 'Default Notification ID';

    print("Navigating with message: Title: $title, Body: $body");
    print(ticketRequestId);



    if (navigatorkey.currentState == null) {
      print("Navigator key's current state is null.");
      return;
    }
    print("111111111111111111111111111111------------------------------------------------");
    print(shouldCheckRequest);
    //int requesttTicketId = int.parse(ticketRequestId);
    //checkTicketRequest(requesttTicketId);
    if (shouldCheckRequest) {
      int requestTicketId = int.parse(ticketRequestId);
      shouldCheckRequest = false;
      checkTicketRequest(requestTicketId, notificationId);

    }else{
      print("66666666666666666666666666666666666666222222222222222222222222222222222222222222");
      shouldCheckRequest = true;
      print(shouldCheckRequest);
    }

    // navigatorkey.currentState?.pushNamed(
    //   '/navigation_menu',
    //   arguments: message,
    // );
  }

  void initPushNotification() async {
    print("Initializing push notifications...");
    shouldCheckRequest = false;

    // Get the initial message
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("Initial message: $message");
        handleMessage(message);
      }
    });

    // Listen for messages opened from the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Message opened: $message");
      shouldCheckRequest = false;
      handleMessage(message);
    });

    // Listen for messages received while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: $message");
      //shouldCheckRequest = true;
      handleMessage(message);
      if (message.notification != null) {
        showLocalNotification(message);
      }
    });
  }


  Future<void> checkTicketRequest(int ticketRequestId, String notificationId) async {
    final url = 'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/TicketRequest/get-ticket-request-by-id?ticketRequestId=$ticketRequestId';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    //final body = jsonEncode({'email': email});

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
        //body: body,
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        TicketRequest ticketRequest = TicketRequest.fromJson(responseData['content']);
        //navigatorKey.currentState?.push(
        //  MaterialPageRoute(
        //    builder: (context) => TicketRequestDetailScreen(ticketRequest: ticketRequest),
        //  ),
        //);

        print("090909090909090909------------------------------------------------------");
        print(ticketRequest);
        NotificationRead notificationRead = NotificationRead();
        print(notificationId);
        await notificationRead.markAsRead(notificationId);
        NotificationScreen();
        Get.to(() => TicketRequestDetailScreen(ticketRequest: ticketRequest,));
      } else {
        print('Failed to ');
        //Get.snackbar('Error', 'Failed to check email: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      //Get.snackbar('Error', 'An error occurred: $error');
    }
  }

  void showLocalNotification(RemoteMessage message) {
    if (message.notification == null) return;

    print("Show Local Notification with payload: ${jsonEncode({
      'notification': {
        'title': message.notification?.title,
        'body': message.notification?.body,
      },
      'data': message.data,
    })}");
    NotificationScreen();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    _localNotifications.show(
      0,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      platformChannelSpecifics,
      payload: jsonEncode({
        'notification': {
          'title': message.notification?.title,
          'body': message.notification?.body,
        },
        'data': message.data,
      }),
    );
  }
}





