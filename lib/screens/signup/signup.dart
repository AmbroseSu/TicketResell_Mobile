import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/api/global_variables/fcm_token_manage.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/consts.dart';
import 'package:ticket_resell/models/user_profile.dart';
import 'package:ticket_resell/services/auth_service.dart';
import 'package:ticket_resell/services/database_service.dart';
import 'package:ticket_resell/services/media_service.dart';
import 'package:ticket_resell/services/navigation_service.dart';
import 'package:ticket_resell/services/storage_service.dart';
import 'package:http/http.dart' as http;
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
  UserManager userManager = UserManager();
  String? email = UserManager().email;
  File? selectedImage;
  String? pfpURL;
  //String? selectedGender; // Variable to store selected gender
  bool isLoading = false;
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
  TextEditingController();
  final ValueNotifier<int?> selectedGender = ValueNotifier<int?>(null);
  final TextEditingController _addressController = TextEditingController();
  final String _baseUrl =
      'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Authentication/save-info';

  //UserManager userManager = UserManager();
  bool _showPassword = false;
  bool _showConfirmPassword = false;

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

  Future<void> _signup() async {
    final String? email = userManager.email;
    final String fullname = _fullnameController.text;
    final String phone = _phoneController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _passwordConfirmController.text;
    final String address = _addressController.text;
    final int gender = selectedGender.value ?? 3;
    //final String? fcmtoken = TokenManager().fcmToken;
    final String? fcmtoken = "String";
    //String? pfpURL;

    // if (selectedImage != null) {
    //   bool result = await _authService.signup(email!, password!);
    //   if(result) {
    //     pfpURL = await _storageService.uploadUserPfp(
    //       file: selectedImage!,
    //       uid: _authService.user!.uid,
    //     );
    //   }
    //
    // }else{
    //   pfpURL = null;
    // }



    if (confirmPassword != password) {
      Get.snackbar(
        'Error',
        'Confirm password does not match',
        snackPosition: SnackPosition.TOP,
        //backgroundColor: Colors.white,
        colorText: Colors.red,
      );
      return; // Dừng hàm nếu không trùng
    }
    if (fullname.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please input all fields',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
      return; // Dừng hàm nếu có bất kỳ trường nào trống
    }

    final Map<String, dynamic> data = {
      'email': email,
      'fullname': fullname,
      'phoneNumber': phone,
      'password': password,
      'address': address,
      'gender': gender,
      'fcmToken': fcmtoken,
      'image': pfpURL,
    };

    print("Đây là data aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa: $data");
    print(fullname);
    print(phone);
    print(address);
    print(password);
    print(gender);
    print(fcmtoken);
    print(pfpURL);

    final Uri url = Uri.parse(_baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      String? fcmToken = TokenManager().fcmToken;
      if (response.statusCode == 200) {
        String body = "Save information successfully. Please login !!";
        String title = "Create Successfully.";
        // await PushNotificationService.sendNotificationToSelectedDrived(
        //     fcmToken,
        //     context,
        //     title,
        //     body
        // );
        Get.to(() => const LoginScreen());
      } else {
        // Xử lý khi API thất bại
        Get.snackbar('Error', 'Failed to sign up: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi kết nối
      Get.snackbar('Error', 'Failed to connect to the server: $e');
    }
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
                      controller: _fullnameController,
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
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: TTexts.phoneNo,
                        prefixIcon: Icon(Iconsax.call),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Password
                    TextFormField(
                      expands: false,
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: TTexts.password,
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword ? Iconsax.eye : Iconsax.eye_slash,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
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
                      controller: _passwordConfirmController,
                      obscureText: !_showConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showConfirmPassword
                                ? Iconsax.eye
                                : Iconsax.eye_slash,
                          ),
                          onPressed: () {
                            setState(() {
                              _showConfirmPassword = !_showConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Address
                    TextFormField(
                      expands: false,
                      controller: _addressController,
                      decoration: const InputDecoration(
                          labelText: TTexts.address,
                          prefixIcon: Icon(Iconsax.location)),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Gender Dropdown
                    ValueListenableBuilder<int?>(
                      valueListenable: selectedGender,
                      builder: (context, value, child) {
                        // Ánh xạ giá trị int thành chuỗi tương ứng
                        String? genderString;
                        switch (value) {
                          case 0:
                            genderString = 'Male';
                            break;
                          case 1:
                            genderString = 'Female';
                            break;
                          case 2:
                            genderString = 'Other';
                            break;
                          default:
                            genderString = null;
                        }

                        return DropdownButtonFormField<String>(
                          value: genderString, // Hiển thị chuỗi (Male, Female, Other)
                          onChanged: (String? newValue) {
                            // Cập nhật giá trị thành int tương ứng
                            switch (newValue) {
                              case 'Male':
                                selectedGender.value = 0; // Lưu thành 0 cho Male
                                break;
                              case 'Female':
                                selectedGender.value = 1; // Lưu thành 1 cho Female
                                break;
                              case 'Other':
                                selectedGender.value = 2; // Lưu thành 2 cho Other
                                break;
                              default:
                                selectedGender.value = null;
                            }
                          },
                          items: <String>['Male', 'Female', 'Other']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            prefixIcon: Icon(Iconsax.user),
                          ),
                        );
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
                            print("9999999999999999999999999999999999999999999999999999999999999");
                            print(result);
                            if (result) {
                              print("7777777777777777777777777777777777777777777777777777");
                              print(selectedImage);
                              print(_authService.user!.uid);
                              //String? pfpURL;
                              try{
                                 pfpURL = await _storageService.uploadUserPfp(
                                  file: selectedImage!,
                                  uid: _authService.user!.uid,
                                );
                              }catch(e){
                                print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
                              }



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
                                //_navigationService.pushReplacementNamed("/login");
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
                        _signup();
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
