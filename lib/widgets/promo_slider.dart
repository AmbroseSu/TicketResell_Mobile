// import 'dart:ffi';
//
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tripwonder/controller/home_controller.dart';
// import 'package:tripwonder/styles&text&sizes/colors.dart';
// import 'package:tripwonder/widgets/t_rounded_image.dart';
//
// import '../styles&text&sizes/image_strings.dart';
// import '../styles&text&sizes/sizes.dart';
// import 'login_signup/circular_container.dart';
//
// class TPromoSlider extends StatelessWidget {
//   const TPromoSlider({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(HomeController());
//     return Column(
//       children: [
//         CarouselSlider(
//           options: CarouselOptions(
//             viewportFraction: 1,
//             onPageChanged: (index, _) => controller.updatePageIndicator(index)
//           ),
//           items: [
//             TRoundedImage(imageUrl: TImages.chicago),
//             TRoundedImage(imageUrl: TImages.lima),
//             TRoundedImage(imageUrl: TImages.tokyo),
//           ],
//         ),
//         const SizedBox(height: TSizes.spaceBtwItems),
//         Obx(
//             () => Row(
//               children:[
//                 for (int i = 0; i < 3; i++)
//                   const TCircularContainer(
//                     width: 20,
//                     height: 4,
//                     margin: EdgeInsets.only(right: 10),
//                     backgroundColor: controller.carousalCurrentIndex.value == i? Color(0xFF55B97D) : TColors.grey,
//                   ),
//               ]
//           ),
//         )
//       ],
//     );
//   }
// }
//

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_resell/widgets/t_rounded_image.dart';
import '../controller/home_controller.dart';
import '../styles&text&sizes/colors.dart';
import '../styles&text&sizes/sizes.dart';
import 'login_signup/circular_container.dart';

class TPromoSlider extends StatelessWidget {
  const TPromoSlider({
    super.key, required this.banners,
  });

  final List<String> banners;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              viewportFraction: 1,
              onPageChanged: (index, _) =>
                  controller.updatePageIndicator(index)),
          items: banners.map((url) => TRoundedImage(imageUrl: url)).toList(),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Center(
          child: Obx(
                () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < banners.length; i++)
                  TCircularContainer(
                      width: 20,
                      height: 4,
                      margin: const EdgeInsets.only(right: 10),
                      backgroundColor: controller.carsousalCurrentIndex.value == i ? Colors.blueAccent : TColors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

