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

class UploadFile extends StatefulWidget {
  const UploadFile({super.key});

  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  List<PlatformFile>? pickedFiles; // Lưu trữ danh sách file
  List<UploadTask>? uploadTasks; // Lưu trữ các tác vụ upload

  Future selectFiles() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: true); // Cho phép chọn nhiều file
    if (result == null) return;

    setState(() {
      pickedFiles = result.files; // Lưu danh sách file đã chọn
    });
  }

  Future uploadFiles() async {
    if (pickedFiles == null) return;

    uploadTasks = [];
    for (var pickedFile in pickedFiles!) {
      final path = 'files/${pickedFile.name}';
      final file = File(pickedFile.path!);
      final ref = FirebaseStorage.instance.ref().child(path);

      final uploadTask = ref.putFile(file);
      uploadTasks!.add(uploadTask);

      final snapshot = await uploadTask.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      print('Download Link: $urlDownload');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: TSpacingStyle.paddingWithAppBarHeight,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (pickedFiles != null)
                // Expanded(
                //     child: ListView.builder(
                //       itemCount: pickedFiles!.length,
                //       itemBuilder: (context, index) {
                //         final pickedFile = pickedFiles![index];
                //         return Container(
                //           margin: const EdgeInsets.symmetric(vertical: 10),
                //           color: Colors.blue[100],
                //           child: ListTile(
                //             title: Text(pickedFile.name),
                //             subtitle: pickedFile.path != null
                //                 ? Image.file(
                //               File(pickedFile.path!),
                //               height: 100,
                //               fit: BoxFit.cover,
                //             )
                //                 : const SizedBox.shrink(),
                //           ),
                //         );
                //       },
                //     )),

                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Số ô trên mỗi hàng
                      crossAxisSpacing:
                          10, // Khoảng cách giữa các ô theo chiều ngang
                      mainAxisSpacing:
                          10, // Khoảng cách giữa các ô theo chiều dọc
                      childAspectRatio:
                          1, // Tỷ lệ giữa chiều rộng và chiều cao của ô
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
                              overflow:
                                  TextOverflow.ellipsis, // Giới hạn độ dài text
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              /// Select Files
              GestureDetector(
                onTap: () {
                  selectFiles();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFC7C5CC), width: 2), // Add border here
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
              /// Upload Files
              GestureDetector(
                onTap: () {
                  uploadFiles();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFC7C5CC), width: 2), // Add border here
                  ),
                  child: Center(
                    child: Text(
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

              /// Checkout Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckoutScreen()));
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
