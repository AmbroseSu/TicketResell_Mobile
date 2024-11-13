import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/widgets/t_circular_image.dart';
import '../api/global_variables/user_manage.dart';
import '../styles&text&sizes/colors.dart';
import '../styles&text&sizes/image_strings.dart';
import 'package:http/http.dart' as http;


class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({
    super.key, required this.onPressed,
  });

  final VoidCallback onPressed;

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final int? userId = UserManager().id;

    if (userId == null) {
      throw Exception('User ID is null');
    }

    final response = await http.get(
      Uri.parse("https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/User/get-user-by-id?id=$userId"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['content'];
    } else if (response.statusCode == 404) {
      throw Exception('User not found: ${response.reasonPhrase}');
    } else {
      throw Exception('Failed to load user profile: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            leading: CircularProgressIndicator(),
            title: Text('Loading...'),
          );
        } else if (snapshot.hasError) {
          return ListTile(
            title: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData) {
          return const ListTile(
            title: Text('No data available'),
          );
        }

        final userProfile = snapshot.data!;
        final userImage = userProfile['image'] ?? TImages.user; // Lấy hình ảnh từ dữ liệu API

        return ListTile(
          leading: TCircularImage(
            image: userImage,
            isNetworkImage: userImage.startsWith('http'),
            width: 50,
            height: 50,
            padding: 0,
          ),
          title: Text('Your Account', style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white)),
          subtitle: Text('See your account in Edit Button', style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white)),
          trailing: IconButton(onPressed: onPressed, icon: const Icon(Iconsax.edit, color: TColors.white)),
        );
      },
    );
  }
}