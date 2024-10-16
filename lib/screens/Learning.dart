import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/LearningResult.dart';
import 'package:http/http.dart' as http;
import 'RouteHosting.dart';

class Learning extends StatefulWidget {
  @override
  _LearningState createState() => _LearningState();
}

class _LearningState extends State<Learning> {
  String selectedDegree = 'Bachelor'; // Default selected button
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25), // Adjust radius if needed
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF006FFD),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: 800,
          // Adjust this value to fit your content
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Ensures dialog size fits content
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Explore your major's path",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Inter-semibold',
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Search and explore your future\nlearning journey!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Inter-regular',
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Major",
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontFamily: 'Inter-regular',
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF000000),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Color(0xFF000000),
                      size: 20,
                    ),
                    onPressed: () {
                      _search(_searchController.text, selectedDegree);
                    },
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFFEDEDED),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              onFieldSubmitted: (value) => _search(value, selectedDegree),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Degree",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Inter-semibold',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildDegreeButton('Bachelor'),
                SizedBox(width: 10),
                buildDegreeButton('Master'),
                SizedBox(width: 10),
                buildDegreeButton('PhD'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDegreeButton(String degree) {
    final isSelected = selectedDegree == degree;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedDegree = degree;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Colors.white : Colors.white.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        degree,
        style: TextStyle(
          color: isSelected ? Color(0xFF006FFD) : Colors.white,
          fontSize: 12,
          fontFamily: 'Inter-semibold',
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchLearningPath(
      String majorName, String degree) async {
    final String url = "${RouteHosting.baseUrl}";
    final String api = url + degree.toLowerCase() + "-degree-learning-path";
    print("api: $api");

    try {
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
        return {'error': 'Failed to load learning path'};
      }
    } catch (e) {
      return {'error': 'An error occurred'};
    }
  }

  void _search(String majorName, String degree) async {
    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/icon/learning_loading.json', // Path to your Lottie animation file
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 20),
                Text(
                  'Learning Path is Generating\nAlmost Ready!',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter-semibold',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Fetch data
    try {
      final data = await fetchLearningPath(majorName, degree);

      // Dismiss the loading dialog
      Navigator.of(context).pop();

      // Check if data is empty or contains errors
      if (data.containsKey('error')) {
        // Show error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(data['error']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the error dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
        return; // Exit if there was an error
      }

      // Navigate to LearningResult with fetched data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LearningResult(
            majorName: majorName,
            degree: degree,
            data: data,
          ),
        ),
      );
    } catch (e) {
      // Handle any unexpected exceptions
      Navigator.of(context).pop(); // Dismiss the loading dialog

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An unexpected error occurred: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the error dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
