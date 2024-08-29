import 'package:flutter/material.dart';

class Majorrecom extends StatefulWidget {
  @override
  _MajorrecomState createState() => _MajorrecomState();
}

class _MajorrecomState extends State<Majorrecom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // Adjust the height of the AppBar
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          leading: Padding(
            padding: const EdgeInsets.only(
                top: 21.0), // Adjust this value to move the back arrow down
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: const Color.fromARGB(255, 0, 0, 0),
              onPressed: () {
                Navigator.pop(context); // Navigates back to the previous screen
              },
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white, // Blue background color
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Adjust the column's height to its content
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center the texts horizontally
                children: [
                  const Text(
                    'Explore Your Future!', // Existing subtitle text
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: "Inter-semibold",
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 1.0), // Space between texts
                  const Text(
                    'Discover the Best Fit for Your Future', // New text
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter-medium",
                      color: Color.fromARGB(
                          255, 100, 100, 100), // Adjust color if needed
                    ),
                    textAlign: TextAlign.center, // Center-align the new text
                  ),
                  const SizedBox(height: 16.0), // Space between text and button
                  ElevatedButton(
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF006FFD), // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                    ),
                    child: const Text(
                      '........................',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter-semibold',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.73,
              decoration: const BoxDecoration(
                color: Color(0xFF006FFD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: 3, // Number of items
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 120.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/Data_Science_vector.png'), // Path to your image
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Data Science', // Major name from API
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter-bold",
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                const Text(
                                  'You enjoy solving puzzles or math problems (Q1), prefer working independently (Q2), and like to spend your free time reading or researching (Q3). Computer Science involves problem-solving, working with data, and often requires independent work. Your interest in technology and STEM subjects (Q6) aligns well with this major.', // Major description from API
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontFamily: "Inter-regular",
                                    color: Color(0xFF898A8D),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Add your onPressed logic here
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color(0xFF006FFD), // Text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    padding: EdgeInsets.zero, // Remove padding
                                    minimumSize: Size(
                                        60, 23), // Set minimum width and height
                                  ),
                                  child: const Text(
                                    'Learn More',
                                    style: TextStyle(
                                      fontSize: 7,
                                      fontFamily: 'Inter-semibold',
                                    ),
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
            ),
          ),
        ],
      ),
    );
  }
}
