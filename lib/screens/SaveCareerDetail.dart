import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SaveCareerDetail extends StatefulWidget {
  final String majorName;
  final Map<String, dynamic> data;
  final String imageUrl;
  final String country;

  SaveCareerDetail(
      {required this.majorName,
      required this.data,
      required this.imageUrl,
      required this.country});

  @override
  _SaveCareerDetailState createState() => _SaveCareerDetailState();
}

class _SaveCareerDetailState extends State<SaveCareerDetail> {
  @override
  Widget build(BuildContext context) {
    String capitalize(String text) {
      return text
          .split(' ')
          .map(
              (word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
    }

    final imageUrl = widget.imageUrl;
    final country = widget.country;
    final path = 'career_path_' + country.toLowerCase();
    final majorDetail = widget.data[path] ?? 'No data available';

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Color(0xFF006FFD),
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : AssetImage('assets/icon/profile_holder.png')
                          as ImageProvider,
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // This will only affect the image decoration if the network request fails
                  },
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
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  capitalize(widget.majorName),
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
                        data: majorDetail,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Inter-regular',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
