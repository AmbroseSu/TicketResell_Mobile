import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/response/ticket.dart';
import 'package:ticket_resell/models/user_profile.dart';
import 'package:ticket_resell/screens/chat/chat_screen.dart';
import 'package:ticket_resell/screens/product_detail/product_reviews.dart';
import 'package:ticket_resell/services/database_service.dart';
import '../../styles&text&sizes/image_strings.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/gallery_slider.dart';
import '../../widgets/section_heading.dart';
import '../checkout/checkout.dart';

class PlaceScreen extends StatefulWidget {
  final Ticket ticket;

  const PlaceScreen({Key? key, required this.ticket}) : super(key: key);

  @override
  _PlaceScreenState createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  final List<String> imageUrls = [
    'https://i.pinimg.com/736x/97/cf/7e/97cf7e8590acb5361a34ff7d4ee8f8e2.jpg',
    'https://i.pinimg.com/736x/91/bf/74/91bf74698893832860c8e0246193371c.jpg',
    'https://i.pinimg.com/564x/44/39/a8/4439a886cd0531c666108771348e6b49.jpg',
  ];

  int _currentIndex = 0;

  final GetIt _getIt = GetIt.instance;
  UserProfile? otherUser;
  late DatabaseService _databaseService;
  Ticket emptyTicket = Ticket(id: 0, ticketName: "", price: 0, quantity: 0, expirationDate: "", venue: "", status: 0, categoryName: "", postId: 0, postTitle: "", postDescription: "", createdDate: "", postStatus: false, userId: 0, email: "");

  @override
  void initState() {
    super.initState();
    _databaseService = _getIt.get<DatabaseService>();
    fetchOtherUserProfile();
  }

  Future<void> fetchOtherUserProfile() async {
    final userStream = _databaseService.getUserProfile(widget.ticket.email);

    final userSnapshot = await userStream.first;

    if (userSnapshot.docs.isNotEmpty) {
      setState(() {
        otherUser = userSnapshot.docs.first.data();
        print(
            "000000000000000000000000000000000000000000000000000000000000000000");
        print(widget.ticket.email);
        print(otherUser!.uid); // Assigning the first user profile to otherUser
        print(otherUser!.name); // Assigning the first user profile to otherUser
        print(
            otherUser!.pfpURL); // Assigning the first user profile to otherUser
      });
    } else {
      print(
          "111111111111111111111111111111111111111111111111111111111111111111111111111");
      // Handle the case where the user is not found
      print("User not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      child: PageView.builder(
                        itemCount: imageUrls.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index; // Cập nhật chỉ số trang
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                image: NetworkImage(imageUrls[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Nút quay lại
                    Positioned(
                      top: 15,
                      left: 15,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Color(0xFFB8B8B8),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    // Nút yêu thích
                    Positioned(
                      bottom: -20,
                      right: 20,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 30,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    // Chỉ báo ảnh
                    Positioned(
                      bottom: 20, // Đặt chỉ báo ở vị trí dưới cùng
                      left: MediaQuery.of(context).size.width / 2 - 30, // Đặt giữa
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(imageUrls.length, (index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? Colors.blue // Màu của chấm hiện tại
                                  : Colors.grey, // Màu của chấm không hiện tại
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.ticket.ticketName,
                        style: GoogleFonts.getFont(
                          "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                          color: Color(0xFF232323),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Điều hướng đến ChatScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                deal: true,
                                ticket: widget.ticket,
                                chatUser: otherUser!,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Deal Price",
                          style: GoogleFonts.getFont(
                            "Roboto Condensed",
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 5),
                    Text(
                      "4.5 (345 Reviews)",
                      style: GoogleFonts.getFont(
                        "Roboto Condensed",
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Color(0xFF606060),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, color: Color(0xFF9B9B9B)),
                    SizedBox(width: 5),
                    Text(
                      "Create Date: 12/09/2024",
                      style: GoogleFonts.getFont(
                        "Roboto Condensed",
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Color(0xFF606060),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  widget.ticket.postDescription,
                  style: GoogleFonts.getFont(
                    "Roboto Condensed",
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color(0xFF9B9B9B),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 29),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Facilities",
                        style: GoogleFonts.getFont(
                          "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xFF232323),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildCard(
                              assetPath: 'assets/vectors/vector_2_x2.svg',
                              text: "1 Heater"),
                          _buildCard(
                              assetPath: 'assets/vectors/vector_1_x2.svg',
                              text: "1 Dinner"),
                          _buildCard(
                              assetPath: 'assets/vectors/vector_x2.svg',
                              text: "1 Tub"),
                          _buildCard(
                              assetPath: 'assets/vectors/vector_3_x2.svg',
                              text: "Pool"),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25),

                /// -- Galleries
                Text(
                  "Galleries",
                  style: GoogleFonts.getFont(
                    "Montserrat",
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF232323),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: TGallerySlider(
                    banners: [
                      TImages.conan_1,
                      TImages.conan_2,
                      TImages.conan_3
                    ],
                  ),
                ),
                // SizedBox(height: 25),

                /// Best time to visit
                SizedBox(height: 15),
                Text(
                  "Best time to visit",
                  style: GoogleFonts.getFont(
                    "Montserrat",
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF232323),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Thám Tử Lừng Danh Conan: Tàu Ngầm Sắt Màu Đen là phần phim đang đạt doanh thu ấn tượng của loạt phim về cậu bé thám tử. Lấy bối cảnh tại Pacific Buoy - một trụ sở hàng hải của Interpol có nhiệm vụ kết nối các camera an ninh trên toàn thế giới. Theo lời mời của Sonoko, nhóm Conan đến Hachijojima để xem cá voi. Tại đây, Conan nhận được thông tin về một nhân viên Europol bị ám sát. Cùng với đó, tính mạng Haibara bị đe dọa, phải chăng thân phận của cô đã bị bại lộ trước Gin - nhân vật nguy hiểm hàng đầu của tổ chức áo đen…  Tàu Ngầm Sắt Màu Đen đang đứng đầu doanh thu phòng vé tại Nhật Bản, phá vỡ hàng loạt kỉ lục của những người anh em trước. Phim đạt doanh thu hơn 3 tỷ yên chỉ trong cuối tuần mở màn đầu tiên.",
                  style: GoogleFonts.getFont(
                    "Roboto Condensed",
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color(0xFF9B9B9B),
                  ),
                ),

                /// -- Reviews
                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TSectionHeading(
                        title: 'Reviews (345)', showActionButton: false),
                    IconButton(
                        onPressed: () =>
                            Get.to(() => const ProductReviewsScreen()),
                        icon: const Icon(Iconsax.arrow_right_3))
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Price",
                        style: GoogleFonts.getFont(
                          "Roboto Condensed",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF232323),
                        ),
                      ),
                    ),
                    Text(
                      "\$199",
                      style: GoogleFonts.getFont(
                        "Montserrat",
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Color(0xE2FF5252),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(() => ChatScreen(
                  deal: false,
                  ticket: widget.ticket,
                      chatUser: otherUser!,
                    )),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueAccent,
                  ),
                  child: Center(
                    child: Text(
                      "Book Now",
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
      ),
    );
  }

  Widget _buildCard({required String assetPath, required String text}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.fromLTRB(0, 14, 0, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0x0D176FF2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8),
              width: 30,
              height: 28,
              child: SvgPicture.asset(assetPath),
            ),
            Padding(
              padding: EdgeInsets.only(right: 1.3),
              child: Text(
                text,
                style: GoogleFonts.getFont(
                  "Roboto Condensed",
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.black26,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
