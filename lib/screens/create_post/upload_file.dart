// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
//
// class UploadFile extends StatefulWidget {
//   const UploadFile({super.key});
//
//   @override
//   _UploadFileState createState() => _UploadFileState();
// }
//
// class _UploadFileState extends State<UploadFile> {
//   PlatformFile? pickedFile;
//   UploadTask? uploadTask;
//
//   Future selectFile() async {
//     final result = await FilePicker.platform.pickFiles();
//     if (result == null) return;
//
//     setState(() {
//       pickedFile = result.files.first;
//     });
//   }
//
//   Future uploadFile() async {
//     final path = 'files/${pickedFile!.name}';
//     final file = File(pickedFile!.path!);
//
//     final ref = FirebaseStorage.instance.ref().child(path);
//     // ref.putFile(file);
//
//     uploadTask = ref.putFile(file);
//
//     final snapshot = await uploadTask!.whenComplete(() {});
//     final urlDownload = await snapshot.ref.getDownloadURL();
//     print('Download Link: $urlDownload');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         elevation: 0,
//       ),
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (pickedFile != null)
//               Expanded(
//                   child: Container(
//                     color: Colors.blue[100],
//                     child: Center(
//                       child: Image.file(
//                         File(pickedFile!.path!),
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   )),
//             ElevatedButton(
//                 child: const Text("Select File"), onPressed: selectFile),
//             const SizedBox(height: 32),
//             ElevatedButton(
//                 child: const Text("Upload File"), onPressed: uploadFile),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticket_resell/screens/checkout/checkout.dart';
import '../../styles&text&sizes/spacing_styles.dart';
//
// class UploadFile extends StatefulWidget {
//   const UploadFile({super.key});
//
//   @override
//   _UploadFileState createState() => _UploadFileState();
// }
//
// class _UploadFileState extends State<UploadFile> {
//   List<PlatformFile>? pickedFiles; // Lưu trữ danh sách file
//   List<UploadTask>? uploadTasks; // Lưu trữ các tác vụ upload
//
//   Future selectFiles() async {
//     final result = await FilePicker.platform
//         .pickFiles(allowMultiple: true); // Cho phép chọn nhiều file
//     if (result == null) return;
//
//     setState(() {
//       pickedFiles = result.files; // Lưu danh sách file đã chọn
//     });
//   }
//
//   Future uploadFiles() async {
//     if (pickedFiles == null) return;
//
//     uploadTasks = [];
//     for (var pickedFile in pickedFiles!) {
//       final path = 'files/${pickedFile.name}';
//       final file = File(pickedFile.path!);
//       final ref = FirebaseStorage.instance.ref().child(path);
//
//       final uploadTask = ref.putFile(file);
//       uploadTasks!.add(uploadTask);
//
//       final snapshot = await uploadTask.whenComplete(() {});
//       final urlDownload = await snapshot.ref.getDownloadURL();
//       print('Download Link: $urlDownload');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         elevation: 0,
//       ),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: TSpacingStyle.paddingWithAppBarHeight,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (pickedFiles != null)
//                 // Expanded(
//                 //     child: ListView.builder(
//                 //       itemCount: pickedFiles!.length,
//                 //       itemBuilder: (context, index) {
//                 //         final pickedFile = pickedFiles![index];
//                 //         return Container(
//                 //           margin: const EdgeInsets.symmetric(vertical: 10),
//                 //           color: Colors.blue[100],
//                 //           child: ListTile(
//                 //             title: Text(pickedFile.name),
//                 //             subtitle: pickedFile.path != null
//                 //                 ? Image.file(
//                 //               File(pickedFile.path!),
//                 //               height: 100,
//                 //               fit: BoxFit.cover,
//                 //             )
//                 //                 : const SizedBox.shrink(),
//                 //           ),
//                 //         );
//                 //       },
//                 //     )),
//
//                 Expanded(
//                   child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3, // Số ô trên mỗi hàng
//                       crossAxisSpacing:
//                           10, // Khoảng cách giữa các ô theo chiều ngang
//                       mainAxisSpacing:
//                           10, // Khoảng cách giữa các ô theo chiều dọc
//                       childAspectRatio:
//                           1, // Tỷ lệ giữa chiều rộng và chiều cao của ô
//                     ),
//                     itemCount: pickedFiles!.length,
//                     itemBuilder: (context, index) {
//                       final pickedFile = pickedFiles![index];
//                       return Container(
//                         color: Colors.blue[100],
//                         child: Column(
//                           children: [
//                             Expanded(
//                               child: pickedFile.path != null
//                                   ? Image.file(
//                                       File(pickedFile.path!),
//                                       fit: BoxFit.cover,
//                                     )
//                                   : const SizedBox.shrink(),
//                             ),
//                             Text(
//                               pickedFile.name,
//                               overflow:
//                                   TextOverflow.ellipsis, // Giới hạn độ dài text
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//               /// Select Files
//               GestureDetector(
//                 onTap: () {
//                   selectFiles();
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     color: Colors.white,
//                     border: Border.all(color: Color(0xFFC7C5CC), width: 2), // Add border here
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Select Files',
//                       style: GoogleFonts.getFont(
//                         "Roboto Condensed",
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 32),
//               /// Upload Files
//               GestureDetector(
//                 onTap: () {
//                   uploadFiles();
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     color: Colors.white,
//                     border: Border.all(color: Color(0xFFC7C5CC), width: 2), // Add border here
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Upload Files',
//                       style: GoogleFonts.getFont(
//                         "Roboto Condensed",
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 32),
//
//               /// Checkout Button
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => CheckoutScreen()));
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     color: Colors.blueAccent,
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Create',
//                       style: GoogleFonts.getFont(
//                         "Roboto Condensed",
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 32),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../styles&text&sizes/spacing_styles.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // Thêm thư viện HTTP để gửi POST request
import 'package:ticket_resell/screens/checkout/checkout.dart';
import 'package:ticket_resell/styles&text&sizes/spacing_styles.dart';
import 'dart:convert';


class UploadFile extends StatefulWidget {
  final int ticketId; // Thêm ticketId để gửi lên API
  const UploadFile({super.key, required this.ticketId});

  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  List<PlatformFile>? pickedFiles;
  List<UploadTask>? uploadTasks;
  bool isUploading = false; // Biến để kiểm tra trạng thái upload

  // Hàm chọn file
  Future selectFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;

    setState(() {
      pickedFiles = result.files;
    });
  }

  // Hàm tải file lên Firebase Storage và gọi API
  Future uploadFiles() async {
    if (pickedFiles == null || pickedFiles!.isEmpty) return;

    setState(() {
      isUploading = true; // Bắt đầu quá trình upload
    });

    uploadTasks = [];
    List<String> imageUrls = []; // Lưu trữ các URL ảnh sau khi upload

    try {
      for (var pickedFile in pickedFiles!) {
        final path = 'files/${pickedFile.name}';
        final file = File(pickedFile.path!);
        final ref = FirebaseStorage.instance.ref().child(path);

        final uploadTask = ref.putFile(file);
        uploadTasks!.add(uploadTask);

        final snapshot = await uploadTask.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        imageUrls.add(urlDownload);
        print('Download Link: $urlDownload');
      }

      // Sau khi tải xong, gọi API để lưu URL ảnh vào
      await uploadToApi(imageUrls);
    } catch (e) {
      print("Error during file upload: $e");
    } finally {
      setState(() {
        isUploading = false; // Kết thúc quá trình upload
      });
    }
  }

  // Hàm gửi các URL hình ảnh đến API
  Future uploadToApi(List<String> imageUrls) async {
    try {
      final url = Uri.parse(
          'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/images?ticketId=${widget.ticketId}');

      // Update the field name to 'imgList' instead of 'imageUrls'
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'imgList': imageUrls}),  // Using 'imgList' instead of 'imageUrls'
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');  // Log full response body for insights

      if (response.statusCode == 200) {
        print("Image URLs uploaded successfully!");
      } else {
        print("Failed to upload images. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading images to API: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          'Upload Files',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (pickedFiles != null && pickedFiles!.isNotEmpty)
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: pickedFiles!.length,
                    itemBuilder: (context, index) {
                      final pickedFile = pickedFiles![index];
                      return Container(
                        color: Colors.blue[100],
                        child: Column(
                          children: [
                            Expanded(
                              child: pickedFile.path != null
                                  ? Image.file(
                                File(pickedFile.path!),
                                fit: BoxFit.cover,
                              )
                                  : const SizedBox.shrink(),
                            ),
                            Text(
                              pickedFile.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              GestureDetector(
                onTap: () {
                  selectFiles();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFC7C5CC), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      'Select Files',
                      style: GoogleFonts.getFont(
                        "Roboto Condensed",
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  uploadFiles();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFC7C5CC), width: 2),
                  ),
                  child: Center(
                    child: isUploading
                        ? CircularProgressIndicator() // Hiển thị loading khi đang upload
                        : Text(
                      'Upload Files',
                      style: GoogleFonts.getFont(
                        "Roboto Condensed",
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutScreen()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueAccent,
                  ),
                  child: Center(
                    child: Text(
                      'Create',
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
