import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/api/response/post.dart';
import 'package:ticket_resell/styles&text&sizes/shadows.dart';
import 'package:ticket_resell/styles&text&sizes/sizes.dart';
import '../api/global_variables/user_manage.dart';
import '../api/response/post_element.dart';
import '../api/response/ticket.dart';
import '../screens/product_detail/place_screen.dart';
import '../widgets/helper_functions.dart';
import '../widgets/product_price_text.dart';
import '../widgets/product_title_text.dart';
import '../widgets/rounded_container.dart';
import 'colors.dart';
import 'package:http/http.dart' as http;
//
// class MyPostCardVertical extends StatefulWidget {
//   final PostResponse postResponse;
//
//   const MyPostCardVertical({super.key, required this.postResponse});
//
//   @override
//   _MyPostCardVertical createState() => _MyPostCardVertical();
// }
//
// class _MyPostCardVertical extends State<MyPostCardVertical> {
//
//   Ticket? ticket;
//   PostElement? activePostElement;
//
//   @override
//   void initState() {
//     super.initState();
//     findActivePostElement(); // Gọi hàm tìm phần tử ACTIVE khi widget được tạo
//   }
//
//   Future<void> fetchTickets() async {
//     final response = await http.get(Uri.parse(
//         'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get?ticketId=${widget.postResponse.ticketId}'));
//     print(response.statusCode);
//     var responseData = jsonDecode(response.body);
//
//     if (responseData['statusCode'] == 200) {
//
//       ticket = Ticket.fromJson(responseData['content']);
//       print("0101010101010101010101010101010101010101");
//       Get.to(() => PlaceScreen(ticket: ticket!));
//     } else {
//       // Xử lý lỗi ở đây (hiển thị thông báo lỗi hoặc xử lý khác)
//       print('Failed to load tickets');
//     }
//   }
//
//   void findActivePostElement() {
//     activePostElement = widget.postResponse.postElements
//         .firstWhere((postElement) => postElement.status == 'ACTIVE');
//     // In ra post element có status là ACTIVE (nếu có)
//     print('Active Post Element: $activePostElement');
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);
//
//     return GestureDetector(
//       onTap: fetchTickets,
//       child: Container(
//         width: 180,
//         padding: const EdgeInsets.all(1),
//         decoration: BoxDecoration(
//           boxShadow: [TShadowStyle.verticalProductShadow],
//           borderRadius: BorderRadius.circular(TSizes.productImageRadius),
//           color: dark ? TColors.darkGrey : TColors.white,
//         ),
//         child: Column(
//           children: [
//             TRoundedContainer(
//               padding: const EdgeInsets.all(TSizes.sm),
//               backgroundColor: dark ? TColors.dark : TColors.light,
//               child: Stack(
//                 children: [
//                   AspectRatio(
//                     aspectRatio: 4 / 4,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10), // Adjust as needed for rounded corners
//                       child: Image.network(
//                         widget.postResponse.imageUrls.isNotEmpty
//                             ? widget.postResponse.imageUrls[0]
//                             : 'https://i.pinimg.com/736x/d7/07/84/d70784b885602af2877dd7a7230bba2c.jpg',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 12,
//                     child: TRoundedContainer(
//                       radius: TSizes.sm,
//                       backgroundColor: TColors.secondary.withOpacity(0.8),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: TSizes.sm, vertical: TSizes.xs),
//                       child: Text('${widget.postResponse.quantity} ticket',
//                           style: Theme.of(context)
//                               .textTheme
//                               .labelLarge!
//                               .apply(color: TColors.black)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: TSizes.spaceBtwItems / 2),
//             Padding(
//               padding: const EdgeInsets.only(left: TSizes.sm),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TProductTitleText(title: activePostElement!.title, smallSize: true),
//                   const SizedBox(height: TSizes.spaceBtwItems / 2),
//                   Row(
//                     children: [
//                       Text(widget.postResponse.categoryName,
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                           style: Theme.of(context).textTheme.labelMedium),
//                       const SizedBox(width: TSizes.xs),
//                       const Icon(Iconsax.verify5,
//                           color: TColors.primary, size: TSizes.iconXs),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(left: TSizes.sm),
//                   child: TProductPriceText(price: '${widget.postResponse.price}'),
//                 ),
//                 Container(
//                   decoration: const BoxDecoration(
//                     color: TColors.dark,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(TSizes.cardRadiusMd),
//                       bottomRight: Radius.circular(TSizes.productImageRadius),
//                     ),
//                   ),
//                   child: const SizedBox(
//                     width: TSizes.iconLg * 1.2,
//                     height: TSizes.iconLg * 1.2,
//                     child: Center(child: Icon(Iconsax.add, color: TColors.white)),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


class MyPostCardVertical extends StatefulWidget {
  final PostResponse postResponse;
  final PostElement postElement;

  const MyPostCardVertical({super.key, required this.postResponse, required this.postElement});

  @override
  _MyPostCardVertical createState() => _MyPostCardVertical();
}

class _MyPostCardVertical extends State<MyPostCardVertical> {
  Ticket? ticket;
  PostElement? activePostElement;

  @override
  void initState() {
    super.initState();
    //findActivePostElement(); // Gọi hàm tìm phần tử ACTIVE khi widget được tạo
  }

  Future<void> fetchTickets() async {
    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get?ticketId=${widget.postResponse.ticketId}'));
    print(response.statusCode);
    var responseData = jsonDecode(response.body);

    if (responseData['statusCode'] == 200) {
      ticket = Ticket.fromJson(responseData['content']);
      print("0101010101010101010101010101010101010101");
      Get.to(() => PlaceScreen(ticket: ticket!));
    } else {
      // Xử lý lỗi ở đây (hiển thị thông báo lỗi hoặc xử lý khác)
      print('Failed to load tickets');
    }
  }

  void findActivePostElement() {
    activePostElement = widget.postResponse.postElements
        .firstWhere((postElement) => postElement.status == 'ACTIVE');
    // In ra post element có status là ACTIVE (nếu có)
    print('Active Post Element: $activePostElement');
  }


  // void deletePost() {
  //   // Logic xử lý xóa bài viết ở đây
  //   print('Post Deleted');
  // }


  // void deletePost() async {
  //   // Đảm bảo bạn có postId từ PostElement hoặc PostResponse
  //   String postId = widget.postElement.id.toString(); // hoặc widget.postResponse.postId tùy thuộc vào cấu trúc của bạn
  //
  //   // Gọi API để thay đổi trạng thái của bài viết thành CLOSED
  //   final response = await http.put(
  //     Uri.parse('https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Post/manager-action?postId=$postId&status=CLOSED'),
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // API gọi thành công, bạn có thể cập nhật trạng thái UI hoặc thông báo cho người dùng
  //     print("Post status updated to CLOSED");
  //
  //     // Cập nhật lại widget UI nếu cần thiết (ví dụ: gọi setState để thay đổi giao diện)
  //     // setState(() {
  //     //   // Nếu bạn muốn cập nhật trạng thái bài viết sau khi xóa
  //     //   widget.postElement.status = 'CLOSED';
  //     // });
  //
  //     // Hiển thị thông báo cho người dùng (ví dụ: sử dụng Flutter Toast, hoặc AlertDialog)
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Post has been closed successfully.')),
  //     );
  //   } else {
  //     // Xử lý khi API gọi thất bại
  //     print('Failed to close the post. Error: ${response.statusCode}');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to close the post.')),
  //     );
  //   }
  // }

  void deletePost() async {
    String postId = widget.postElement.id.toString(); // Hoặc widget.postResponse.postId tùy thuộc vào cấu trúc của bạn

    final response = await http.put(
      Uri.parse('https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Post/manager-action?postId=$postId&status=CLOSED'),
      headers: {'Content-Type': 'application/json',
        "Authorization": 'Bearer ${UserManager().token}'
      },
    );

    if (response.statusCode == 200) {
      print("Post status updated to CLOSED");

      // Quay lại trang trước và làm mới dữ liệu ở đó
      Navigator.pop(context, true); // Trả về giá trị true để thông báo trang trước cần làm mới

    } else {
      print('Failed to close the post. Error: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to close the post.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: fetchTickets,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [TShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? TColors.darkGrey : TColors.white,
        ),
        child: Column(
          children: [
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: dark ? TColors.dark : TColors.light,
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), // Adjust as needed for rounded corners
                      child: Image.network(
                        widget.postResponse.imageUrls.isNotEmpty
                            ? widget.postResponse.imageUrls[0]
                            : 'https://i.pinimg.com/736x/d7/07/84/d70784b885602af2877dd7a7230bba2c.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    child: TRoundedContainer(
                      radius: TSizes.sm,
                      backgroundColor: TColors.secondary.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.sm, vertical: TSizes.xs),
                      child: Text('${widget.postResponse.quantity} ticket',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .apply(color: TColors.black)),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: deletePost,
                      icon: const Icon(Iconsax.card_remove, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TProductTitleText(title: widget.postElement.title, smallSize: true),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Row(
                    children: [
                      Text(widget.postResponse.categoryName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(width: TSizes.xs),
                      const Icon(Iconsax.verify5,
                          color: TColors.primary, size: TSizes.iconXs),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: TSizes.sm),
                  child: TProductPriceText(price: '${widget.postResponse.price}'),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: TColors.dark,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(TSizes.cardRadiusMd),
                      bottomRight: Radius.circular(TSizes.productImageRadius),
                    ),
                  ),
                  child: const SizedBox(
                    width: TSizes.iconLg * 1.2,
                    height: TSizes.iconLg * 1.2,
                    child: Center(child: Icon(Iconsax.add, color: TColors.white)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
