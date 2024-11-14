import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/navigation_menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class UploadFile extends StatefulWidget {
  final int ticketId;
  const UploadFile({super.key, required this.ticketId});

  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  List<PlatformFile>? pickedFiles;
  List<UploadTask>? uploadTasks;
  bool isUploading = false;


  Future selectFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;

    setState(() {
      pickedFiles = result.files;
    });
  }

  Future uploadFiles() async {
    if (pickedFiles == null || pickedFiles!.isEmpty) return;

    setState(() {
      isUploading = true;
    });

    uploadTasks = [];
    List<String> imageUrls = [];

    try {
      for (var pickedFile in pickedFiles!) {
        if (pickedFile.path == null) {
          print("Picked file path is null");
          continue;
        }

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

      if (imageUrls.isEmpty) {
        print("No image URLs to upload.");
        setState(() {
          isUploading = false;
        });
        return;
      }

      await uploadToApi(imageUrls);
    } catch (e) {
      print("Error during file upload: $e");
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Future uploadToApi(List<String> imageUrls) async {
    try {
      var body = json.encode(
        imageUrls
      );

      print('Sending data to API: $body');

      final url = Uri.parse(
          'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/images?ticketId=${widget.ticketId}'
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
            "Authorization": 'Bearer ${UserManager().token}'
        },
        body: body,
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print("Image URLs uploaded successfully!");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your ticket is ready to create sell post'),
            duration: Duration(seconds: 3), // Thời gian hiển thị
          ),
        );
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
                    MaterialPageRoute(builder: (context) => NavigationMenu()),
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
