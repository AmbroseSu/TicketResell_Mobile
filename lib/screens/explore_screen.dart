import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticket_resell/screens/product_detail/place_screen.dart';

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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
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
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Ticket Resell",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.location_solid,
                        color: Colors.blueAccent,
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "District 9, \nHo Chi Minh",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xFF606060),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFF3F8FE),
                  borderRadius: BorderRadius.circular(24)
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Find your tickets in here",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search)
                  ),
                ),
              ),
            ),

            TabBar(
                controller: _tabController,
              indicatorColor: Colors.blueAccent,
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Color(0xFFB8B8B8),
              labelStyle: GoogleFonts.robotoCondensed(
                fontWeight: FontWeight.w700,
                fontSize: 16
              ),
              unselectedLabelStyle: GoogleFonts.robotoCondensed(
                  fontWeight: FontWeight.w400,
                  fontSize: 16
              ),
              tabs: [
                Tab(text: "Movies"),
                Tab(text: "Vouchers"),
                Tab(text: "Events"),
                Tab(text: "Live Concert"),
              ],
            ),
            SizedBox(height: 20),
            Expanded(child: TabBarView(
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
    );
  }
  Widget buildTabContent(String tab){
    return Padding(padding: EdgeInsets.symmetric(horizontal: 20),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: TPromoSlider(banners: [TImages.concert1, TImages.concert2, TImages.concert3],),
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
                   )), onPressed: () {  },
                
              ),
            ],
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                PopularItem(title: "Conan", rating: "4.1", image: TImages.conan),
                SizedBox(width: 16),
                PopularItem(title: "Exhuma", rating: "4.9", image: TImages.exhuma)
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
                RecommendCard(title: "Con Cam", duration: "1h20", deal: "Hot Deal", image: TImages.concam, onTap: () {Get.to(() => const PlaceScreen());},),
                SizedBox(width: 16),
                RecommendCard(title: "Transformer", duration: "1h30", deal: "New Deal", image: TImages.transformer, onTap: () {Get.to(() => const PlaceScreen());}),
                SizedBox(width: 16),
                RecommendCard(title: "Báo Thủ", duration: "1h22", deal: "Hot Deal", image: TImages.bao_thu, onTap: () {Get.to(() => const PlaceScreen());})
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
                        url: 'https://www.nationalgeographic.com/travel/article/essential-guide-canada',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),);
  }
}
