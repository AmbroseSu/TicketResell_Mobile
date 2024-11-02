import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/models/notification.dart';
import 'package:ticket_resell/notification/notification_controller.dart';
import 'package:ticket_resell/notification/notification_title.dart'; // Assuming you have a NotificationTile widget
import 'package:ticket_resell/services/database_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final GetIt _getIt = GetIt.instance;
  late DatabaseService _databaseService;
  UserManager userManager = UserManager();
  ValueNotifier<int> unreadCountNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _databaseService = _getIt.get<DatabaseService>();
    _listenToUnreadNotifications();
  }

  void _listenToUnreadNotifications() {
    _databaseService.getNotifications(userManager.email!).listen((snapshot) {
      final unreadCount = snapshot.docs.where((doc) => !doc.data().isRead).length;
      // Update the global unread count
      Get.find<NotificationController>().updateUnreadCount(unreadCount);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: StreamBuilder<QuerySnapshot<NotificationModel>>(
        stream: _databaseService.getNotifications(userManager.email!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Unable to load notifications."));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final notifications = snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationTile(notification: notification);
            },
          );
        },
      ),
    );
  }
}
