import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/QuizHistory.dart'; // Import the QuizHistory page

class RecommendedMajorHistory extends StatefulWidget {
  final List<dynamic> recommendedMajors;

  RecommendedMajorHistory({required this.recommendedMajors});

  @override
  _RecommendedMajorHistoryState createState() => _RecommendedMajorHistoryState();
}

class _RecommendedMajorHistoryState extends State<RecommendedMajorHistory> {
  @override
  Widget build(BuildContext context) {
    final recommendedMajors = widget.recommendedMajors;

    // List of static images to be used in order
    final staticImages = [
      'assets/images/architect_vector.jpg',
      'assets/images/language_vector.jpg',
      'assets/images/technology_vector.jpg',
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(top: 21.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: const Color.fromARGB(255, 0, 0, 0),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
          ),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: const Text(
              'Recommended Major',
              style: TextStyle(
                fontSize: 30,
                fontFamily: "Inter-bold",
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: recommendedMajors.length,
          itemBuilder: (context, index) {
            final major = recommendedMajors[index]['major'];
            final imagePath = staticImages[index % staticImages.length]; // Selects image based on index

            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Stack(
                children: [
                  // Image container with rounded corners
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      imagePath,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Overlay for text with border
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8), // Background color
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                      child: Text(
                        major,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16,
                          fontFamily: 'Inter-semibold',
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
