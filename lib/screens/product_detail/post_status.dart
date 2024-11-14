import 'package:flutter/material.dart';
import 'package:ticket_resell/screens/product_detail/all_your_post_active.dart';
import 'package:ticket_resell/screens/product_detail/all_your_post_closed.dart';
import 'package:ticket_resell/screens/product_detail/all_your_post_pending.dart';
import '../../api/response/post.dart';
import '../../api/response/post_element.dart';

class PostStatusPage extends StatefulWidget {
  final PostResponse postResponse;

  const PostStatusPage({super.key, required this.postResponse});

  @override
  _PostStatusPageState createState() => _PostStatusPageState();
}

class _PostStatusPageState extends State<PostStatusPage> {
  final List<String> statuses = ['Pending', 'Active', 'Closed'];
  final List<IconData> icons = [Icons.access_time, Icons.check_circle, Icons.close];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.postResponse.postElements[0].id);
  }
  @override
  Widget build(BuildContext context) {
    // Trích xuất danh sách bài viết từ PostResponse
    List<PostElement> postElements = widget.postResponse.postElements;

    // Lọc các bài viết theo trạng thái
    List<PostElement> pendingPosts = postElements.where((post) => post.status == 'PENDING').toList();
    List<PostElement> activePosts = postElements.where((post) => post.status == 'ACTIVE').toList();
    List<PostElement> closedPosts = postElements.where((post) => post.status == 'CLOSED').toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Post Status', style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(statuses.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: GestureDetector(
                onTap: () {
                  // Điều hướng đến trang với các bài viết theo trạng thái đã chọn
                  if (statuses[index] == 'Active') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllYourPostActive(
                          postResponse: widget.postResponse,
                          postElements: activePosts,
                        ),
                      ),
                    );
                  } else if (statuses[index] == 'Pending') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllYourPostPending(
                          postResponse: widget.postResponse,
                          postElements: pendingPosts,
                        ),
                      ),
                    );
                  } else if (statuses[index] == 'Closed') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllYourPostClosed(
                          postResponse: widget.postResponse,
                          postElements: closedPosts,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 200,
                  height: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(icons[index]),
                          SizedBox(height: 5),
                          Text(
                            statuses[index],
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
