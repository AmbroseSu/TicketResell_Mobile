import 'package:flutter/material.dart';

import '../../../styles&text&sizes/sizes.dart';
import '../../../styles&text&sizes/text_strings.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          height: 100,
          image: AssetImage("assets/logos/Image.jpg"),
        ),

        Text(TTexts.logIntoAccount,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 30)),
        const SizedBox(height: TSizes.sm),
        Text("Welcome back! The world of Ticket ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18)),
        // const SizedBox(height: TSizes.sm),
        Text("Resell in your own way ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18)),
      ],
    );
  }
}
