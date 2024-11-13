import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/notification/navigation_controller.dart';
import 'package:ticket_resell/notification/notification_controller.dart';
import 'package:ticket_resell/notification/notification_screen.dart';
import 'package:ticket_resell/styles&text&sizes/colors.dart';
import 'package:ticket_resell/widgets/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});


  @override
  Widget build(BuildContext context) {
    // Initialize NotificationController if not already done
    if (Get.isRegistered<NotificationController>() == false) {
      Get.put(NotificationController());
      NotificationScreen();
    }

    final notificationController = Get.find<NotificationController>();
    final navigationController = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
            () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: navigationController.selectedIndex.value,
          onDestinationSelected: (index) {
            navigationController.selectedIndex.value = index;
          },
          backgroundColor: darkMode ? TColors.black : Colors.white,
          indicatorColor: darkMode ? TColors.white.withOpacity(0.1) : TColors.black.withOpacity(0.1),
          destinations: [
            const NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            const NavigationDestination(icon: Icon(Iconsax.direct), label: 'Request'),
            const NavigationDestination(icon: Icon(Iconsax.add), label: 'Create'),
            NavigationDestination(
              icon: Stack(
                children: [
                  // Wrap the icon in a Container to adjust its position
                  Container(
                    margin: const EdgeInsets.only(right: 12), // Shift the icon slightly left
                    child: const Icon(Iconsax.notification),
                  ),
                  Obx(() {
                    return Positioned(
                      right: 4, // Keep the badge's position as desired
                      top: 0, // Optional: adjust vertical position if necessary
                      child: notificationController.unreadCount.value > 0
                          ? Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${notificationController.unreadCount.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                          : const SizedBox.shrink(),
                    );
                  }),
                ],
              ),
              label: 'Notification',
            ),

            const NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => navigationController.screens[navigationController.selectedIndex.value]),
    );
  }
}

