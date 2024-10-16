import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/QuizHistory.dart';

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
            final imageUrl = recommendedMajors[index]['image_url']; // Fetch the image URL from Firebase

            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Stack(
                children: [
                  // Image container with rounded corners
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      imageUrl, // Use Image.network to load from a URL
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Icon(Icons.error)); // Handle any errors
                      },
                    ),
                  ),
                  // Overlay for text with border
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8.0),
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
