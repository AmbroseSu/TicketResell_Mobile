import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:ticket_resell/widgets/rating_progress_indicator.dart';
import 'package:ticket_resell/widgets/rounded_container.dart';
import '../styles&text&sizes/colors.dart';
import '../styles&text&sizes/image_strings.dart';
import '../styles&text&sizes/sizes.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(backgroundImage: AssetImage(TImages.user)),
                const SizedBox(width: TSizes.spaceBtwItems),
                Text('Nam Lee', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        /// Reviews
        Row(
          children: [
            const TRatingBarIndicator(rating: 4),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text('01 Sep, 2024', style: Theme.of(context).textTheme.bodyMedium,)
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        ReadMoreText(
          'The user interface of the app is quite intuitive. I was able to navigate and make purchases seamlessly. Great job!',
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: ' show less',
          trimCollapsedText: ' show more',
          moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent,),
          lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent,)
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        /// Company Review
        TRoundedContainer(
          backgroundColor: TColors.grey,
          child: Padding(
            padding: const EdgeInsets.all(TSizes.md),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TripWonder', style: Theme.of(context).textTheme.titleMedium),
                    Text('02 Sep, 2024', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                ReadMoreText(
                    'The user interface of the app is quite intuitive. I was able to navigate and make purchases seamlessly. Great job!',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimExpandedText: ' show less',
                    trimCollapsedText: ' show more',
                    moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent,),
                    lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent,)
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
      ],
    );
  }
}
