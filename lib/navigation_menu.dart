import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/screens/cart/cart.dart';
import 'package:ticket_resell/screens/chat/allchats_screen.dart';
import 'package:ticket_resell/screens/chat/chat_screen.dart';
import 'package:ticket_resell/screens/create_post/create_ticket.dart';
import 'package:ticket_resell/screens/explore_screen.dart';
import 'package:ticket_resell/screens/order/order.dart';
import 'package:ticket_resell/screens/product_detail/favorite.dart';
import 'package:ticket_resell/screens/settings/settings.dart';
import 'package:ticket_resell/styles&text&sizes/colors.dart';
import 'package:ticket_resell/widgets/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.black : Colors.white,
          indicatorColor: darkMode
              ? TColors.white.withOpacity(0.1)
              : TColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.message), label: 'Chats'),
            NavigationDestination(icon: Icon(Iconsax.add), label: 'Create'),
            NavigationDestination(icon: Icon(Iconsax.heart), label: 'Favorites'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  // Update this to match the number of destinations
  final screens = [
    const ExploreScreen(),
     AllChatsScreen(),
    const CreateTicket(),
    const FavoriteScreen(),
    const SettingsScreen(),
  ];
}
