import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:majorwhisper/screens/MajorDetail.dart';
import 'package:lottie/lottie.dart';
import 'routes/RouteHosting.dart';
import 'package:majorwhisper/screens/BigFive.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Majorrecom extends StatefulWidget {
  @override
  _MajorrecomState createState() => _MajorrecomState();
}

class _MajorrecomState extends State<Majorrecom> {
  List<Map<String, dynamic>> recommendedMajors = [];
  String? userId; // To store the current user ID
  bool isLoading = true; // Add loading state
  double selectedRating = 0;
  String? user = FirebaseAuth.instance.currentUser?.uid;

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
      requestMajorRecommendation(
          userId!); // Call the API with the current user ID
    } else {
      print('No user is currently signed in.');
    }
  }

  // Step 2: Request major recommendation from the API
  Future<void> requestMajorRecommendation(String userId) async {
    setState(() {
      isLoading = true; // Set loading state to true when starting the request
    });

    final url = Uri.parse('${RouteHosting.baseUrl}major-recommendation');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"uuid": userId}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['message'] ==
            "Major successfully recommended and saved.") {
          fetchLatestQuizFromFirestore(
              userId); // Fetch latest quiz data from Firestore
        } else {
          print("Unexpected response from API: ${responseBody['message']}");
        }
      } else {
        print(
            'Failed to fetch major recommendation. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating quiz: $e');
    } finally {
      setState(() {
        isLoading = false; // Hide loading animation after fetching the data
      });
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
          final List<dynamic> recommendedMajorsList =
              latestQuiz['recommended_major'];

          // Step 4: Extract majors and reasons and display them
          List<Map<String, dynamic>> majors =
              recommendedMajorsList.map((majorData) {
            return {
              'major': majorData['major'],
              'reason': majorData['reason'],
              'image_url': majorData['image_url'],
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

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 250,
            width: 250,
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
                  'Major Detail is Generating\nAlmost Ready!',
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
  }

  void _fetchDataAndNavigate(BuildContext context, String majorName) async {
    _showLoadingDialog(context);

    try {
      final response = await http.post(
        Uri.parse("${RouteHosting.baseUrl}major-detail"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'major_name': majorName,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Navigator.of(context).pop(); // Close the loading dialog

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Majordetail(
              majorName: majorName,
              data: data, // Pass data to Majordetail
            ),
          ),
        );
      } else {
        Navigator.of(context).pop(); // Close the loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  void _showRatingDialog(BuildContext context, String userId) async {
    Map<String, double> ratings = {};
    List<Map<String, dynamic>> recommendedMajors = [];
    List<Map<String, dynamic>> quizQuestionsAndAnswers = [];

    try {
      // Fetch the latest quiz data from Firestore
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

        // Sort quizzes by quiz number (descending order)
        quizzes.sort((a, b) {
          final numA = int.parse(a['name'].replaceAll(RegExp(r'^\D+'), ''));
          final numB = int.parse(b['name'].replaceAll(RegExp(r'^\D+'), ''));
          return numB.compareTo(numA);
        });

        if (quizzes.isNotEmpty) {
          final latestQuiz = quizzes.first['data'];

          // Extract recommended majors
          if (latestQuiz.containsKey('recommended_major')) {
            recommendedMajors = List<Map<String, dynamic>>.from(
              latestQuiz['recommended_major'].map((majorData) => {
                    'major': majorData['major'],
                    'reason': majorData['reason'],
                    'image_url': majorData['image_url'],
                  }),
            );
          }

          // Extract quiz questions and selected answers
          if (latestQuiz.containsKey('answers')) {
            quizQuestionsAndAnswers = List<Map<String, dynamic>>.from(
              latestQuiz['answers'].map((answerData) => {
                    'question_text': answerData['question_text'],
                    'selected_choice': answerData['selected_choice'],
                  }),
            );
          }
        }
      }
    } catch (e) {
      print('Error fetching user answers from Firestore: $e');
      return;
    }

    // If no recommended majors are found, return
    if (recommendedMajors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No recommended majors found."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show the dialog with ratings
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text(
            "Major Feedback",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Please rate recommended major below",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ...recommendedMajors.map((major) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        color: Color.fromARGB(255, 236, 236, 236),
                        height: 1.0,
                        thickness: 1.0,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        major['major'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      RatingBar.builder(
                        initialRating: ratings[major['major']] ?? 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          ratings[major['major']] = rating;
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Check if all majors are rated
                      if (ratings.length < recommendedMajors.length) {
                        DelightToastBar(
                          position: DelightSnackbarPosition.top,
                          autoDismiss: true,
                          snackbarDuration: Duration(seconds: 2),
                          builder: (context) => const ToastCard(
                            leading: Icon(
                              Icons.error,
                              size: 28,
                              color: Color.fromARGB(255, 244, 164, 74),
                            ),
                            title: Text(
                              "Please rates all the majors.",
                              style: TextStyle(
                                fontFamily: "Inter-semibold",
                                fontSize: 14,
                                color: Color.fromARGB(255, 244, 164, 74),
                              ),
                            ),
                          ),
                        ).show(context);
                      } else {
                        // Store the ratings and quiz data into Firestore
                        await storeRatingAndQuizData(userId, ratings,
                            recommendedMajors, quizQuestionsAndAnswers);
                        DelightToastBar(
                          position: DelightSnackbarPosition.top,
                          autoDismiss: true,
                          snackbarDuration: Duration(seconds: 2),
                          builder: (context) => const ToastCard(
                            leading: Icon(
                              Icons.feedback,
                              size: 28,
                              color: Color.fromARGB(255, 50, 214, 52),
                            ),
                            title: Text(
                              "Thanks For Your Feedback.",
                              style: TextStyle(
                                fontFamily: "Inter-semibold",
                                fontSize: 14,
                                color: Color.fromARGB(255, 50, 214, 52),
                              ),
                            ),
                          ),
                        ).show(context);
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Home()), // Replace `HomeScreen()` with your actual home screen widget
                        ); // Close the dialog
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF006FFD),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> storeRatingAndQuizData(
    String userId,
    Map<String, double> ratings,
    List<Map<String, dynamic>> recommendedMajors,
    List<Map<String, dynamic>> quizQuestionsAndAnswers,
  ) async {
    try {
      DocumentReference userFeedbackRef =
          FirebaseFirestore.instance.collection('major_feedback').doc(userId);
      String timestamp = DateTime.now().toString();

      // Prepare the data to be stored
      Map<String, dynamic> feedbackData = {
        'timestamp': timestamp,
        'quiz_data': quizQuestionsAndAnswers,
        'major_ratings': recommendedMajors.map((major) {
          return {
            'major': major['major'],
            'rating':
                ratings[major['major']], // Store the rating for each major
          };
        }).toList(),
      };

      // Get the latest feedback count to create the feedback name dynamically (e.g., feedback1, feedback2)
      final feedbackSnapshot = await userFeedbackRef.get();
      int feedbackCount = 0;

      if (feedbackSnapshot.exists) {
        final existingData = feedbackSnapshot.data();
        if (existingData != null && existingData is Map<String, dynamic>) {
          feedbackCount =
              existingData.length; // Correctly access the length of the Map
        }
      }

      // Store feedback with a dynamic name (feedback1, feedback2, etc.)
      await userFeedbackRef.update({
        'feedback${feedbackCount + 1}':
            feedbackData, // Store under feedback1, feedback2, etc.
      });

      print('Quiz and major feedback stored successfully');
    } catch (e) {
      print('Error storing quiz and feedback: $e');
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
                _showRatingDialog(
                  context,
                  user!,
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
                child: Column(
                  children: [
                    Expanded(
                      child: isLoading
                          ? Center(
                              child: Lottie.asset(
                                'assets/icon/learning_loading.json', // Path to your Lottie animation file
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            )
                          : ListView.builder(
                              itemCount: recommendedMajors.length,
                              itemBuilder: (context, index) {
                                final major =
                                    recommendedMajors[index]['major']!;
                                final reason =
                                    recommendedMajors[index]['reason']!;
                                final imageUrl =
                                    recommendedMajors[index]['image_url']!;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  padding: const EdgeInsets.all(14.0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 120.0,
                                        height: 150.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      const SizedBox(width: 20.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                fontSize: 9.5,
                                                fontFamily: "Inter-regular",
                                                color: Color(0xFF898A8D),
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                _fetchDataAndNavigate(
                                                    context, major);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    Color(0xFF006FFD),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                padding: EdgeInsets.zero,
                                                minimumSize: Size(70, 30),
                                              ),
                                              child: const Text(
                                                'Learn More',
                                                style: TextStyle(
                                                  fontSize: 8,
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
                    const SizedBox(height: 16.0), // Add some spacing
                    // Display the button only when the loading is complete
                    if (!isLoading)
                      ElevatedButton(
                        onPressed: () {
                          _showRatingDialog(
                            context,
                            user!,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color(0xFF006FFD),
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 22),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Back Home',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter-semibold",
                          ),
                        ),
                      )
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
