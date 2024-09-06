import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lottie/lottie.dart';

class Majordetail extends StatefulWidget {
  final String majorName;
  Majordetail({required this.majorName});

  @override
  _MajordetailState createState() => _MajordetailState();
}

class _MajordetailState extends State<Majordetail> {
  Future<Map<String, dynamic>>? _MajorDetailData;

  @override
  void initState() {
    super.initState();
    _MajorDetailData = fetchMajorDetail(widget.majorName);
  }

  Future<Map<String, dynamic>> fetchMajorDetail(String majorName) async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.0.102:5000/major-detail"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'major_name': majorName,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed to load Career path'
        }; // Error message if API call fails
      }
    } catch (e) {
      return {
        'error': 'An error occurred'
      }; // Error message if exception occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    String capitalize(String text) {
      return text
          .split(' ')
          .map(
              (word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
    }

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _MajorDetailData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/icon/detail_loading.json', // Path to your Lottie animation file
                    width: 150,
                    height: 150,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Detail Major is Generating \nAlmost Ready!',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inter-semibold',
                      color: Color(
                          0xFF006FFD), // Customize the color to fit your app's theme
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(
                child:
                    Text('Error: ${snapshot.error ?? "Failed to load data"}'));
          } else {
            final data = snapshot.data!;
            final imageUrl = data['image_url'];
            final MajorDetail = data['major_detail'] ?? 'No data available';

            return Stack(
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
                            ? NetworkImage(
                                imageUrl) // Load from URL if available
                            : AssetImage('assets/icon/profile_holder.png')
                                as ImageProvider, // Load from assets if URL is not available
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: AppBar(
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white, // Set icon color to white
                          size: 30, // Increase icon size
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      title: Text(
                        capitalize(widget.majorName),
                        style: TextStyle(
                          fontSize: 30, // Increase font size
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Bold text
                        ),
                      ),
                      backgroundColor: Colors
                          .transparent, // Make the AppBar background transparent
                      elevation: 0, // Remove the shadow if not needed
                    ),
                  ),
                ),
                // Body content
                Positioned(
                  top:
                      230, // Position body content to overlap slightly with AppBar
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Markdown(
                        data: MajorDetail,
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
            );
          }
        },
      ),
    );
  }
}
