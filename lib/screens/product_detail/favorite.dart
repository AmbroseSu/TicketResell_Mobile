// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:iconsax/iconsax.dart';
// import 'package:ticket_resell/api/response/ticket.dart';
// import '../../styles&text&sizes/product_card_vertical_fav.dart';
// import '../../styles&text&sizes/sizes.dart';
// import '../../widgets/appbar.dart';
// import '../../widgets/grid_layout.dart';
// import '../../widgets/t_circular_icon.dart';
// import '../explore_screen.dart';
//
// class FavoriteScreen extends StatefulWidget {
//   const FavoriteScreen({super.key});
//
//   @override
//   _FavoriteScreenState createState() => _FavoriteScreenState();
// }
//
// class _FavoriteScreenState extends State<FavoriteScreen> {
//   List<Ticket> tickets = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchTickets();
//   }
//
//   Future<void> fetchTickets() async {
//     final response = await http.get(Uri.parse(
//         'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get-list?page=1&limit=1000'));
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         tickets = (data['content'] as List)
//             .map((json) => Ticket.fromJson(json))
//             .toList();
//       });
//     } else {
//       // Xử lý lỗi ở đây
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: TAppBar(
//         title:
//             Text('Favorite', style: Theme.of(context).textTheme.headlineMedium),
//         showBackArrow: true,
//         actions: [
//           TCircularIcon(
//             icon: Iconsax.add,
//             onPressed: () => Get.to(const ExploreScreen()),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(TSizes.defaultSpace),
//           child: Column(
//             children: [
//               TGridLayout(
//                 itemCount: 6,
//                 itemBuilder: (_, index) => TProductCardVertical(
//                   ticket: tickets[index],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/api/response/ticket.dart';
import '../../styles&text&sizes/product_card_vertical_fav.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/appbar.dart';
import '../../widgets/grid_layout.dart';
import '../../widgets/t_circular_icon.dart';
import '../explore_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Ticket> tickets = [];

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get-list?page=1&limit=1000'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        tickets = (data['content'] as List)
            .map((json) => Ticket.fromJson(json))
            .toList();
      });
    } else {
      // Xử lý lỗi ở đây (hiển thị thông báo lỗi hoặc xử lý khác)
      print('Failed to load tickets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Favorite', style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: tickets.isEmpty
          ? Center(child: CircularProgressIndicator()) // Hiển thị vòng tròn loading khi chưa có dữ liệu
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TGridLayout(
                itemCount: tickets.length, // Đặt itemCount bằng độ dài của tickets
                itemBuilder: (_, index) => TProductCardVerticalFav(
                  ticket: tickets[index],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

