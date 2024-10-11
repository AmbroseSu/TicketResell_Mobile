import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/screens/chat/chat_screen.dart';
import 'package:ticket_resell/screens/product_detail/product_reviews.dart';
import '../../styles&text&sizes/image_strings.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/gallery_slider.dart';
import '../../widgets/section_heading.dart';
import '../checkout/checkout.dart';

class PlaceScreen extends StatelessWidget {
  const PlaceScreen({super.key});

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
                      height: MediaQuery.of(context).size.height /2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                            image: AssetImage(TImages.conan),
                            fit: BoxFit.cover,
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(15),
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
                          )
                        ],
                      ),
                    ),
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
                        )),
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
                        "Conan Movie",
                        style: GoogleFonts.getFont(
                          "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                          color: Color(0xFF232323),
                        ),
                      ),
                      Text(
                        "Deal Price",
                        style: GoogleFonts.getFont(
                          "Roboto Condensed",
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.blueAccent,
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
                  "Trong khi đến Hakodate tham gia một giải kiếm đạo, Conan và Heiji đụng độ siêu trộm Kaito Kid - khi hắn đang nhắm tới một thanh kiếm Nhật được cất giấu trong nhà kho của một gia đình tài phiệt. Thi thể một tay buôn vũ khí khét tiếng được phát hiện với vết chém hình chữ thập, và trùng hợp thay, kho báu mà gã truy lùng dường như cũng có liên quan mật thiết đến thanh kiếm cổ mà Kid đang nhắm tới. ",
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
                  child: TGallerySlider(banners: [TImages.conan_1, TImages.conan_2, TImages.conan_3],),
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
                    const TSectionHeading(title: 'Reviews (345)', showActionButton: false),
                    IconButton(onPressed: () => Get.to(() => const ProductReviewsScreen()), icon: const Icon(Iconsax.arrow_right_3))
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
                onTap: () => Get.to(() => const ChatScreen()),
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
