import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../styles&text&sizes/colors.dart';
import '../../styles&text&sizes/image_strings.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/appbar.dart';
import '../../widgets/profile_menu.dart';
import '../../widgets/section_heading.dart';
import '../../widgets/t_circular_icon.dart';
import '../../widgets/t_circular_image.dart';
import '../settings/settings.dart';


// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   Future<Map<String, dynamic>> fetchUserProfile() async {
//     final int? userId = UserManager().id;
//
//     final response = await http.get(
//       Uri.parse("https://trip-by-day-backend.onrender.com/api/v1/user/find-id/$userId"),
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data['content'];
//     } else {
//       throw Exception('Failed to load user profile: ${response.reasonPhrase}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: TAppBar(showBackArrow: true, title: Text('Profile')),
//
//       /// -- Body
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(TSizes.defaultSpace),
//           child: FutureBuilder<Map<String, dynamic>>(
//             future: fetchUserProfile(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (!snapshot.hasData) {
//                 return const Center(child: Text('No user data found'));
//               }
//
//               final user = snapshot.data!;
//
//               return Column(
//                 children: [
//                   /// Profile Picture
//                   SizedBox(
//                     width: double.infinity,
//                     child: Column(
//                       children: [
//                         const TCircularImage(image: TImages.user, width: 80, height: 80),
//                         TextButton(onPressed: (){}, child: const Text('Change Profile Picture')),
//                       ],
//                     ),
//                   ),
//
//                   /// Details
//                   const SizedBox(height: TSizes.spaceBtwItems / 2),
//                   const Divider(),
//                   const SizedBox(height: TSizes.spaceBtwItems),
//
//                   /// Heading Profile Info
//                   const TSectionHeading(title: 'Profile Information', showActionButton: false),
//                   const SizedBox(height: TSizes.spaceBtwItems),
//
//                   TProfileMenu(onPressed: (){}, title: 'Name', value: user['fullname'] ?? 'N/A'),
//                   TProfileMenu(onPressed: (){}, title: 'Address', value: user['address'] ?? 'N/A'),
//
//                   const SizedBox(height: TSizes.spaceBtwItems),
//                   const Divider(),
//                   const SizedBox(height: TSizes.spaceBtwItems),
//
//                   /// Heading Personal Info
//                   const TSectionHeading(title: 'Personal Information', showActionButton: false),
//                   const SizedBox(height: TSizes.spaceBtwItems),
//
//                   TProfileMenu(onPressed: (){}, icon: Iconsax.copy, title: 'Role', value: user['role'] ?? 'N/A'),
//                   TProfileMenu(onPressed: (){}, title: 'E-mail', value: user['email'] ?? 'N/A'),
//                   TProfileMenu(onPressed: (){}, title: 'Phone Number', value: user['phone'] ?? 'N/A'),
//                   TProfileMenu(onPressed: (){}, title: 'Gender', value: user['gender']?.toUpperCase() ?? 'N/A'),
//                   // TProfileMenu(onPressed: (){}, title: 'Date of Birth', value: user['dob'] ?? 'N/A'),
//                   const Divider(),
//                   const SizedBox(height: TSizes.spaceBtwItems),
//
//                   Center(
//                     child: TextButton(
//                       onPressed: () => Get.to(() => const SettingsScreen()),
//                       child: const Text('Close Account', style: TextStyle(color: Colors.red)),
//                     ),
//                   )
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Mock user profile data
  Map<String, dynamic> mockUserProfile() {
    return {
      'fullname': 'John Doe',
      'address': '123 Main St',
      'role': 'User',
      'email': 'johndoe@example.com',
      'phone': '+1234567890',
      'gender': 'male',
    };
  }

  @override
  Widget build(BuildContext context) {
    final user = mockUserProfile();

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: TAppBar(showBackArrow: true, title: Text('Profile')),
      appBar: TAppBar(
        title:
        Text('Profile', style: Theme.of(context).textTheme.headlineMedium), showBackArrow: true,
        actions: [
          TCircularIcon(
            icon: Iconsax.add,
            onPressed: () => {},
          )
        ],
      ),
      /// -- Body
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const TCircularImage(image: TImages.user, width: 80, height: 80),
                    TextButton(onPressed: () {}, child: const Text('Change Profile Picture', style: TextStyle(color: TColors.black),)),
                  ],
                ),
              ),

              /// Details
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Heading Profile Info
              const TSectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),

              TProfileMenu(onPressed: () {}, title: 'Name', value: user['fullname'] ?? 'N/A'),
              TProfileMenu(onPressed: () {}, title: 'Address', value: user['address'] ?? 'N/A'),

              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Heading Personal Info
              const TSectionHeading(title: 'Personal Information', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),

              TProfileMenu(onPressed: () {}, icon: Iconsax.copy, title: 'Role', value: user['role'] ?? 'N/A'),
              TProfileMenu(onPressed: () {}, title: 'E-mail', value: user['email'] ?? 'N/A'),
              TProfileMenu(onPressed: () {}, title: 'Phone Number', value: user['phone'] ?? 'N/A'),
              TProfileMenu(onPressed: () {}, title: 'Gender', value: user['gender']?.toUpperCase() ?? 'N/A'),
              // TProfileMenu(onPressed: (){}, title: 'Date of Birth', value: user['dob'] ?? 'N/A'),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: () => Get.to(() => const SettingsScreen()),
                  child: const Text('Close Account', style: TextStyle(color: Colors.red)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
