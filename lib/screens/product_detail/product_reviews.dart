import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/appbar.dart';
import '../../widgets/comment_input_icon.dart';
import '../../widgets/progress_indicator_and_rating.dart';
import '../../widgets/rating_progress_indicator.dart';
import '../../widgets/t_circular_icon.dart';
import '../../widgets/user_review_card.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// -- Appbar
      appBar: TAppBar(
        title:
        Text('Reviews & Ratings', style: Theme.of(context).textTheme.headlineMedium), showBackArrow: true,
        actions: [
          TCircularIcon(
            icon: Iconsax.add,
            onPressed: () {},
          )
        ],
      ),
      /// -- Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ratings and reviews are verified and are from people who use the same type of device that you use.'),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// -- Overall Product Ratings
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text('4.8', style: Theme.of(context).textTheme.displayLarge)),
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        TRatingProgressIndicator(text: '5', value: 1.0),
                        TRatingProgressIndicator(text: '4', value: 0.8),
                        TRatingProgressIndicator(text: '3', value: 0.6),
                        TRatingProgressIndicator(text: '2', value: 0.4),
                        TRatingProgressIndicator(text: '1', value: 0.2),
                      ],
                    ),
                  )
                ],
              ),
              TRatingBarIndicator(rating: 3.5),
              Text('12,611', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// User Reviews List
              const UserReviewCard(),
              const UserReviewCard(),
              const UserReviewCard(),
              const UserReviewCard(),

              /// Input Comment
              const CommentInputWidget(),
            ],
          ),

        ),

      ),
    );
  }
}
