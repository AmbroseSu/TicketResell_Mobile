import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_resell/widgets/t_rounded_image.dart';
import '../controller/home_controller.dart';
import '../styles&text&sizes/sizes.dart';


class TGallerySlider extends StatelessWidget {
  const TGallerySlider({
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
        // Center(
        //   child: Obx(
        //         () => Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         for (int i = 0; i < banners.length; i++)
        //           TCircularContainer(
        //               width: 20,
        //               height: 4,
        //               margin: const EdgeInsets.only(right: 10),
        //               backgroundColor: controller.carsousalCurrentIndex.value == i ? Color(0xFF55B97D) : TColors.grey),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

