import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/CreateCourse.dart';

class CourseGen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top half (blue with bottom radius and search bar)
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30.0), // Radius for the bottom corners
            ),
            child: Container(
              color: Color(0xFF006FFD),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2, // Adjust the height as needed
                child: Padding(
                  padding: const EdgeInsets.all(24.0), // Adjust padding as needed
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
                    children: [
                      Spacer(), // Pushes the content to the bottom
                      // Text
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0), // Space between text and Row
                        child: Text(
                          'Generate custom courses with AI.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Inter-semibold",
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      // Row with TextField and image button
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Search Course',
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 221, 221, 221),
                                ),
                                prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 108, 108, 108)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0), // Space between TextField and button
                          GestureDetector(
                            onTap: () {
                              // Define the action for the image button
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCourse())
                              );
                            },
                            child: Image.asset(
                              'assets/images/add_course.png', // Replace with your image asset
                              width: 40, // Adjust size as needed
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom half (content)
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  'Bottom Half',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
