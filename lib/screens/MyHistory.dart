import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:majorwhisper/screens/Home.dart';
import 'package:majorwhisper/screens/QuizHistory.dart'; // Import your QuizHistory screen

class Myhistory extends StatefulWidget {
  @override
  _MyhistoryState createState() => _MyhistoryState();
}

class _MyhistoryState extends State<Myhistory> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId;
  List<Map<String, dynamic>> quizzes = [];

  @override
  void initState() {
    super.initState();
    userId = getCurrentUserUID();
    fetchQuizzes(); // Start by fetching the quizzes
  }

  String? getCurrentUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> fetchQuizzes() async {
    if (userId == null) return;

    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('user_answers')
          .doc(userId) // Use the retrieved userId here
          .get();

      if (doc.exists) {
        Map<String, dynamic>? data = doc.data();
        if (data != null) {
          setState(() {
            quizzes = data.entries
                .where((entry) => entry.key.startsWith('quiz'))
                .map((entry) => {
                      'key': entry.key,
                      'value': entry.value,
                      'timestamp': entry.value['timestamp'],
                    })
                .toList();
          });
        }
      }
    } catch (e) {
      print('Error fetching quizzes: $e');
    }
  }

  String formatQuizTitle(String quizKey) {
    // Extract the number from the quiz key (e.g., 'quiz1' -> 'Q1')
    return 'Q' + quizKey.replaceAll(RegExp(r'[^0-9]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(
              top: 22.0), // Adjust this value to move the title down
          child: Text(
            'My History',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 30,
              fontFamily: 'Inter-semibold',
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(
              top: 21.0), // Adjust this value to move the back arrow down
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: const Color.fromARGB(255, 0, 0, 0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0), // Add space below AppBar
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: quizzes.length, // Number of quizzes
                    itemBuilder: (context, index) {
                      var quizEntry = quizzes[index];
                      String quizKey = quizEntry['key'];
                      String quizTitle = formatQuizTitle(
                          quizKey); // Format the title as 'Q' + number
                      String formattedDate = '';

                      // Extract timestamp and handle formatting
                      var timestamp = quizEntry['timestamp'];
                      DateTime quizDate;

                      if (timestamp is Timestamp) {
                        quizDate = timestamp.toDate();
                      } else if (timestamp is String) {
                        quizDate = DateFormat('dd MMM yyyy').parse(timestamp);
                      } else {
                        quizDate =
                            DateTime.now(); // Fallback to current date/time
                      }

                      formattedDate =
                          DateFormat('dd-MMM-yyyy').format(quizDate);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Quizhistory(
                                quizData: quizEntry['value'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF006FFD),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 70.0,
                                height: 70.0,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: Text(
                                    quizTitle,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: Color(0xFF006FFD),
                                      fontFamily: "Inter-black",
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Complete', // Placeholder for quiz status
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Inter-semibold",
                                        color: Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          size: 20.0,
                                          Icons.calendar_today,
                                          color:
                                              Color.fromARGB(255, 255, 255, 255),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Expanded(
                                          child: Text(
                                            formattedDate,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFFDFDFDF),
                                              fontFamily: "Inter-regular",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle button press here
                                },
                                child: Image.asset(
                                  'assets/icon/arrow.png', // Path to your custom icon
                                  width: 40.0,
                                  height: 30.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
