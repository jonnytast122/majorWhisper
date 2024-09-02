import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/MyHistory.dart';

class Quizhistory extends StatefulWidget {
  final Map<String, dynamic> quizData;

  Quizhistory({required this.quizData});

  @override
  _QuizhistoryState createState() => _QuizhistoryState();
}

class _QuizhistoryState extends State<Quizhistory> {
  @override
  Widget build(BuildContext context) {
    final answers = widget.quizData['answers'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 22.0),
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
          padding: const EdgeInsets.only(top: 21.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: const Color.fromARGB(255, 0, 0, 0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Myhistory()),
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: answers.length,
          itemBuilder: (context, index) {
            final question = answers[index] as Map<String, dynamic>;
            final questionText = question['question_text'];
            final selectedChoice = question['selected_choice'];
            final options = question['options'] as Map<String, dynamic>;

            // List of alphabet indices
            final alphaIndices = ['A', 'B', 'C', 'D'];

            // Mapping options to their respective alpha indices
            final optionEntries = options.entries.toList();
            final indexedOptions = optionEntries.asMap().map((i, entry) {
              final alpha = alphaIndices[i];
              return MapEntry(alpha, entry.value);
            });

            // Find the alpha index for the selected choice
            final selectedAlpha = indexedOptions.entries
                .firstWhere((entry) => entry.value == selectedChoice)
                .key;

            return Container(
              margin: const EdgeInsets.only(bottom: 26.0),
              padding: const EdgeInsets.all(22.0),
              decoration: BoxDecoration(
                color: Color(0xFF006FFD),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
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
                            questionText,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontFamily: 'Inter-ExtraBold',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: Text(
                      'Answer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: "Inter-bold",
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Color(0xFFFFC71E), width: 5.0),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$selectedAlpha   ',
                              style: TextStyle(
                                color: Color(0xFF5B1CAE), // Change this to your desired color
                                fontSize: 18.0,
                                fontFamily: "Inter-medium",
                              ),
                            ),
                            TextSpan(
                              text: selectedChoice,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontFamily: "Inter-semibold",
                              ),
                            ),
                          ],
                        ),
                      ),
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
