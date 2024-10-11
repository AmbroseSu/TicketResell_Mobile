// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:tripwonder/styles&text&sizes/image_strings.dart';
//
// class MyTripCard extends StatelessWidget {
//   const MyTripCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Cafe info section
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image of the cafe
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12.0),
//                 child: Image.asset(
//                   TImages.canada, // Replace with your image asset
//                   width: 100,
//                   height: 100,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(width: 16.0),
//               // Textual information about the cafe
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Cafe de l’ambre',
//                     style: Theme.of(context)
//                         .textTheme
//                     .headlineMedium
//                         // .copyWith(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8.0),
//                   Row(
//                     children: [
//                       const Icon(Icons.star, color: Colors.amber, size: 18),
//                       const SizedBox(width: 4.0),
//                       Text(
//                         '4.8',
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                       Text(
//                         ' (230)',
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodyMedium!
//                             .copyWith(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8.0),
//                   Text(
//                     '8:00 - 9:00 AM',
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   const SizedBox(height: 8.0),
//                   Text(
//                     '\$30.0',
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyMedium!
//                         .copyWith(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 16.0),
//           // Discount section
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//             decoration: BoxDecoration(
//               color: const Color(0xFFE9F7EF),
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: const [
//                     Icon(Iconsax.discount_circle, color: Color(0xFF55B97D)),
//                     SizedBox(width: 8.0),
//                     Text(
//                       '1 Discount is applied',
//                       style: TextStyle(
//                           fontSize: 16, color: Color(0xFF55B97D), fontWeight: FontWeight.w500),
//                     ),
//                   ],
//                 ),
//                 const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF55B97D)),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16.0),
//           // Google Maps section
//           // Container(
//           //   height: 200.0,
//           //   decoration: BoxDecoration(
//           //     borderRadius: BorderRadius.circular(12.0),
//           //     border: Border.all(color: Colors.grey.withOpacity(0.5)),
//           //   ),
//             // child: ClipRRect(
//             //   borderRadius: BorderRadius.circular(12.0),
//             //   child: GoogleMap(
//             //     initialCameraPosition: const CameraPosition(
//             //       target: LatLng(40.730610, -73.935242), // Set the location you want
//             //       zoom: 14.0,
//             //     ),
//             //     markers: {
//             //       const Marker(
//             //         markerId: MarkerId('cafe'),
//             //         position: LatLng(40.730610, -73.935242), // Replace with your cafe location
//             //       ),
//             //     },
//             //   ),
//             // ),
//           // ),
//         ],
//       ),
//     );
//   }
//
// Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
//   return ElevatedButton.icon(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.black,
//       side: const BorderSide(color: Colors.grey),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     ),
//     onPressed: onPressed,
//     icon: Icon(icon, size: 18),
//     label: Text(label),
//   );
// }
// }

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MyTripCard extends StatelessWidget {
  final String cafeName;
  final String cafeImage;
  final double rating;
  final int reviewCount;
  final String time;
  final double price;

  const MyTripCard({
    super.key,
    required this.cafeName,
    required this.cafeImage,
    required this.rating,
    required this.reviewCount,
    required this.time,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  cafeImage,
                  width: 170,
                  height: 170,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cafeName,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8.0),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4.0),
                      Text(
                        rating.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        ' ($reviewCount)',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),

                  Text(
                    time,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '\$$price',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Các thành phần khác vẫn giữ nguyên
// Discount section
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE9F7EF),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Iconsax.discount_circle, color: Color(0xFF55B97D)),
                SizedBox(width: 8.0),
                Text(
                  '1 Discount is applied',
                  style: TextStyle(
                      fontSize: 16, color: Color(0xFF55B97D), fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF55B97D)),
          ],
        ),
      )],
      ),
    );
  }
}

