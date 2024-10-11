import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_resell/widgets/section_heading.dart';

import '../screens/profile/profile.dart';

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TSectionHeading(title: 'Customer Information', buttonTitle: 'See All', onPressed: () => Get.to(() => ProfileScreen())),
        Text('Ticket Resell', style: Theme.of(context).textTheme.bodyLarge),

        // Row(
        //   children: [
        //     const Icon(Icons.phone, color: Colors.grey, size: 16),
        //     const SizedBox(width: TSizes.spaceBtwItems),
        //     Text('+84 234 567 890', style: Theme.of(context).textTheme.bodyMedium),
        //   ],
        // ),
        // const SizedBox(height: TSizes.spaceBtwItems/2),
        // Row(
        //   children: [
        //     const Icon(Icons.location_history, color: Colors.grey, size: 16),
        //     const SizedBox(width: TSizes.spaceBtwItems),
        //     Expanded(child: Text('192 Manhattan, New York, USA', style: Theme.of(context).textTheme.bodyMedium, softWrap: true)),
        //   ],
        // ),
      ],
    );
  }
}
