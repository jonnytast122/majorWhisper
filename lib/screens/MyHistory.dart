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

  Future<bool?> confirmDeleteDialog(BuildContext context) {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logout_illustration.png', // Replace with your image path
                  height: 250,
                ),
              ),
              const Text(
                'Delete this quiz?',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Inter-black',
                  color: Color(0xFF2f3036),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Are you sure you want to delete this quiz?',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter-regular',
                  color: Color(0xFF71727A),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006FFD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      fontFamily: 'Inter-semibold',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Color(0xFF006FFD),
                      fontFamily: 'Inter-semibold',
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteQuiz(String quizKey) async {
    if (userId == null) return;

    try {
      await _firestore.collection('user_answers').doc(userId).update({
        quizKey: FieldValue.delete(),
      });

      setState(() {
        quizzes.removeWhere((quiz) => quiz['key'] == quizKey);
      });
    } catch (e) {
      print('Error deleting quiz: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 22.0),
          child: Text(
            'My History',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 25,
              fontFamily: 'Inter-semibold',
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 21.0),
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
        padding: const EdgeInsets.only(top: 30.0),
        child: ListView.builder(
          itemCount: quizzes.length,
          itemBuilder: (context, index) {
            var quizEntry = quizzes[index];
            String quizKey = quizEntry['key'];
            String quizTitle = formatQuizTitle(quizKey);
            String formattedDate = '';

            var timestamp = quizEntry['timestamp'];
            DateTime quizDate;

            if (timestamp is Timestamp) {
              quizDate = timestamp.toDate();
            } else if (timestamp is String) {
              quizDate = DateFormat('dd MMM yyyy').parse(timestamp);
            } else {
              quizDate = DateTime.now();
            }

            formattedDate = DateFormat('dd-MMM-yyyy').format(quizDate);

            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Dismissible(
                    key: Key(quizKey),
                    direction: DismissDirection
                        .endToStart, // Allow swipe only from right to left
                    confirmDismiss: (direction) async {
                      bool? confirmDelete = await confirmDeleteDialog(context);
                      return confirmDelete ??
                          false; // Handle null result properly
                    },
                    onDismissed: (direction) async {
                      // If the user confirmed, delete the quiz
                      if (direction == DismissDirection.endToStart) {
                        deleteQuiz(quizKey);
                      }
                    },
                    child: GestureDetector(
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
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 77, 124, 255)
                                  .withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                  const Text(
                                    'Quiz Completed',
                                    style: TextStyle(
                                      fontFamily: 'Inter-semibold',
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Date: $formattedDate',
                                    style: const TextStyle(
                                      fontFamily: 'Inter-regular',
                                      fontSize: 12,
                                      color: Color(0xFFD9D9D9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
