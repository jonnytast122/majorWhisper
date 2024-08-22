import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  String? selectedChoice;

  @override
  Widget build(BuildContext context) {
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
                        'Question 3 of 10',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: "Inter-bold",
                        ),
                      ),
                      SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: 0.1, // 30% progress
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)), // Yellow color
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
                          buildChoiceButton('A', 'Maths'),
                          buildChoiceButton('B', 'English'),
                          buildChoiceButton('C', 'Science'),
                          buildChoiceButton('D', 'Arts'),
                          SizedBox(
                              height: 20), // Spacing before the "Next" button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(250, 50), // Adjust width and height
                              backgroundColor: Color(0xFF006FFD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10), // Adjust padding
                            ),
                            onPressed: () {
                              // Handle "Next" button press
                            },
                            child: Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 18, // Adjust font size
                                color: Colors.white,
                                fontFamily: "Inter-semibold",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Positioned white rectangle in the middle
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
                    SizedBox(height: 30), // Move "Question" down or up
                    Text(
                      'Question',
                      style: TextStyle(
                          fontSize: 28,
                          color: Color(0xFF006FFD),
                          fontFamily: "Inter-medium"),
                    ),
                    SizedBox(
                        height:
                            22), // Adjust this value to move the next text closer or farther
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'What aspect of your education experience do you enjoy most?',
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