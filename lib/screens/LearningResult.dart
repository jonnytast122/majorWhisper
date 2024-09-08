import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:majorwhisper/screens/Home.dart'; // Correct import for OnboardingScreen

class LearningResult extends StatelessWidget {
  final String majorName;
  final String degree;
  final Map<String, dynamic> data;

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
      final String url = "http://192.168.216.231:5000/";
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
    final imageUrl = data['image_url'];
    final learningPath = data[degree.toLowerCase() + '_degree_learning_path'] ??
        'Sorry something went wrong!\nNo data available';
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
      ),
    );
  }
}
