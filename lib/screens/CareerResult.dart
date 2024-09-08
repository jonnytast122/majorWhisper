import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lottie/lottie.dart';

class CareerResult extends StatefulWidget {
  final String majorName;
  final String country;

  CareerResult({required this.majorName, required this.country});

  @override
  _CareerResultState createState() => _CareerResultState();
}

class _CareerResultState extends State<CareerResult> {
  Future<Map<String, dynamic>>? _CareerPathData;

  @override
  void initState() {
    super.initState();
    _CareerPathData = fetchCareerPath(widget.majorName);
  }

  Future<Map<String, dynamic>> fetchCareerPath(String majorName) async {
    try {
      final String url = "http://192.168.234.231:5000/";
      final String api = url + "career-path-" + widget.country.toLowerCase();
      print("api : " + api);
      final response = await http.post(
        Uri.parse(api),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'career_name': majorName,
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
    // String capitalize(String text) {
    //   return text
    //       .split(' ')
    //       .map(
    //           (word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
    //       .join(' ');
    // }

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _CareerPathData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/icon/career_loading.json', // Path to your Lottie animation file
                    width: 150,
                    height: 150,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Career Path is Generating \nAlmost Ready!',
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
            final imageUrl =
                data['image_url']; // Use the image_url from the API response
            final CareerPath =
                data['career_path_' + widget.country.toLowerCase()] ??
                    'No data available';

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
                        widget.majorName,
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
            );
          }
        },
      ),
    );
  }
}
