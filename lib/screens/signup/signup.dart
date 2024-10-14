import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/consts.dart';
import 'package:ticket_resell/models/user_profile.dart';
import 'package:ticket_resell/services/auth_service.dart';
import 'package:ticket_resell/services/database_service.dart';
import 'package:ticket_resell/services/media_service.dart';
import 'package:ticket_resell/services/navigation_service.dart';
import 'package:ticket_resell/services/storage_service.dart';

import '../../styles&text&sizes/sizes.dart';
import '../../styles&text&sizes/text_strings.dart';
import '../../widgets/login_signup/form_divider.dart';
import '../../widgets/login_signup/social_buttons.dart';
import '../login/login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  late AuthService _authService;
  late MediaService _mediaService;
  late NavigationService _navigationService;
  late StorageService _storageService;
  late DatabaseService _databaseService;
  String? password, name;
  //String? name = UserManager().email;
  String? email = "ambrose@gmail.com";
  File? selectedImage;
  String? selectedGender; // Variable to store selected gender
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    //_alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              /// Title
              Text('Create new account',
                  style: Theme.of(context).textTheme.headlineLarge ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Form
              Form(
                key: _registerFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _pfpSelectionFiled(),
                    Text('Choose Avatar',
                        style: Theme.of(context).textTheme.titleSmall),
                    /// Fullname
                    TextFormField(
                      expands: false,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Iconsax.user),
                      ),
                      onSaved: (value) {
                        setState(
                              () {
                            name = value;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Phone number
                    TextFormField(
                      expands: false,
                      decoration: const InputDecoration(
                        labelText: TTexts.phoneNo,
                        prefixIcon: Icon(Iconsax.call),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Password
                    TextFormField(
                      expands: false,
                      decoration: const InputDecoration(
                        labelText: TTexts.password,
                        prefixIcon: Icon(Iconsax.password_check),
                        suffixIcon: Icon(Iconsax.eye_slash),
                      ),
                      onSaved: (value) {
                        setState(
                              () {
                            password = value;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Confirm Password
                    TextFormField(
                      expands: false,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Iconsax.password_check),
                        suffixIcon: Icon(Iconsax.eye_slash),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Address
                    TextFormField(
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: TTexts.address,
                          prefixIcon: Icon(Iconsax.location)),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Gender Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: Icon(Iconsax.user_tag),
                      ),
                      dropdownColor: Colors.white,
                      value: selectedGender,
                      items: <String>['Female', 'Male', 'Other']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedGender = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Terms&Conditions Checkbox
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: true,
                            onChanged: (value) {},
                            checkColor: Colors.white,
                            activeColor: Colors.blueAccent,
                            side: BorderSide(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(
                                text: 'By using TicketResell, you agree to ',
                                style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(
                                text: 'Terms ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(
                                    color: Colors.black,
                                    decorationColor: Colors.black)),
                            TextSpan(
                                text: 'and ',
                                style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(
                                text: '\nPrivacy Policy',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(
                                    color: Colors.black,
                                    decorationColor: Colors.black)),
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// Sign Up Button
                    MaterialButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          if ((_registerFormKey.currentState?.validate() ?? false) &&
                              selectedImage != null) {
                            _registerFormKey.currentState?.save();
                            print("000000000000000000000000000000000000000000000000000000000000000000");
                            print(email);
                            print(password);
                            bool result = await _authService.signup(email!, password!);
                            print(result);
                            if (result) {
                              String? pfpURL = await _storageService.uploadUserPfp(
                                file: selectedImage!,
                                uid: _authService.user!.uid,
                              );


                              if (pfpURL != null) {
                              print(_authService.user!.uid);
                              print(name);
                              print("1111111111111111111111111111111111111111111111111111111111111111");

                              try{
                                await _databaseService.createUserProfile(
                                  userProfile: UserProfile(
                                      uid: _authService.user!.uid,
                                      name: name,
                                      pfpURL: pfpURL),
                                );
                              }catch(e){
                                print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000000000");
                              }


                                // _alertService.showToast(
                                //   text: "User registered successfully!",
                                //   icon: Icons.check,
                                // );
                                //_navigationService.goBack();
                                _navigationService.pushReplacementNamed("/login");
                              //Get.to(() => const SignupScreen());
                              //} else {
                              //  throw Exception("Unable to upload user profile picture");
                              }
                            } else {
                              throw Exception("Unable to register user");
                            }
                          }
                        } catch (e) {
                          print(e);
                          print("66666666666666666666666666666666666666666666666666666666666666");
                          // _alertService.showToast(
                          //   text: "Failed to register, Please try again!",
                          //   icon: Icons.error,
                          // );
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blueAccent,
                        ),
                        child: Center(
                          child: Text(
                            TTexts.createAccount,
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
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Divider
              TFormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Social Buttons
              const TSocialButtons(),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pfpSelectionFiled() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFF) as ImageProvider,
      ),
    );
  }
}
