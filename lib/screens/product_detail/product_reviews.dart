import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path/path.dart';
import 'package:ticket_resell/styles&text&sizes/image_strings.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/appbar.dart';
import '../../widgets/comment_input_icon.dart';
import '../../widgets/primary_header_container.dart';
import '../../widgets/progress_indicator_and_rating.dart';
import '../../widgets/rating_progress_indicator.dart';
import '../../widgets/t_circular_icon.dart';
import '../../widgets/t_circular_image.dart';
import '../../widgets/user_profile_tile.dart';
import '../../widgets/user_review_card.dart';
import '../profile/profile.dart';

//
// class ProductReviewsScreen extends StatelessWidget {
//   const ProductReviewsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       /// -- Appbar
//       appBar: TAppBar(
//         title: Text('Reviews & Ratings', style: Theme.of(context).textTheme.headlineMedium),
//         showBackArrow: true,
//         actions: [
//           TCircularIcon(
//             icon: Iconsax.add,
//             onPressed: () {},
//           )
//         ],
//       ),
//
//       /// -- Body
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(TSizes.defaultSpace),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: TSizes.spaceBtwItems),
//
//               /// -- Overall Product Ratings
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center, // Center the entire row
//                 children: [
//                   // Average Rating Image with adjusted size
//                   SizedBox(
//                     width: 80, // Adjust the width as needed
//                     height: 80, // Adjust the height as needed
//                     child: TCircularImage(
//                       image: 'assets/movies/conan.jpg',
//                     ),
//                   ),
//
//                   const SizedBox(width: 16), // Space between image and text
//
//                   // Rating Breakdown with larger text, centered vertically
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Name: Nam Le",
//                           style: TextStyle(
//                             fontSize: 20, // Increase font size as needed
//                             fontWeight: FontWeight.bold, // Optional: make text bold
//                           ),
//                         ),
//                         Text(
//                           "Point: 1000",
//                           style: TextStyle(
//                             fontSize: 18, // Increase font size as needed
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//
//               const SizedBox(height: TSizes.spaceBtwItems),
//               // TRatingBarIndicator(rating: 4.8),
//               // Text('12,611 reviews', style: Theme.of(context).textTheme.bodySmall),
//               const SizedBox(height: TSizes.spaceBtwSections),
//
//               /// User Reviews List
//               const UserReviewCard(),
//               const UserReviewCard(),
//               const UserReviewCard(),
//               const UserReviewCard(),
//
//               // /// Input Comment
//               // const CommentInputWidget(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  void _showFeedbackDialog(BuildContext context) {
    double rating = 0;
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Leave a Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Rating bar for selecting 1 to 5 stars
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
              const SizedBox(height: 16),

              // Feedback text field
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  hintText: 'Write your feedback here...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black),),
            ),
            ElevatedButton(
              onPressed: () {
                // Submit feedback (you can handle the rating and feedback content here)
                print('Rating: $rating');
                print('Feedback: ${feedbackController.text}');

                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: Text('Submit', style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// -- Appbar
      appBar: TAppBar(
        title: Text('Reviews & Ratings', style: Theme.of(context).textTheme.headlineMedium),
        showBackArrow: true,
        actions: [
          TCircularIcon(
            icon: Iconsax.add,
            onPressed: () => _showFeedbackDialog(context),
          ),
        ],
      ),

      /// -- Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TSizes.spaceBtwItems),

              /// -- Overall Product Ratings
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the entire row
                children: [
                  // Average Rating Image with adjusted size
                  SizedBox(
                    width: 80, // Adjust the width as needed
                    height: 80, // Adjust the height as needed
                    child: TCircularImage(
                      image: 'assets/movies/conan.jpg',
                    ),
                  ),

                  const SizedBox(width: 16), // Space between image and text

                  // Rating Breakdown with larger text, centered vertically
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: Nam Le",
                          style: TextStyle(
                            fontSize: 20, // Increase font size as needed
                            fontWeight: FontWeight.bold, // Optional: make text bold
                          ),
                        ),
                        Text(
                          "Point: 1000",
                          style: TextStyle(
                            fontSize: 18, // Increase font size as needed
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwItems),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// User Reviews List
              const UserReviewCard(),
              const UserReviewCard(),
              const UserReviewCard(),
              const UserReviewCard(),
              //
              // /// Input Comment
              // const CommentInputWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
