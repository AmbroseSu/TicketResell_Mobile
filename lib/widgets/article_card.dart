import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class ArticleCard extends StatelessWidget {
  final AssetImage imageUrl;
  final String title;
  final String author;
  final String date;
  final String url;

  const ArticleCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.date,
    required this.url,
  }) : super(key: key);

  void _launchURL(BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchURL(context),
      child: Container(
        width: 250, // Chiều rộng của mỗi bài viết
        margin: const EdgeInsets.only(right: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white, // Set the background color to white
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image(image: imageUrl, fit: BoxFit.cover, height: 120, width: double.infinity),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  author,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}