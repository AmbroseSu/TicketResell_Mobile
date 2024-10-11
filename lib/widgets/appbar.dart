import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../navigation_menu.dart';
import '../styles&text&sizes/colors.dart';
import '../styles&text&sizes/sizes.dart';
import '../utils/device_utility.dart';
//
// class TAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const TAppBar({
//     super.key,
//     this.title,
//     this.leadingIcon,
//     this.leadingOnPressed,
//     this.actions,
//     this.showBackArrow = false,
//   });
//
//   final Widget? title;
//   final bool showBackArrow;
//   final IconData? leadingIcon;
//   final List<Widget>? actions;
//   final VoidCallback? leadingOnPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
//       child: AppBar(
//         automaticallyImplyLeading: false,
//         leading: showBackArrow
//             ? IconButton(
//                 onPressed: () => Get.back(),
//                 icon: const Icon(Iconsax.arrow_left))
//             : leadingIcon != null ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon)) : null,
//         title: title,
//         actions: actions,
//       ),
//     );
//   }
//
//   @override
//   // TODO: implement preferredSize
//   Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
// }

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    super.key,
    this.title,
    this.leadingIcon,
    this.leadingOnPressed,
    this.actions,
    this.showBackArrow = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 50, 23, 5), // Added vertical padding to ensure proper alignment
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBackArrow)
            IconButton(
              onPressed: () => Get.to(() => const NavigationMenu()),
              icon: const Icon(Iconsax.arrow_left, color: TColors.black),
            ),
          title ?? const SizedBox.shrink(),
          if (actions != null)
            Row(children: actions!),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
