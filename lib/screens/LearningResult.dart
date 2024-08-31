import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lottie/lottie.dart';

class LearningResult extends StatefulWidget {
  final String majorName;
  final String degree;

  LearningResult({required this.majorName, required this.degree});

  @override
  _LearningResultState createState() => _LearningResultState();
}

class _LearningResultState extends State<LearningResult> {
  Future<Map<String, dynamic>>? _learningPathData;

  @override
  void initState() {
    super.initState();
    _learningPathData = fetchLearningPath(widget.majorName);
  }

  Future<Map<String, dynamic>> fetchLearningPath(String majorName) async {
    try {
      final String url = "http://10.1.90.31:5000/";
      final String api =
          url + widget.degree.toLowerCase() + "-degree-learning-path";
      print("api : " + api);
      final response = await http.post(
        Uri.parse(api),
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
          'error': 'Failed to load learning path'
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
        future: _learningPathData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/icon/learning_loading.json', // Path to your Lottie animation file
                    width: 150,
                    height: 150,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Learning Path is Generating \nAlmost Ready!',
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
            ; // Use the image_url from the API response
            final learningPath =
                data[widget.degree.toLowerCase() + '_degree_learning_path'] ??
                    'Sorry something weng wrong! \nNo data available';
            print(data['image_url']);
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
                        data: learningPath,
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
