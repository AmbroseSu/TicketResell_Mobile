import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/widgets/rounded_container.dart';
import '../screens/checkout/checkout.dart';
import '../styles&text&sizes/colors.dart';
import '../styles&text&sizes/sizes.dart';
import 'helper_functions.dart';

class TSinglePlatform extends StatelessWidget {
  const TSinglePlatform({super.key, required this.selectedAddress});

  final bool selectedAddress;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      showBorder: true,
      padding: const EdgeInsets.all(TSizes.md),
      width: double.infinity,
      backgroundColor: selectedAddress
          ? TColors.primary.withOpacity(0.2)
          : Colors.transparent,
      borderColor: selectedAddress
          ? TColors.primary
          : dark
          ? TColors.darkerGrey
          : TColors.grey,
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Stack(
        children: [
          // Icon dấu tick ở góc phải trên
          if (selectedAddress)
            Positioned(
              right: 5,
              top: 5,
              child: Icon(
                Icons.check_circle,
                color: dark ? TColors.light : TColors.primary,
                size: 24,
              ),
            ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Silver Platform',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: TSizes.sm),

              // Hàng "3000 slots" và "500000 VND"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '3000 slots',
                    style: TextStyle(
                      fontSize: 20,
                      color: dark ? TColors.lightGrey : TColors.darkerGrey,
                    ),
                  ),
                  Text(
                    '500000 VND',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: TColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.sm),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Kích thước nút
                  backgroundColor: TColors.primary,
                ),
                child: Text(
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
        ],
      ),
    );
  }
}

