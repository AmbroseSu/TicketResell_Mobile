import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../navigation_menu.dart';
import '../../styles&text&sizes/colors.dart';
import '../../styles&text&sizes/image_strings.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/appbar.dart';
import '../../widgets/billing_address_section.dart';
import '../../widgets/billing_payment_section.dart';
import '../../widgets/helper_functions.dart';
import '../../widgets/rounded_container.dart';
import '../../widgets/t_circular_icon.dart';
import '../cart/cart_item.dart';
import '../explore_screen.dart';
import '../success_screen/payment_success.dart';
import '../success_screen/success_screen.dart';
//
// class CheckoutScreen extends StatelessWidget {
//   const CheckoutScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final userId = UserManager().id.toString();
//     final dark = THelperFunctions.isDarkMode(context);
//     return Scaffold(
//       appBar: TAppBar(
//           showBackArrow: true,
//           title: Text('Order Review',
//               style: Theme.of(context).textTheme.headlineSmall)),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(TSizes.defaultSpace),
//           child: Column(
//             children: [
//               /// -- Items in Cart
//               TCartItem(),
//               SizedBox(height: TSizes.spaceBtwSections),
//
//               // /// -- Coupon TextField
//               // TCouponCode(),
//               // const SizedBox(height: TSizes.spaceBtwSections),
//
//               /// -- Billing Section
//               TRoundedContainer(
//                 showBorder: true,
//                 padding: const EdgeInsets.all(TSizes.sm),
//                 backgroundColor: dark ? TColors.black : TColors.white,
//                 child: const Column(
//                   children: [
//                     // /// Pricing
//                     // TBillingAmountSection(),
//                     // SizedBox(height: TSizes.spaceBtwItems),
//                     //
//                     // /// Divider
//                     // Divider(),
//                     // SizedBox(height: TSizes.spaceBtwItems),
//
//                     /// Payment Methods
//                     TBillingPaymentSection(),
//                     SizedBox(height: TSizes.spaceBtwItems),
//
//                     /// Address
//                     TBillingAddressSection(),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//
//       /// Checkout Button
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(TSizes.defaultSpace),
//         child: ElevatedButton(
//             onPressed: () => Get.to(() => SuccessScreen(
//               image: TImages.paymentSuccess,
//               title: 'Payment Success!',
//               subTitle: 'Your package is ready!',
//               onPressed: () => Get.offAll(() => const NavigationMenu()),
//             ),
//             ),
//             child: Text('Checkout')),
//       ),
//     );
//   }
// }

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TAppBar(
        title:
        Text('Order Review', style: Theme.of(context).textTheme.headlineMedium), showBackArrow: true,
        actions: [
          TCircularIcon(
            icon: Iconsax.add,
            onPressed: () => Get.to(const ExploreScreen()),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// -- Items in Cart (Mocked Cart Data for UI testing)
              const TCartItem(), // You can keep this as mock data already exists.
              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Billing Section (No API calls here)
              TRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.sm),
                backgroundColor: dark ? TColors.black : TColors.white,
                child: const Column(
                  children: [
                    /// Payment Methods
                    TBillingPaymentSection(),
                    SizedBox(height: TSizes.spaceBtwItems),

                    /// Address
                    TBillingAddressSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// Checkout Button (Navigates to SuccessScreen without API)
      bottomNavigationBar:
      Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () => Get.to(() => PaymentSuccess(
            image: TImages.paymentSuccess,
            title: 'Payment Success!',
            subTitle: 'Your package is ready!',
            onPressed: () => Get.to(() => const NavigationMenu()),
          ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent
          ),
          child: const Text('Checkout', style: TextStyle(color: Colors.white),
          ),

        ),
      ),
    );
  }
}
