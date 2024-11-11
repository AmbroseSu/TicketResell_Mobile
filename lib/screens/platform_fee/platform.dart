import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../styles&text&sizes/colors.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/appbar.dart';
import '../../widgets/single_platform.dart';
import '../../widgets/t_circular_icon.dart';
import '../explore_screen.dart';
import 'add_new_address.dart';

class PlatformFeeScreen extends StatelessWidget {
  const PlatformFeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Platform Fee', style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: TColors.primary,
      //   onPressed: () => Get.to(() => const AddNewAddressScreen()),
      //   child: const Icon(Iconsax.add, color: TColors.white),
      // ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TSinglePlatform(selectedAddress: true),
              // TSingleAddress(selectedAddress: true),
            ],
          ),
        ),
      ),
    );
  }
}
