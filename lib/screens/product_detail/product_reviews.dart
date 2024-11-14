import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/response/ticket.dart';
import 'package:ticket_resell/styles&text&sizes/image_strings.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/appbar.dart';
import 'package:http/http.dart' as http;
import '../../widgets/rating_progress_indicator.dart';
import '../../widgets/t_circular_icon.dart';

class ProductReviewsScreen extends StatefulWidget {
  final Ticket ticket;
  const ProductReviewsScreen({super.key, required this.ticket});

  @override
  _ProductReviewsScreenState createState() => _ProductReviewsScreenState();
}



class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  String? imageUser;
  String? fullname;
  String? point;
  List<Map<String, dynamic>> feedbacks = [];

  @override
  void initState() {
    super.initState();
    getUserbyId();
    getFeedbacks();
  }

  Future<void> getUserbyId() async {
    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/User/get-user-by-id?id=${widget.ticket.userId}'),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        }
    );
    var responseData = jsonDecode(response.body);

    if (responseData['statusCode'] == 201) {
      final data = responseData['content'];
      setState(() {
        imageUser = data['image'];
        fullname = data['fullname'];
        point = data['point'].toString();
      });
    } else {
      print('Failed to load user data');
    }
  }



  Future<void> getFeedbacks() async {
    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Feedback/get-by-ticketid?ticketId=${widget.ticket.ticketId}&page=1&limit=10'),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        }
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseData['statusCode'] == 200) {
        final feedbackList = responseData['content'] as List;
        setState(() {
          feedbacks = feedbackList.map((e) => {
            'rating': e['rating'],
            'context': e['context']?.toString(),
            'fullName': e['fullName']?.toString(),
            'createdDate': formatDate(e['createdDate']),
          }).toList();
        });
      } else {
        print('Failed to load feedbacks');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }


  Future<void> addFeedback(double rating, String feedbackText) async {
    print('Rating: $rating');
    print('Feedback Text: $feedbackText');
    print('Ticket ID: ${widget.ticket.ticketId}');
    print('User ID: ${UserManager().id}');

    int intRating = rating.toInt();

    final Map<String, dynamic> requestBody = {
      'rating': intRating,
      'context': feedbackText.trim(),
      'ticketId': widget.ticket.ticketId,
      'userId': UserManager().id,
    };

    print('Request Body: ${jsonEncode(requestBody)}');

    final response = await http.post(
      Uri.parse('https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Feedback/new'),
      headers: {'Content-Type': 'application/json',
        "Authorization": 'Bearer ${UserManager().token}'

      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      if (responseData['statusCode'] == 201) {
        print('Feedback added successfully');
        getFeedbacks();
      } else {
        print('Failed to add feedback, status code: ${responseData['statusCode']}');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void _showFeedbackDialog(BuildContext context) {
    double rating = 0;
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Leave a Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  hintText: 'Write your feedback here...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                print('Rating: $rating');
                print('Feedback: ${feedbackController.text}');
                addFeedback(rating, feedbackController.text);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TAppBar(
        title: Text('Reviews & Ratings', style: Theme.of(context).textTheme.headlineMedium),
        showBackArrow: true,
        actions: [
          TCircularIcon(
            icon: Iconsax.add,
            onPressed: () => _showFeedbackDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TSizes.spaceBtwItems),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: ClipOval(
                      child: imageUser != null && imageUser!.isNotEmpty
                          ? Image.network(
                        imageUser!,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        'assets/images/default_image.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${fullname ?? 'N/A'}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Point: ${point ?? 'N/A'}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Hiển thị danh sách feedbacks
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: feedbacks.length,
                itemBuilder: (context, index) {
                  var feedback = feedbacks[index];
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(backgroundImage: AssetImage(TImages.user)),
                              const SizedBox(width: TSizes.spaceBtwItems),
                              Text(feedback['fullName'], style: Theme.of(context).textTheme.titleLarge),
                            ],
                          ),
                          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      Row(
                        children: [
                          TRatingBarIndicator(rating: feedback['rating'].toDouble()),
                          const SizedBox(width: TSizes.spaceBtwItems),
                          Text(feedback['createdDate'], style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      ReadMoreText(
                        feedback['context'].toString(),
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        trimExpandedText: ' show less',
                        trimCollapsedText: ' show more',
                        moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
