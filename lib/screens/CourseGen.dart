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
                height: MediaQuery.of(context).size.height *
                    0.2, // Adjust the height as needed
                child: Padding(
                  padding:
                      const EdgeInsets.all(24.0), // Adjust padding as needed
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align content to the left
                    children: [
                      Spacer(), // Pushes the content to the bottom
                      // Text
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16.0), // Space between text and Row
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
                                prefixIcon: Icon(Icons.search,
                                    color: Color.fromARGB(255, 108, 108, 108)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: 8.0), // Space between TextField and button
                          GestureDetector(
                            onTap: () {
                              // Define the action for the image button
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateCourse()));
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
          Padding(
            padding: const EdgeInsets.all(
                16.0), // Add padding around the entire container
            child: SizedBox(
              height: 232, // Set the height for the entire container
              child: Container(
                decoration: BoxDecoration(
                  color:
                      Colors.white, // Background color for the entire container
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12, // Shadow for a 3D effect
                      spreadRadius: 1,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16)), // Round the top corners
                      child: Image.asset(
                        'assets/images/food_vector.jpg', // Replace with your image asset path
                        fit: BoxFit.cover, // Cover the entire upper half
                        width:
                            double.infinity, // Fill the width of the container
                        height: 100, // Adjust height for the image
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Advance React Native Development',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Inter-bold",
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Programming',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Inter-semibold",
                              color: const Color.fromARGB(255, 179, 179, 179),
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF006FFD).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.book,
                                        color: Color(0xFF006FFD), size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      '5 Chapters',
                                      style: TextStyle(
                                        color: Color(0xFF006FFD),
                                        fontFamily: "Inter-semibold",
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF006FFD).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Advance',
                                  style: TextStyle(
                                    color: Color(0xFF006FFD),
                                    fontFamily: "Inter-semibold",
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.grey),
                                onPressed: () {
                                  // Add delete functionality here
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
