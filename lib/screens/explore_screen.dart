import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticket_resell/screens/product_detail/place_screen.dart';
import 'package:ticket_resell/screens/request_ticket/all_ticket_request_buy.dart';
import 'package:http/http.dart' as http;
import '../styles&text&sizes/image_strings.dart';
import '../styles&text&sizes/sizes.dart';
import '../widgets/article_card.dart';
import '../widgets/popular_item.dart';
import '../widgets/promo_slider.dart';
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _tabController = TabController(length: 4, vsync: this);
    fetchCategories();

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
          body:_tabController == null || _categories.isEmpty
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
                              builder: (context) =>
                                  AllTicketRequestBuyScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Color(0xFFF3F8FE),
                      borderRadius: BorderRadius.circular(24)),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Find your tickets in here",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search)),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Colors.blueAccent,
                labelColor: Colors.blueAccent,
                unselectedLabelColor: Color(0xFFB8B8B8),
                labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 16),
                unselectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w400, fontSize: 16),
                // tabs: [
                //   Tab(text: "Movies"),
                //   Tab(text: "Vouchers"),
                //   Tab(text: "Events"),
                //   Tab(text: "Live Concert"),
                // ],

                tabs: _categories.map((category) => Tab(text: category['name'])).toList(),
              ),
              SizedBox(height: 20),
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                children: [
                  buildTabContent("Location"),
                  buildTabContent("Hotels"),
                  buildTabContent("Food"),
                  buildTabContent("Adventure"),
                ],
              ))
            ],
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   backgroundColor: Colors.white,
          //   fixedColor: Color(0xFF55B97D),
          //   currentIndex: 0,
          //   unselectedItemColor: Colors.black38,
          //   items: [
          //     BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
          //     BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          //     BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
          //     BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget buildTabContent(String tab) {
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
                  child: Text("See all",
                      style: GoogleFonts.robotoCondensed(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.blueAccent,
                      )),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  PopularItem(
                      title: "Conan", rating: "4.1", image: TImages.conan),
                  SizedBox(width: 16),
                  PopularItem(
                      title: "Exhuma", rating: "4.9", image: TImages.exhuma)
                ],
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommended",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF232323),
                  ),
                ),
                Text(
                  "See all",
                  style: GoogleFonts.robotoCondensed(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  //RecommendCard(title: "Con Cam", duration: "1h20", deal: "Hot Deal", image: TImages.concam, onTap: () {Get.to(() => const PlaceScreen(ticket: ));},),
                  //SizedBox(width: 16),
                  //RecommendCard(title: "Transformer", duration: "1h30", deal: "New Deal", image: TImages.transformer, onTap: () {Get.to(() => const PlaceScreen(ticket: ticket));}),
                  //SizedBox(width: 16),
                  //RecommendCard(title: "Báo Thủ", duration: "1h22", deal: "Hot Deal", image: TImages.bao_thu, onTap: () {Get.to(() => const PlaceScreen(ticket: ticket));})
                ],
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TSizes.defaultSpace / 2,
              ),
              child: Column(
                children: [
                  TSectionHeading(
                    title: 'Article',
                    showActionButton: true,
                    textColor: Colors.black,
                    onPressed: () {},
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return const ArticleCard(
                          imageUrl: AssetImage(TImages.canada),
                          title: 'The essential guide to visiting Canada',
                          author: 'Alexander Wooley',
                          date: '5 June 2024',
                          url:
                              'https://www.nationalgeographic.com/travel/article/essential-guide-canada',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
