import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class Majorrecom extends StatefulWidget {
  @override
  _MajorrecomState createState() => _MajorrecomState();
}

class _MajorrecomState extends State<Majorrecom> {
  List<Map<String, dynamic>> recommendedMajors = [];
  String? userId; // To store the current user ID

  @override
  void initState() {
    super.initState();
    fetchCurrentUser(); // Fetch the current user ID
  }

  // Step 1: Fetch current user ID from Firebase Auth
  void fetchCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      requestMajorRecommendation(userId!); // Call the API with the current user ID
    } else {
      print('No user is currently signed in.');
    }
  }

  // Step 2: Request major recommendation from the API
  Future<void> requestMajorRecommendation(String userId) async {
    final url = Uri.parse('http://10.1.90.31:5000/major-recommendation');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"uuid": userId}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['message'] == "Majore successfully recommended and saved.") {
          fetchLatestQuizFromFirestore(userId); // Fetch latest quiz data from Firestore
        } else {
          print("Unexpected response from API: ${responseBody['message']}");
        }
      } else {
        print('Failed to fetch major recommendation. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating quiz: $e');
    }
  }

  // Step 3: Fetch the latest quiz data from Firestore
  Future<void> fetchLatestQuizFromFirestore(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('user_answers')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        List<Map<String, dynamic>> quizzes = [];

        // Extract all quizzes into a list
        data.forEach((key, value) {
          if (key.startsWith('quiz')) {
            quizzes.add({
              'name': key,
              'data': value,
            });
          }
        });

        // Sort quizzes by their name or index if they are sequential
        quizzes.sort((a, b) {
          // Extract the number from the quiz name (e.g., 'quiz1' -> 1)
          final numA = int.parse(a['name'].replaceAll(RegExp(r'^\D+'), ''));
          final numB = int.parse(b['name'].replaceAll(RegExp(r'^\D+'), ''));
          return numB.compareTo(numA); // Sort quizzes by number descending
        });

        if (quizzes.isNotEmpty) {
          final latestQuiz = quizzes.first['data']; // Get the latest quiz data
          final List<dynamic> recommendedMajorsList = latestQuiz['recommended_major'];

          // Step 4: Extract majors and reasons and display them
          List<Map<String, dynamic>> majors = recommendedMajorsList.map((majorData) {
            return {
              'major': majorData['major'],
              'reason': majorData['reason'],
            };
          }).toList();

          setState(() {
            recommendedMajors = majors;
          });
        }
      } else {
        print('No document found for user ID: $userId');
      }
    } catch (e) {
      print('Error fetching user answers from Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          leading: Padding(
            padding: const EdgeInsets.only(top: 21.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: const Color.fromARGB(255, 0, 0, 0),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Explore Your Future!',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: "Inter-semibold",
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 1.0),
                  const Text(
                    'Discover the Best Fit for Your Future',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter-medium",
                      color: Color.fromARGB(255, 100, 100, 100),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF006FFD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                    ),
                    child: const Text(
                      '........................',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter-semibold',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.73,
              decoration: const BoxDecoration(
                color: Color(0xFF006FFD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: recommendedMajors.length,
                  itemBuilder: (context, index) {
                    final major = recommendedMajors[index]['major']!;
                    final reason = recommendedMajors[index]['reason']!;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 120.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage('assets/images/Data_Science_vector.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  major, // Major name from Firestore
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter-bold",
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  reason, // Major description from Firestore
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontFamily: "Inter-regular",
                                    color: Color(0xFF898A8D),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Add your onPressed logic here
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Color(0xFF006FFD),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(60, 23),
                                  ),
                                  child: const Text(
                                    'Learn More',
                                    style: TextStyle(
                                      fontSize: 7,
                                      fontFamily: 'Inter-semibold',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
