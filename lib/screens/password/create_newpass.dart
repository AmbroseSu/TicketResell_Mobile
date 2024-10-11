import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/screens/password/reset_password.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../styles&text&sizes/text_strings.dart';

class CreateNewpass extends StatelessWidget {
  const CreateNewpass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Headings
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
              child: Text(
                // TTexts.otpVerificationTitle,
                'Create your password',

                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),


            /// Text fields
            TextFormField(
              decoration: const InputDecoration(labelText: TTexts.password, prefixIcon: Icon(Iconsax.direct_right)),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            TextFormField(
              decoration: const InputDecoration(labelText: TTexts.conPassword, prefixIcon: Icon(Iconsax.direct_right)),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Submit Button
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(onPressed: () =>
            //       Get.off(() => const ResetPassword()), child: const Text(TTexts.create),
            //     // Get.off(() => const ResetPassword()), child: const Text(TTexts.submit)
            //   ),
            // )
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPassword()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color:  Colors.blueAccent,
                ),
                child: Center(
                  child: Text(
                    "Create",
                    style: GoogleFonts.getFont(
                      "Roboto Condensed",
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

          ],
        ),
      ),
    );
  }
}
