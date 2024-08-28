import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/Home.dart';

class Quizhistory extends StatefulWidget {
  @override
  _QuizhistoryState createState() => _QuizhistoryState();
}

class _QuizhistoryState extends State<Quizhistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 22.0), // Adjust this value to move the title down
          child: Text(
            'Quiz History',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 30,
              fontFamily: 'Inter-semibold',
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 21.0), // Adjust this value to move the back arrow down
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
        padding: const EdgeInsets.all(16.0), // Add space below AppBar
        child: ListView.builder(
          itemCount: 1, // Number of quizzes
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(22.0),
              decoration: BoxDecoration(
                color: Color(0xFF006FFD),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center( // Centering the white question container
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85, // 80% of screen width
                      padding: const EdgeInsets.all(28.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Question ${index + 1}',
                            style: TextStyle(
                              color: Color(0xFF006FFD),
                              fontSize: 24.0,
                              fontFamily: 'Inter-medium',
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'What is your favourite subject?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontFamily: 'Inter-ExtraBold',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Answer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.yellow, width: 2.0),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'A',
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Maths',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
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
    );
  }
}
