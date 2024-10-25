import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:majorwhisper/screens/Home.dart';

class CareerResult extends StatefulWidget {
  final String majorName;
  final String country;
  final Map<String, dynamic> data;

  CareerResult({
    required this.majorName,
    required this.country,
    required this.data,
  });

  @override
  _CareerResultState createState() => _CareerResultState();
}

class _CareerResultState extends State<CareerResult> {
  bool isSaved = false;

  // Method to save the career path data to Firestore
  Future<void> saveToFirestore() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('career_paths')
            .doc(userId);

        // Append new career path to the existing data array
        await userDoc.update({
          'data': FieldValue.arrayUnion([{
            'major_name': widget.majorName,
            'country': widget.country,
            'career_path': widget.data,
          }])
        }).catchError((error) async {
          // If the document doesn't exist, create it
          await userDoc.set({
            'data': [{
              'major_name': widget.majorName,
              'country': widget.country,
              'career_path': widget.data,
            }]
          });
        });

        print('Career path saved successfully');
        setState(() {
          isSaved = true; // Change button text and color
        });

        // Show success toast using DelightToastBar
        DelightToastBar(
          position: DelightSnackbarPosition.top,
          autoDismiss: true,
          snackbarDuration: Duration(seconds: 2),
          builder: (context) => const ToastCard(
            leading: Icon(
              Icons.check_circle,
              size: 28,
              color: Colors.green,
            ),
            title: Text(
              "Career path saved successfully!",
              style: TextStyle(
                fontFamily: "Inter-semibold",
                fontSize: 14,
                color: Colors.green,
              ),
            ),
          ),
        ).show(context);
      } else {
        print('No user logged in');
      }
    } catch (e) {
      print('Error saving career path: $e');
    }
  }

  String toTitleCase(String text) {
    return text
        .toLowerCase()
        .split(' ')
        .map((word) =>
    word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl =
    widget.data['image_url']; // Use the image_url from the API response
    final CareerPath = widget.data['career_path_' + widget.country.toLowerCase()] ??
        'No data available';

    return Scaffold(
      body: Stack(
        children: [
          // Background Image in AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300, // Height of AppBar
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageUrl != null && imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : AssetImage('assets/icon/profile_holder.png')
                  as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                ),
                title: Text(
                  toTitleCase(widget.majorName),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006FFD),
                      shadows: [
                        Shadow(
                            // bottomLeft
                            offset: Offset(-1.5, -1.5),
                            color: Colors.white),
                        Shadow(
                            // bottomRight
                            offset: Offset(1.5, -1.5),
                            color: Colors.white),
                        Shadow(
                            // topRight
                            offset: Offset(1.5, 1.5),
                            color: Colors.white),
                        Shadow(
                            // topLeft
                            offset: Offset(-1.5, 1.5),
                            color: Colors.white),
                      ]
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          ),
          // Body content
          Positioned(
            top: 230,
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Markdown(
                        data: CareerPath,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Inter-regular',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(250, 50),
                        backgroundColor: isSaved
                            ? Colors.green // Change to green after saving
                            : Color(0xFF006FFD), // Blue before saving
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                      ),
                      onPressed: isSaved
                          ? null // Disable button if already saved
                          : saveToFirestore,
                      child: Text(
                        isSaved ? 'Saved' : 'Save', // Change text after saving
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: "Inter-semibold",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
