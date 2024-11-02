import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ticket_resell/screens/explore_screen.dart';
import 'package:ticket_resell/screens/request_ticket/all_ticket_seller.dart';
import 'package:ticket_resell/screens/create_post/create_ticket.dart';
import 'package:ticket_resell/notification/notification_screen.dart';
import 'package:ticket_resell/screens/settings/settings.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  // Define the list of screens here
  final List<Widget> screens = [
    const ExploreScreen(),
    const AllTicketSellerScreen(),
    const CreateTicket(),
    const NotificationScreen(),
    const SettingsScreen(),
  ];
}
