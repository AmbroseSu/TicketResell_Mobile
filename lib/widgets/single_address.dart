import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/widgets/rounded_container.dart';
import '../styles&text&sizes/colors.dart';
import '../styles&text&sizes/sizes.dart';
import 'helper_functions.dart';

class TSingleAddress extends StatelessWidget {
  const TSingleAddress({super.key, required this.selectedAddress});

  final bool selectedAddress;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      showBorder: true,
      padding: const EdgeInsets.all(TSizes.md),
      width: double.infinity,
      backgroundColor: selectedAddress
          ? TColors.primary.withOpacity(0.5)
          : Colors.transparent,
      borderColor: selectedAddress
          ? Colors.transparent
          : dark
              ? TColors.darkerGrey
              : TColors.grey,
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Stack(
        children: [
          // Positioned(
          //   right: 5,
          //   top: 0,
          //   child:
          //   // Icon(
          //   //   selectedAddress  ,
          //   //   // Iconsax.tick_circle5 : null,
          //   //   color: selectedAddress
          //   //       ? dark
          //   //           ? TColors.light
          //   //           : TColors.dark
          //   //       : null,
          //   // ),
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Silver Platform',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.sm / 2),
              const Text('3000 slots', style: TextStyle(fontSize: 25), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: TSizes.sm / 2),
              const Text('500000 VND', style: TextStyle(fontSize: 30), softWrap: true),
            ],
          )
        ],
      ),
    );
  }
}
