import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/Home.dart';

class QuizFinished extends StatefulWidget {
  @override
  _QuizFinishedState createState() => _QuizFinishedState();
}

class _QuizFinishedState extends State<QuizFinished> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
        crossAxisAlignment: CrossAxisAlignment.center, // Center items horizontally
        children: [
          Image.asset(
            'assets/images/verify.png', // Path to your image
            fit: BoxFit.cover, // Adjust as needed
            width: 150, // Set width as needed
            height: 150, // Set height as needed
          ),
          SizedBox(height: 20), // Space between image and text
          Text(
            'Congratulations!',
            style: TextStyle(
              fontSize: 36,
              color: Colors.black,
              fontFamily: "Inter-semibold",
            ),
          ),
          SizedBox(height: 10), // Space between text elements
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: const Color.fromARGB(255, 158, 158, 158),
                fontFamily: "Inter-regular",
              ),
              children: [
                TextSpan(
                  text: 'You are one step closer to a bright future. \nClick the next button to know ',
                ),
                TextSpan(
                  text: 'your major',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 0, 140, 255),
                      fontFamily: "Inter-bold" // Color for the word "major"
                      ),
                ),
                TextSpan(
                  text: '.',
                ),
              ],
            ),
          ),
          SizedBox(height: 100), // Space between text and button
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
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
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()), // Adjust if needed
                );
              },
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 18, // Adjust font size
                  color: Colors.white,
                  fontFamily: "Inter-semibold",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
