import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ticket_resell/api/response/ticket.dart';
import 'package:ticket_resell/navigation_menu.dart';
import 'package:ticket_resell/notification/notification_screen.dart';
import 'package:ticket_resell/screens/order/order.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_resell/screens/product_detail/all_post.dart';
import 'package:ticket_resell/screens/product_detail/place_screen.dart';
import 'package:ticket_resell/screens/search/search_result.dart';
import '../api/response/post.dart';
import '../styles&text&sizes/image_strings.dart';
import '../styles&text&sizes/sizes.dart';
import '../widgets/article_card.dart';
import '../widgets/popular_item.dart';
import '../widgets/promo_slider.dart';
import '../widgets/recommend_item.dart';
import '../widgets/section_heading.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _categories = [];
  Ticket? ticket = Ticket(ticketId: 0, ticketName: '', price: 0, quantity: 0, expirationDate: '', venue: '', status: '', isDeleted: true, categoryId: 1, categoryName: '', postId: 2, postTitle: '', postDescription: '', currentPostStatus: '', createdDate: '', userId: 2, email: '', imageUrls: [], feedbackDTOs: []);
  List<PostResponse> posts = [];
  List<PostResponse> postCategories = [];
  late TextEditingController _searchController;
  bool _isLoading = false;
  bool _isLoadingCategories = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController();
    fetchCategories();
    fetchTickets();
    //fetchRecommendedPosts();
    NotificationScreen();
    NavigationMenu();
  }



  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/TicketCategory/categories?page=1&limit=100'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final List categories = data['content'];
        setState(() {
          _categories = categories.map((category) => {
            'id': category['id'],
            'name': category['name']
          }).toList();
          _tabController = TabController(length: _categories.length, vsync: this);
          _isLoadingCategories = false;
          // if (_categories.isNotEmpty) {
          //   fetchTicketByCategories(_categories[3]['id']);
          // }else{
            _tabController.addListener(() {
              if (_tabController.indexIsChanging == false) {
                final categoryId = _categories[_tabController.index]['id'];
                fetchTicketByCategories(categoryId);
              }
            });
          //}

        });

        // // Gọi API để lấy tour cho mỗi category
        // for (var category in _categories) {
        //   await fetchToursByCategory(category['id'].toString());
        // }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print("Error fetching categories: $e");
      setState(() => _isLoadingCategories = false);
    }
  }

  Future<void> fetchTickets() async {
    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Post/get-lists?status=ACTIVE&page=1&limit=100'));
    print(response.statusCode);
    var responseData = jsonDecode(response.body);
    if (responseData['statusCode'] == 200) {
      final data = json.decode(response.body);
      setState(() {
        posts = (data['content'] as List)
            .map((json) => PostResponse.fromJson(json))
            .toList();
      });
      print(posts);
    } else {
      // Xử lý lỗi ở đây (hiển thị thông báo lỗi hoặc xử lý khác)
      print('Failed to load tickets');
    }
  }

  Future<void> fetchTicketByCategories(int categoryId) async {
    setState(() => _isLoading = true); // Bắt đầu load

    try {
      final response = await http.get(Uri.parse(
          'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Post/get-by-category?status=ACTIVE&id=$categoryId&page=1&limit=1000'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          postCategories = (data['content'] as List)
              .map((json) => PostResponse.fromJson(json))
              .toList();
          _isLoading = false; // Dừng load sau khi có dữ liệu
        });
      } else {
        print('Failed to load tickets by category');
        setState(() => _isLoading = false); // Dừng load nếu thất bại
      }
    } catch (e) {
      print("Error fetching tickets by category: $e");
      setState(() => _isLoading = false); // Dừng load nếu có lỗi
    }
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
  List<Map<String, dynamic>> _recommendedPosts = [];

  Future<void> fetchRecommendedPosts() async {
    try {
      final response = await http.get(
        Uri.parse('https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Post/get-lists?status=ACTIVE&page=1&limit=100'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final List posts = data['content'];

        setState(() {
          _recommendedPosts = posts.take(8).map((post) =>
          {
            'ticketId': post['ticketId'],
            'ticketName': post['ticketName'],
            'price': post['price'],
            'expirationDate': post['expirationDate'],
            'venue': post['venue'],
            'imageUrls': post['imageTicketDTOs']?.map((img) => img['imageUrl']).toList() ?? []
          }
          ).toList();
        });
      } else {
        throw Exception('Failed to load recommended posts');
      }
    } catch (e) {
      print("Error fetching recommended posts: $e");
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }


@override
Widget build(BuildContext context) {
  return SafeArea(
    child: WillPopScope(
      onWillPop: () async {
        return false; // Chặn thao tác back
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoadingCategories || _categories.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Explore",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Ticket Resell",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 21, right: 14),
                    child: IconButton(
                      icon: Icon(
                        CupertinoIcons.shopping_cart, // Biểu tượng giỏ hàng
                        color: Colors.black87,
                        size: 30,
                      ),
                      onPressed: () {
                        // Xử lý sự kiện khi nhấn vào giỏ hàng
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            //   child: Container(
            //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            //     decoration: BoxDecoration(
            //         color: Color(0xFFF3F8FE),
            //         borderRadius: BorderRadius.circular(24)),
            //     child: TextField(
            //       decoration: InputDecoration(
            //           hintText: "Find your tickets in here",
            //           border: InputBorder.none,
            //           prefixIcon: Icon(Icons.search)),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: Color(0xFFF3F8FE),
                    borderRadius: BorderRadius.circular(24)),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Find your tickets in here",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (value) {
                    // Khi nhấn Enter, chuyển đến trang kết quả tìm kiếm
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchAllResult(query: value),
                      ),
                    );
                  },
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.blueAccent,
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Color(0xFFB8B8B8),
              labelStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700, fontSize: 16),
              unselectedLabelStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, fontSize: 16),
              tabs: _categories
                  .map((category) => Tab(text: category['name']))
                  .toList(),
            ),
            SizedBox(height: 20),
            Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _categories.map((category) {
                    return buildTabContent(category['name']);
                  }).toList(),
                ))
          ],
        ),
      ),
    ),
  );
}

Widget buildTabContent(String categoryName) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: TPromoSlider(
              banners: [TImages.concert1, TImages.concert2, TImages.concert3],
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Popular",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xFF232323),
                ),
              ),
              TextButton(
                child: Text(
                  "See all",
                  style: GoogleFonts.robotoCondensed(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
                onPressed: () {

                },
              ),
            ],
          ),
          SizedBox(height: 12),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: [
          //       PopularItem(postResponse: postCategories,),
          //       SizedBox(width: 16),
          //       PopularItem(postResponse: postCategories,)
          //     ],
          //   ),
          // ),

          _isLoading
              ? Center(child: CircularProgressIndicator())
              : postCategories.isEmpty
              ? Center(child: Text("No posts available"))
              : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: postCategories.take(8).map((postCategory) {
                return Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: PopularItem(postResponse: postCategory),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All Posts",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xFF232323),
                ),
              ),
              TextButton(
                child: Text("See all",  style: GoogleFonts.robotoCondensed(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.blueAccent,),

                ), onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllPost(),
                  ),
                );
              },
              ),
            ],
          ),
          SizedBox(height: 16),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: [
          //       RecommendCard(title: "Con Cam", duration: "1h20", deal: "Hot Deal", image: TImages.concam, onTap: () {Get.to(() => PlaceScreen(ticket: ticket!));},),
          //       SizedBox(width: 16),
          //       RecommendCard(title: "Transformer", duration: "1h30", deal: "New Deal", image: TImages.transformer, onTap: () {Get.to(() => PlaceScreen(ticket: ticket!));}),
          //       SizedBox(width: 16),
          //       RecommendCard(title: "Báo Thủ", duration: "1h22", deal: "Hot Deal", image: TImages.bao_thu, onTap: () {Get.to(() => PlaceScreen(ticket: ticket!));})
          //     ],
          //   ),
          // ),

          posts.isEmpty
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: posts.take(8).map((post) {
                // Kiểm tra nếu post có dữ liệu
                return Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: RecommendCard(postResponse: post),
                );
              }).toList(),
            ),
          ),


          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Dynamically load recommended items based on category
              ],
            ),
          ),
          SizedBox(height: 50),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     vertical: TSizes.defaultSpace / 2,
          //   ),
          //   child: Column(
          //     children: [
          //       TSectionHeading(
          //         title: 'Article',
          //         showActionButton: true,
          //         textColor: Colors.black,
          //         onPressed: () {},
          //       ),
          //       const SizedBox(height: TSizes.spaceBtwItems),
          //       SizedBox(
          //         height: 250,
          //         child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           itemCount: 2,
          //           itemBuilder: (context, index) {
          //             return const ArticleCard(
          //               imageUrl: AssetImage(TImages.canada),
          //               title: 'The essential guide to visiting Canada',
          //               author: 'Alexander Wooley',
          //               date: '5 June 2024',
          //               url:
          //               'https://www.nationalgeographic.com/travel/article/essential-guide-canada',
          //             );
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    ),
  );
}
}