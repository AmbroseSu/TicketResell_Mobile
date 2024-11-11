import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/screens/create_post/create_ticket.dart';
import 'package:ticket_resell/screens/platform_fee/address.dart';
import 'package:ticket_resell/screens/product_detail/all_post.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../styles&text&sizes/text_strings.dart';
import '../../widgets/appbar.dart';
import '../../widgets/primary_header_container.dart';
import '../../widgets/section_heading.dart';
import '../../widgets/settings_menu_tile.dart';
import '../../widgets/user_profile_tile.dart';
import '../cart/cart.dart';
import '../login/login.dart';
import '../order/order.dart';
import '../product_detail/all_ticket.dart';
import '../product_detail/favorite.dart';
import '../profile/profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// -- Header
            TPrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// AppBar
                  const TAppBar(
                    title: Text('Account',
                        style: TextStyle(color: Colors.white, fontSize: 35)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// User Profile Card
                  TUserProfileTile(
                      onPressed: () => Get.to(() => const ProfileScreen())),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),

            /// -- Body
            Padding(
              padding: const EdgeInsets.only(
                  left: TSizes.defaultSpace,
                  right: TSizes.defaultSpace,
                  top: TSizes.defaultSpace * 0.5),
              child: Column(
                children: [
                  /// -- Account Settings
                  //const SizedBox(height: TSizes.spaceBtwSections *),
                  const TSectionHeading(
                      title: 'Account Settings', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems * 0.2),

                  // TSettingsMenuTile(icon: Iconsax.message, title: 'Chat Room', subTitle: 'All messages on this way', onTap: () => Get.to(() =>  AllChatsScreen()),),
                  //TSettingsMenuTile(icon: Iconsax.message, title: 'Chat Room', subTitle: 'All messages on this way', onTap: () => Get.to(() =>  AllChatsScreen()),),
                  TSettingsMenuTile(
                      icon: Iconsax.folder_2,
                      title: 'All Posts',
                      subTitle: 'List all posts in TicketResell',
                      onTap: () => Get.to(() => const AllPost())),

                  TSettingsMenuTile(
                      icon: Iconsax.folder,
                      title: 'All Tickets',
                      subTitle: 'List all tickets in TicketResell',
                      onTap: () => Get.to(() => const AllTicket())),
                  TSettingsMenuTile(
                      icon: Iconsax.heart,
                      title: 'Favorite Tickets',
                      subTitle: 'List of your favorite tours',
                      onTap: () => Get.to(() => const FavoriteScreen())),
                  TSettingsMenuTile(
                    icon: Iconsax.safe_home,
                    title: 'Platform Fee',
                    subTitle: 'All platform fee to create new post',
                    onTap: () => Get.to(() => const PlatformFeeScreen()),
                  ),
                  // TSettingsMenuTile(
                  //     icon: Iconsax.shopping_cart,
                  //     title: 'Payment Platform',
                  //     subTitle: 'Add, remove products and move to checkout',
                  //     onTap: () => Get.to(() => const CartScreen())),
                  TSettingsMenuTile(
                      icon: Iconsax.bag_tick,
                      title: 'My Booking',
                      subTitle: 'In-progress and Completed Orders',
                      onTap: () => Get.to(() => const OrderScreen())),
                  TSettingsMenuTile(
                    icon: Iconsax.document_upload,
                    title: 'Create Post',
                    subTitle: 'Upload Data to your Cloud Firebase',
                    onTap: () => Get.to(() => const CreateTicket()),
                  ),

                  // const TSettingsMenuTile(icon: Iconsax.discount_shape, title: 'Recommend Tours', subTitle: 'List of all the recommend tours'),
                  // const TSettingsMenuTile(icon: Iconsax.notification, title: 'Notifications', subTitle: 'Set any kind of notifications message'),

                  /// -- App Settings
                  const SizedBox(height: TSizes.spaceBtwSections * 0.2),
                  const TSectionHeading(
                      title: 'App Settings', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems * 0.5),
                  // const TSettingsMenuTile(icon: Iconsax.document_upload, title: 'Load Data', subTitle: 'Upload Data to your Cloud Firebase'),
                  TSettingsMenuTile(
                    icon: Iconsax.location,
                    title: 'Geolocation',
                    subTitle: 'Set recommendation based on location',
                    trailing: Switch(value: true, onChanged: (value) {}),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.security_safe,
                    title: 'Safe Mode',
                    subTitle: 'Set result is safe for all ages',
                    trailing: Switch(value: false, onChanged: (value) {}),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.image,
                    title: 'HD Image Quality',
                    subTitle: 'Set image quality to be seen',
                    trailing: Switch(value: false, onChanged: (value) {}),
                  ),

                  /// -- Logout Button
                  const SizedBox(height: TSizes.spaceBtwSections),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFC7C5CC), width: 1),
                      ),
                      child: Center(
                        child: Text(
                          TTexts.loginOut,
                          style: GoogleFonts.getFont(
                            "Roboto Condensed",
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections * 2.5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
