import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';

class LearningResult extends StatefulWidget {
  final String majorName;

  LearningResult({required this.majorName});

  @override
  _LearningResultState createState() => _LearningResultState();
}

class _LearningResultState extends State<LearningResult> {
  Future<String>? _learningPath;

  @override
  void initState() {
    super.initState();
    _learningPath = fetchLearningPath(widget.majorName);
  }

  Future<String> fetchLearningPath(String majorName) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.102:5000/bachelor-degree-learning-path'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'major_name': majorName,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print(data);
        return data.toString(); // Default text if 'text' is null
      } else {
        return 'Failed to load learning path'; // Error message if API call fails
      }
    } catch (e) {
      return 'An error occurred'; // Error message if exception occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning Result'),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: _learningPath,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Markdown(
                  data: snapshot.data!,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inter-regular',
                    ),
                    h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    h2: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    h3: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    strong: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            } else {
              return Text('No data');
            }
          },
        ),
      ),
    );
  }
}
