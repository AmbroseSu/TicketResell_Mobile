import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RecommendCard extends StatelessWidget {
  final String title;
  final String duration;
  final String deal;
  final String image;
  final VoidCallback? onTap;

  const RecommendCard(
      {super.key,
      required this.title,
      required this.duration,
      required this.deal,
      required this.image,
        this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 175,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFF4F4F4)),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x2B97A0B2),
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF3A544F),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    child: Text(
                      duration,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xFF232323)),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  SvgPicture.asset("assets/vectors/shape_x2.svg",
                  height: 12,
                  width: 12,
                  ),
                  SizedBox(width: 5.5),
                  Text(
                    deal,
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF3A544F)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
