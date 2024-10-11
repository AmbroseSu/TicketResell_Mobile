import 'package:flutter/material.dart';

import '../../styles&text&sizes/colors.dart';
import '../../styles&text&sizes/image_strings.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/helper_functions.dart';
import '../../widgets/product_price_text.dart';
import '../../widgets/product_title_text.dart';
import '../../widgets/t_brand_title_text_with_verified_icon.dart';
import '../../widgets/t_rounded_image.dart';

class TCartItem extends StatelessWidget {
  const TCartItem({super.key});

  // Mock cart data
  Map<String, dynamic> mockCartData() {
    final items = [
      {
        'imageUrl': TImages.lima,
        'packageName': 'Canada Trip',
        'numberAttendance': 2,
        'price': 1500.0,
      },
      {
        'imageUrl': TImages.tokyo,
        'packageName': 'Germany Adventure',
        'numberAttendance': 3,
        'price': 2000.0,
      },
    ];

    final totalPrice = items.fold<double>(
      0,
          (sum, item) => sum + ((item['price'] as num?)?.toDouble() ?? 0),
    );

    return {
      'items': items,
      'totalPrice': totalPrice,
    };
  }

  @override
  Widget build(BuildContext context) {
    final mockData = mockCartData();
    final items = mockData['items'];
    final totalPrice = mockData['totalPrice'];

    return Column(
      children: [
        ...items.map((item) {
          return Row(
            children: [
              /// Image
              TRoundedImage(
                imageUrl: item['imageUrl'] ?? TImages.lima,
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(TSizes.sm),
                backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.darkerGrey : TColors.light,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              const SizedBox(height: 100),

              /// Title, Price, & Size
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TBrandTitleTextWithVerifiedIcon(title: 'Travel'),
                    Flexible(
                      child: TProductTitleText(
                        title: item['packageName'] ?? 'Unknown Package',
                        maxLines: 1,
                      ),
                    ),
                    /// Attributes
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Person:', style: Theme.of(context).textTheme.bodySmall),
                          TextSpan(text: item['numberAttendance']?.toString() ?? '0', style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                    TProductPriceText(price: item['price']?.toString() ?? '0'),
                  ],
                ),
              ),
            ],
          );
        }).toList(),

        const SizedBox(height: 20), // Space before total price
        Text(
          'Total Price: \$${totalPrice.toString()}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}


// class TCartItem extends StatelessWidget {
//   const TCartItem({super.key});
//
//   Future<Map<String, dynamic>> fetchCartItem() async {
//     final int? userId = UserManager().id;
//     final String? token = UserManager().token;
//
//     if (userId == null || token == null) {
//       throw Exception('User ID or token is missing');
//     }
//
//     final response = await http.post(
//       Uri.parse("https://trip-by-day-backend.onrender.com/api/v1/order/find-all-sale-for-user/$userId?page=1&limit=10"),
//       headers: {
//         'Authorization': 'Bearer $token',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body) as Map<String, dynamic>;
//       final items = data['content'] is List ? List<Map<String, dynamic>>.from(data['content']) : [];
//
//       // Tính tổng giá
//       final totalPrice = items.fold<double>(
//         0,
//             (sum, item) => sum + (item['price']?.toDouble() ?? 0),
//       );
//
//       return {
//         'items': items,
//         'totalPrice': totalPrice,
//       };
//     } else {
//       throw Exception('Failed to load cart item: ${response.reasonPhrase}');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, dynamic>>(
//       future: fetchCartItem(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!['items'].isEmpty) {
//           return const Center(child: Text('No items in the cart'));
//         }
//
//         final items = snapshot.data!['items'];
//         final totalPrice = snapshot.data!['totalPrice'];
//
//         return Column(
//           children: [
//             ...items.map((item) {
//               return Row(
//                 children: [
//                   /// Image
//                   TRoundedImage(
//                     imageUrl: item['imageUrl'] ?? TImages.canada,
//                     width: 60,
//                     height: 60,
//                     padding: const EdgeInsets.all(TSizes.sm),
//                     backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.darkerGrey : TColors.light,
//                   ),
//                   const SizedBox(width: TSizes.spaceBtwItems),
//                   const SizedBox(height: 100),
//
//                   /// Title, Price, & Size
//                   Expanded(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const TBrandTitleTextWithVerifiedIcon(title: 'Travel'),
//                         Flexible(
//                           child: TProductTitleText(
//                             title: item['packageName'] ?? 'Unknown Package',
//                             maxLines: 1,
//                           ),
//                         ),
//                         /// Attributes
//                         Text.rich(
//                           TextSpan(
//                             children: [
//                               TextSpan(text: 'Person:', style: Theme.of(context).textTheme.bodySmall),
//                               TextSpan(text: item['numberAttendance']?.toString() ?? '0', style: Theme.of(context).textTheme.bodyLarge),
//                             ],
//                           ),
//                         ),
//                         TProductPriceText(price: item['price']?.toString() ?? '0'),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             }).toList(),
//
//             const SizedBox(height: 20), // Space before total price
//             Text(
//               'Total Price: \$${totalPrice.toString()}',
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
