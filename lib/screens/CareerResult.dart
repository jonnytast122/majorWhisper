import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:majorwhisper/screens/Home.dart'; // Correct import for OnboardingScreen

class CareerResult extends StatelessWidget {
  final String majorName;
  final String country;
  final Map<String, dynamic> data;

  CareerResult(
      {required this.majorName, 
       required this.country, 
       required this.data});

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
        data['image_url']; // Use the image_url from the API response
    final CareerPath =
        data['career_path_' + country.toLowerCase()] ?? 'No data available';
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
                  toTitleCase(majorName),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
            ),
          ),
        ],
      ),
    );
  }
}
