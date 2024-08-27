import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'quiz_finished.dart'; // Ensure you have this import
import 'package:intl/intl.dart';

String formatTimestamp(DateTime dateTime) {
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  return formatter.format(dateTime);
}

// In your storeQuizAttempt method:
String timestamp = formatTimestamp(DateTime.now());

class Quiz extends StatefulWidget {
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  String? selectedChoice;
  String? userUUID;
  List<Map<String, dynamic>> currentAnswers =
      []; // Track current attempt answers

  @override
  void initState() {
    super.initState();
    userUUID = getCurrentUserUID();
    fetchQuestions();
  }

  String? getCurrentUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> fetchQuestions() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('major_recommendations_temp')
          .doc('questions')
          .get();

      setState(() {
        questions = snapshot.get('questions');
      });
    } catch (e) {
      print('Error fetching questions: $e');
    }
  }

  void storeQuizAttempt(List<Map<String, dynamic>> answers) async {
    if (userUUID == null) {
      print('User is not logged in.');
      return;
    }

    try {
      DocumentReference userAnswersRef =
          FirebaseFirestore.instance.collection('user_answers').doc(userUUID);

      DocumentSnapshot snapshot = await userAnswersRef.get();

      int nextQuizNumber = 1;

      if (snapshot.exists) {
        Map<String, dynamic> existingData =
            snapshot.data() as Map<String, dynamic>;

        // Find the highest quiz number in the existing data
        List<int> quizNumbers = existingData.keys
            .where((key) => key.startsWith('quiz'))
            .map((key) => int.parse(key.replaceAll('quiz', '')))
            .toList();

        if (quizNumbers.isNotEmpty) {
          nextQuizNumber = quizNumbers.reduce((a, b) => a > b ? a : b) + 1;
        }
      }

      String currentAttemptKey = 'quiz$nextQuizNumber';

      // Get the current timestamp with the desired format
      String timestamp = formatTimestamp(DateTime.now());

      // Store the current attempt answers with timestamp
      await userAnswersRef.update({
        currentAttemptKey: {
          'timestamp': timestamp,
          'answers': answers,
        },
      }).catchError((error) async {
        // If the document does not exist, create it with the first attempt
        await userAnswersRef.set({
          currentAttemptKey: {
            'timestamp': timestamp,
            'answers': answers,
          },
        });
      });

      print('Quiz attempt stored successfully');
    } catch (e) {
      print('Error storing quiz attempt: $e');
    }
  }

  void storeAnswer(
      String questionText, String selectedChoice, List<String> options) {
    // Prepare the options map in the specified format
    Map<String, dynamic> optionsMap = {};
    for (int i = 0; i < options.length; i++) {
      optionsMap[i.toString()] = options[i];
    }

    // Prepare the answer map
    Map<String, dynamic> answer = {
      'question_text': questionText,
      'selected_choice': selectedChoice,
      'options': optionsMap,
    };

    // Add the answer to the current attempt's list
    currentAnswers.add(answer);
  }

  void goToNextQuestion() {
    if (selectedChoice == null) {
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
            "Please select one of the choices.",
            style: TextStyle(
              fontFamily: "Inter-semibold",
              fontSize: 14,
              color: Color.fromARGB(255, 244, 164, 74),
            ),
          ),
        ),
      ).show(context);
      return;
    }

    var question = questions[currentQuestionIndex];
    var options =
        List<String>.from(question['options']); // Convert to List<String>

    storeAnswer(question['question_text'], selectedChoice!, options);

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedChoice =
            null; // Reset the selected choice for the next question
      });
    } else {
      // Store the entire quiz attempt
      storeQuizAttempt(currentAnswers);

      // Navigate to the Quiz Finished screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizFinished(), // Adjust if needed
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    var question = questions[currentQuestionIndex];
    var options = question['options'];

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.48, // Top half
                decoration: BoxDecoration(
                  color: Color(0xFF006FFD),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 65.0), // Adjust padding
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Quiz',
                        style: TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontFamily: "Inter-bold"),
                      ),
                      SizedBox(height: 15),
                      Text(
                        '“Think deeply, choose wisely!\nEach question guides you\ncloser to your perfect major.”',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: "Inter-bold",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Question ${currentQuestionIndex + 1} of ${questions.length}',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: "Inter-bold",
                        ),
                      ),
                      SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: (currentQuestionIndex + 1) / questions.length,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white, // Bottom half
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height *
                          0.065, // Adjust this value
                      left: 35.0,
                      right: 35.0,
                      child: Column(
                        children: [
                          for (int i = 0; i < options.length; i++)
                            buildChoiceButton(
                                String.fromCharCode(65 + i), options[i]),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(250, 50),
                              backgroundColor:
                                  currentQuestionIndex == questions.length - 1
                                      ? Color(0xFFFFC107) // Yellow for Submit
                                      : Color(0xFF006FFD), // Blue for Next
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            onPressed: goToNextQuestion,
                            child: Text(
                              currentQuestionIndex == questions.length - 1
                                  ? 'Submit'
                                  : 'Next',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "Inter-semibold",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.07,
            right: MediaQuery.of(context).size.width * 0.07,
            top: MediaQuery.of(context).size.height * 0.33,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(66, 0, 68, 255),
                    blurRadius: 10.0,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      'Question',
                      style: TextStyle(
                          fontSize: 28,
                          color: Color(0xFF006FFD),
                          fontFamily: "Inter-medium"),
                    ),
                    SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        question['question_text'],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: "Inter-Extrabold"),
                        textAlign: TextAlign.center,
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

  Widget buildChoiceButton(String label, String text) {
    bool isSelected = selectedChoice == label;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(66, 0, 68, 255),
              blurRadius: 10.0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white, // Button color
            minimumSize: Size(double.infinity, 70), // Stretch to fill width
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: isSelected
                  ? BorderSide(
                      color: Color(0xFF006FFD),
                      width: 3) // Blue border when selected
                  : BorderSide.none, // No border when not selected
            ),
          ),
          onPressed: () {
            setState(() {
              selectedChoice = label; // Set the selected choice
            });
          },
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Inter-medium",
                  color: Color(0xFF5B1CAE), // Purple for label
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Inter-semibold",
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
