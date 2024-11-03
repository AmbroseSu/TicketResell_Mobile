// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_it/get_it.dart';
// import 'package:iconsax/iconsax.dart';
// import '../../api/global_variables/user_manage.dart';
// import '../../services/media_service.dart';
// import '../../services/storage_service.dart';
// import '../../styles&text&sizes/colors.dart';
// import '../../styles&text&sizes/image_strings.dart';
// import '../../styles&text&sizes/sizes.dart';
// import '../../widgets/appbar.dart';
// import '../../widgets/profile_menu.dart';
// import '../../widgets/section_heading.dart';
// import '../../widgets/t_circular_icon.dart';
// import '../../widgets/t_circular_image.dart';
// import '../settings/settings.dart';
// import 'package:http/http.dart' as http;
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final GetIt _getIt = GetIt.instance;
//   late StorageService _storageService;
//   late MediaService _mediaService;
//   late Future<Map<String, dynamic>> userProfile;
//   File? selectedImage;
//   @override
//   void initState() {
//     super.initState();
//     userProfile = fetchUserProfile();
//     _mediaService = _getIt.get<MediaService>();
//     _storageService = _getIt.get<StorageService>();
//   }
//
//
//   Future<Map<String, dynamic>> fetchUserProfile() async {
//     final int? userId = UserManager().id;
//
//     if (userId == null) {
//       throw Exception('User ID is null');
//     }
//
//     final response = await http.get(
//       Uri.parse("https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/User/get-user-by-id?id=$userId"),
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(utf8.decode(response.bodyBytes));
//       if (data['content'] != null) {
//         return data['content'];
//       } else {
//         throw Exception('User data is null');
//       }
//     } else if (response.statusCode == 404) {
//       throw Exception('User not found: ${response.reasonPhrase}');
//     } else {
//       throw Exception('Failed to load user profile: ${response.reasonPhrase}');
//     }
//   }
//
//
//   Future<void> updateUserProfile(int userId, Map<String, dynamic> updatedData) async {
//     final response = await http.post(
//       Uri.parse("https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/User/edit-profile-user?id=$userId"),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(updatedData),
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       print('Profile updated successfully: ${data['details']}');
//     } else {
//       throw Exception('Failed to update profile: ${response.reasonPhrase}');
//     }
//   }
//
//   void _showEditProfileDialog({
//     required BuildContext context,
//     required String title,
//     required String initialValue,
//     required Function(String) onSave,
//   }) {
//     final TextEditingController controller = TextEditingController(text: initialValue);
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: Text('Edit $title'),
//           content: TextField(
//             controller: controller,
//             decoration: InputDecoration(labelText: title),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Đóng dialog
//               },
//               child: const Text('Cancel', style: TextStyle(color: Colors.black)),
//             ),
//             TextButton(
//               onPressed: () {
//                 onSave(controller.text); // Gọi hàm onSave với giá trị mới
//                 Navigator.of(context).pop(); // Đóng dialog
//               },
//               child: const Text('Save', style: TextStyle(color: Color(0xFF55B97D))),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
//         centerTitle: true,
//       ),
//       body:
//       // FutureBuilder<Map<String, dynamic>>(
//       //   future: userProfile,
//       //   builder: (context, snapshot) {
//       //     if (snapshot.connectionState == ConnectionState.waiting) {
//       //       return const Center(child: CircularProgressIndicator());
//       //     } else if (snapshot.hasError) {
//       //       return Center(child: Text('Error: ${snapshot.error}'));
//       //     } else if (!snapshot.hasData) {
//       //       return const Center(child: Text('No user data found'));
//       //     }
//       //
//       //     final user = snapshot.data!;
//
//       FutureBuilder<Map<String, dynamic>>(
//         future: userProfile,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return const Center(child: Text('No user data found'));
//           }
//
//           final user = snapshot.data!;
//           print("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
//           print(user['phoneNumber']);
//           final int userId = user['id'];
//
//
//           return SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.all(TSizes.defaultSpace),
//               child: Column(
//                 children: [
//                   /// Profile Picture
//                   SizedBox(
//                     width: double.infinity,
//                     child: Column(
//                       children: [
//                         // const TCircularImage(image: TImages.user, width: 80, height: 80),
//                         // TextButton(
//                         //   onPressed: () {},
//                         //   child: const Text('Change Profile Picture', style: TextStyle(color: TColors.black)),
//                         // ),
//
//                         SizedBox(
//                           width: double.infinity,
//                           child: Column(
//                             children: [
//                               ClipOval(
//                                 child: user['image'] != null
//                                     ? Image.network(
//                                   user['image'], // Sử dụng Image.network cho hình ảnh từ API
//                                   width: 80,
//                                   height: 80,
//                                   fit: BoxFit.cover, // Căn chỉnh hình ảnh
//                                 )
//                                     : Image.asset(
//                                   TImages.user, // Sử dụng Image.asset cho hình ảnh mặc định
//                                   width: 80,
//                                   height: 80,
//                                   fit: BoxFit.cover, // Căn chỉnh hình ảnh
//                                 ),
//                               ),
//
//                               TextButton(
//                                 onPressed: () async {
//                                   File? file = await _mediaService.getImageFromGallery();
//                                   if (file != null) {
//                                     setState(() {
//                                       selectedImage = file;
//                                     });
//                                   }
//                                   final String? pfpURL = await _storageService.uploadUserPfp(
//                                     file: selectedImage!, uid: '',
//                                   );
//                                   final updatedData = {
//                                     "id": userId,
//                                     "fullname": user['fullname'],
//                                     "email": user['email'] ?? '',
//                                     "address": user['address'] ?? '',
//                                     "phoneNumber": user['phone'] ?? '',
//                                     "gender": user['gender'] ?? 'MALE',
//                                     "image" : pfpURL ?? '',
//                                     "role": user['role'] ?? 'CUSTOMER',
//                                   };
//                                   updateUserProfile(userId, updatedData).then((_) {
//                                     setState(() {
//                                       user['image'] = pfpURL;
//                                     });
//                                   }).catchError((error) {
//                                     print('Failed to update profile: $error');
//                                   });
//                                 },
//                                 child: const Text('Change Profile Picture', style: TextStyle(color: TColors.black)),
//                               ),
//                             ],
//                           ),
//                         ),
//
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
//                   TProfileMenu(
//                     onPressed: () {
//                       _showEditProfileDialog(
//                         context: context,
//                         title: 'Name',
//                         initialValue: user['fullname'].toString() ?? 'N/A',
//                         onSave: (newValue) {
//                           final updatedData = {
//                             "id": userId,
//                             "fullname": newValue,
//                             "email": user['email'] ?? '',
//                             "address": user['address'] ?? '',
//                             "phoneNumber": user['phone'] ?? '',
//                             "image" : user['image'] ?? '',
//                             "gender": user['gender'] ?? 'MALE',
//                             "role": user['role'] ?? 'CUSTOMER',
//                           };
//
//                           updateUserProfile(userId, updatedData).then((_) {
//                             setState(() {
//                               user['fullname'] = newValue;
//                             });
//                           }).catchError((error) {
//                             print('Failed to update profile: $error');
//                           });
//                         },
//                       );
//                     },
//                     title: 'Name',
//                     value: user['fullname'] ?? 'N/A',
//                   ),
//
//                   TProfileMenu(
//                     onPressed: () {
//                       _showEditProfileDialog(
//                         context: context,
//                         title: 'Address',
//                         initialValue: user['address'].toString() ?? 'N/A',
//                         onSave: (newValue) {
//                           final updatedData = {
//                             "id": userId,
//                             "fullname": user['fullname'] ?? '',
//                             "email": user['email'] ?? '',
//                             "address": newValue,
//                             "phoneNumber": user['phone'] ?? '',
//                             "image" : user['image'] ?? '',
//                             "gender": user['gender'] ?? 'MALE',
//                             "role": user['role'] ?? 'CUSTOMER',
//                           };
//
//                           updateUserProfile(userId, updatedData).then((_) {
//                             setState(() {
//                               user['address'] = newValue;
//                             });
//                           }).catchError((error) {
//                             print('Failed to update profile: $error');
//                           });
//                         },
//                       );
//                     },
//                     title: 'Address',
//                     value: user['address'] ?? 'N/A',
//                   ),
//
//                   const SizedBox(height: TSizes.spaceBtwItems),
//                   const Divider(),
//                   const SizedBox(height: TSizes.spaceBtwItems),
//
//                   /// Heading Personal Info
//                   const TSectionHeading(title: 'Personal Information', showActionButton: false),
//                   const SizedBox(height: TSizes.spaceBtwItems),
//
//                   TProfileMenu(
//                     onPressed: () {},
//                     icon: Iconsax.copy,
//                     title: 'Role',
//                     value: user['role'] ?? 'N/A',
//                   ),
//                   TProfileMenu(
//                     onPressed: () {},
//                     title: 'E-mail',
//                     value: user['email'] ?? 'N/A',
//                   ),
//                   TProfileMenu(
//                     onPressed: () {
//                       _showEditProfileDialog(
//                         context: context,
//                         title: 'Phone Number',
//                         initialValue: user['phoneNumber'] ?? 'N/A',
//                         onSave: (newValue) {
//                           final updatedData = {
//                             "id": userId,
//                             "fullname": user['fullname'] ?? '',
//                             "email": user['email'] ?? '',
//                             "address": user['address'] ?? '',
//                             "phoneNumber": newValue,
//                             "image" : user['image'] ?? '',
//                             "gender": user['gender'] ?? 'MALE',
//                             "role": user['role'] ?? 'CUSTOMER',
//                           };
//
//                           updateUserProfile(userId, updatedData).then((_) {
//                             setState(() {
//                               user['phoneNumber'] = newValue;
//                             });
//                           }).catchError((error) {
//                             print('Failed to update profile: $error');
//                           });
//                         },
//                       );
//                     },
//                     title: 'Phone Number',
//                     value: user['phoneNumber'] ?? 'N/A',
//                   ),
//
//                   TProfileMenu(
//                     onPressed: () {},
//                     title: 'Gender',
//                     value: user['gender']?.toUpperCase() ?? 'N/A',
//                   ),
//
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
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import '../../api/global_variables/user_manage.dart';
import '../../services/media_service.dart';
import '../../services/storage_service.dart';
import '../../styles&text&sizes/colors.dart';
import '../../styles&text&sizes/image_strings.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/appbar.dart';
import '../../widgets/profile_menu.dart';
import '../../widgets/section_heading.dart';
import '../../widgets/t_circular_icon.dart';
import '../../widgets/t_circular_image.dart';
import '../settings/settings.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GetIt _getIt = GetIt.instance;
  late StorageService _storageService;
  late MediaService _mediaService;
  late Future<Map<String, dynamic>> userProfile;
  File? selectedImage;
  @override
  void initState() {
    super.initState();
    userProfile = fetchUserProfile();
    _mediaService = _getIt.get<MediaService>();
    _storageService = _getIt.get<StorageService>();
  }


  Future<Map<String, dynamic>> fetchUserProfile() async {
    final int? userId = UserManager().id;

    if (userId == null) {
      throw Exception('User ID is null');
    }

    final response = await http.get(
      Uri.parse("https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/User/get-user-by-id?id=$userId"),
    );

    if (response.statusCode == 200) {
      // Sử dụng utf-8 để giải mã nội dung
      final data = json.decode(utf8.decode(response.bodyBytes));
      return data['content'];
    } else if (response.statusCode == 404) {
      throw Exception('User not found: ${response.reasonPhrase}');
    } else {
      throw Exception('Failed to load user profile: ${response.reasonPhrase}');
    }
  }


  Future<void> updateUserProfile(int userId, Map<String, dynamic> updatedData) async {
    final response = await http.post(
      Uri.parse("https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/User/edit-profile-user?userId=$userId"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Profile updated successfully: ${data['details']}');
    } else {
      throw Exception('Failed to update profile: ${response.reasonPhrase}');
    }
  }

  void _showEditProfileDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Function(String) onSave,
  }) {
    final TextEditingController controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: title),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text); // Gọi hàm onSave với giá trị mới
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Save', style: TextStyle(color: Color(0xFF55B97D))),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body:
      FutureBuilder<Map<String, dynamic>>(
        future: userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user data found'));
          }

          final user = snapshot.data!;
          print("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
          print(user['phoneNumber']);
          final int userId = user['id'];


          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  /// Profile Picture
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        // const TCircularImage(image: TImages.user, width: 80, height: 80),
                        // TextButton(
                        //   onPressed: () {},
                        //   child: const Text('Change Profile Picture', style: TextStyle(color: TColors.black)),
                        // ),

                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              ClipOval(
                                child: user['image'] != null
                                    ? Image.network(
                                  user['image'], // Sử dụng Image.network cho hình ảnh từ API
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover, // Căn chỉnh hình ảnh
                                )
                                    : Image.asset(
                                  TImages.user, // Sử dụng Image.asset cho hình ảnh mặc định
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover, // Căn chỉnh hình ảnh
                                ),
                              ),

                              TextButton(
                                onPressed: () async {
                                  File? file = await _mediaService.getImageFromGallery();
                                  if (file != null) {
                                    setState(() {
                                      selectedImage = file;
                                    });
                                  }
                                  final String? pfpURL = await _storageService.uploadUserPfp(uid: UserManager().email.toString(),
                                    file: selectedImage!,
                                  );
                                  final updatedData = {
                                    "id": userId,
                                    "fullname": user['fullname'],
                                    "email": user['email'] ?? '',
                                    "address": user['address'] ?? '',
                                    "phoneNumber": user['phone'] ?? '',
                                    "gender": user['gender'] ?? 'MALE',
                                    "image" : pfpURL ?? '',
                                    "role": user['role'] ?? 'CUSTOMER',
                                  };
                                  updateUserProfile(userId, updatedData).then((_) {
                                    setState(() {
                                      user['image'] = pfpURL;
                                    });
                                  }).catchError((error) {
                                    print('Failed to update profile: $error');
                                  });
                                },
                                child: const Text('Change Profile Picture', style: TextStyle(color: TColors.black)),
                              ),
                            ],
                          ),
                        ),

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

                  TProfileMenu(
                    onPressed: () {
                      _showEditProfileDialog(
                        context: context,
                        title: 'Name',
                        initialValue: user['fullname'].toString() ?? 'N/A',
                        onSave: (newValue) {
                          final updatedData = {
                            "id": userId,
                            "fullname": newValue,
                            "email": user['email'] ?? '',
                            "address": user['address'] ?? '',
                            "phoneNumber": user['phone'] ?? '',
                            "image" : user['image'] ?? '',
                            "gender": user['gender'] ?? 'MALE',
                            "role": user['role'] ?? 'CUSTOMER',
                          };

                          updateUserProfile(userId, updatedData).then((_) {
                            setState(() {
                              user['fullname'] = newValue;
                            });
                          }).catchError((error) {
                            print('Failed to update profile: $error');
                          });
                        },
                      );
                    },
                    title: 'Name',
                    value: user['fullname'] ?? 'N/A',
                  ),

                  TProfileMenu(
                    onPressed: () {
                      _showEditProfileDialog(
                        context: context,
                        title: 'Address',
                        initialValue: user['address'].toString() ?? 'N/A',
                        onSave: (newValue) {
                          final updatedData = {
                            "id": userId,
                            "fullname": user['fullname'] ?? '',
                            "email": user['email'] ?? '',
                            "address": newValue,
                            "phoneNumber": user['phone'] ?? '',
                            "image" : user['image'] ?? '',
                            "gender": user['gender'] ?? 'MALE',
                            "role": user['role'] ?? 'CUSTOMER',
                          };

                          updateUserProfile(userId, updatedData).then((_) {
                            setState(() {
                              user['address'] = newValue;
                            });
                          }).catchError((error) {
                            print('Failed to update profile: $error');
                          });
                        },
                      );
                    },
                    title: 'Address',
                    value: user['address'] ?? 'N/A',
                  ),

                  const SizedBox(height: TSizes.spaceBtwItems),
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  /// Heading Personal Info
                  const TSectionHeading(title: 'Personal Information', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  TProfileMenu(
                    onPressed: () {},
                    icon: Iconsax.copy,
                    title: 'Role',
                    value: user['role'].toString() ?? 'N/A',
                  ),
                  TProfileMenu(
                    onPressed: () {},
                    title: 'E-mail',
                    value: user['email'] ?? 'N/A',
                  ),
                  TProfileMenu(
                    onPressed: () {
                      _showEditProfileDialog(
                        context: context,
                        title: 'Phone Number',
                        initialValue: user['phoneNumber'] ?? 'N/A',
                        onSave: (newValue) {
                          final updatedData = {
                            "id": userId,
                            "fullname": user['fullname'] ?? '',
                            "email": user['email'] ?? '',
                            "address": user['address'] ?? '',
                            "phoneNumber": newValue,
                            "image" : user['image'] ?? '',
                            "gender": user['gender'] ?? 'MALE',
                            "role": user['role'] ?? 'CUSTOMER',
                          };

                          updateUserProfile(userId, updatedData).then((_) {
                            setState(() {
                              user['phoneNumber'] = newValue;
                            });
                          }).catchError((error) {
                            print('Failed to update profile: $error');
                          });
                        },
                      );
                    },
                    title: 'Phone Number',
                    value: user['phoneNumber'] ?? 'N/A',
                  ),

                  TProfileMenu(
                    onPressed: () {},
                    title: 'Gender',
                    value: "${user['gender']}" ?? 'N/A',
                  ),

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
          );
        },
      ),
    );
  }
}

