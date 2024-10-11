import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import '../../api/global_variables/user_manage.dart';
import '../../navigation_menu.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/appbar.dart';
import '../../widgets/t_circular_icon.dart';
import '../checkout/checkout.dart';
import '../explore_screen.dart';
import 'cart_item.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int? userId = UserManager().id;  // Ensure userId is non-null and convert it to int

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TAppBar(
        title:
        Text('Platform Fee', style: Theme.of(context).textTheme.headlineMedium), showBackArrow: true,
        actions: [
          TCircularIcon(
            icon: Iconsax.add,
            onPressed: () => Get.to(const NavigationMenu()),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: TCartItem(), // Pass the user ID here
      ),

      /// Checkout Button
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(TSizes.defaultSpace),
      //   child: FutureBuilder<Map<String, dynamic>>(
      //     future: TCartItem().fetchCartItem(),
      //     builder: (context, snapshot) {
      //       if (!snapshot.hasData) {
      //         return const SizedBox.shrink(); // Hoặc hiển thị một CircularProgressIndicator
      //       }
      //
      //       final totalPrice = snapshot.data!['totalPrice'];
      //
      //
      //       return ElevatedButton(
      //         onPressed: () => Get.to(() => const CheckoutScreen()),
      //         child: Text('Checkout \$${totalPrice.toStringAsFixed(2)}'),
      //       );
      //     },
      //   ),
      // ),
      /// Checkout Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Builder(
          builder: (context) {
            // Mock total price (for testing purposes)
            final double totalPrice = 3500.0; // Set any mock value you want

            return
              ElevatedButton(
              onPressed: () => Get.to(() => const CheckoutScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent
              ),
              child: Text('Checkout \$${totalPrice.toStringAsFixed(2)}', style: TextStyle(color: Colors.white)),
            );
          },
        ),
      ),

    );
  }
}