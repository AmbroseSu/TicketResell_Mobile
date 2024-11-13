import 'package:flutter/material.dart';
import 'package:ticket_resell/widgets/rounded_container.dart';
import '../../styles&text&sizes/colors.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/helper_functions.dart';
import '../checkout/checkout.dart';
//
// class TSinglePlatform extends StatelessWidget {
//   const TSinglePlatform({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);
//     return TRoundedContainer(
//       showBorder: true,
//       padding: const EdgeInsets.all(TSizes.md),
//       width: double.infinity,
//       backgroundColor: Colors.transparent,
//       borderColor: dark ? TColors.darkerGrey : TColors.grey,
//       margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
//       child: Stack(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Silver Platform',
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 22,
//                 ),
//               ),
//               const SizedBox(height: TSizes.sm),
//
//               // Hàng "3000 slots" và "500000 VND"
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '3000 slots',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: dark ? TColors.lightGrey : TColors.darkerGrey,
//                     ),
//                   ),
//                   Text(
//                     '500000 VND',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: TColors.primary,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: TSizes.sm),
//
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => CheckoutScreen()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size(double.infinity, 50), // Kích thước nút
//                   backgroundColor: TColors.primary,
//                 ),
//                 child: Text(
//                   'Book Now',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }



class TSinglePlatform extends StatelessWidget {
  final String name;
  final String quantity;
  final String price;

  const TSinglePlatform({
    super.key,
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      showBorder: true,
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      backgroundColor: Colors.transparent,
      borderColor: dark ? TColors.darkerGrey : TColors.grey,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$quantity slots',
                style: TextStyle(
                  fontSize: 20,
                  color: dark ? TColors.lightGrey : TColors.darkerGrey,
                ),
              ),
              Text(
                '$price VND',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckoutScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: TColors.primary,
            ),
            child: const Text(
              'Book Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
