import 'package:flutter/material.dart';

class UniversityDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF006FFD),
          toolbarHeight: 100, // Increased height for the AppBar
          title: Text(
            'University Detail',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontFamily: 'Inter-semibold',
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                    color: Color(0xFF006FFD),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30.0)),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align items to the start
                        children: [
                          SizedBox(
                              height: 50), // Adjusts spacing below the logo
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 86.0),
                            child: Text(
                              'Royal University of Phnom Penh',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: 'Inter-bold',
                              ),
                            ),
                          ),
                          contactInfo(Icons.place,
                              'Royal University of Phnom Penh (RUPP) Russian Federation Boulevard, Toul Kork, Phnom Penh, Cambodia.'),
                          contactInfo(Icons.phone,
                              'Tel: 855-23-883-640/ 855-23-884-154'),
                          contactInfo(Icons.link,
                              'https://www.facebook.com/rupp.edu.kh'),
                          contactInfo(Icons.link, 'https://www.rupp.edu.kh/'),

                          // New section for Majors
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26.0, vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align items to the left
                              children: [
                                Text(
                                  'Majors',
                                  style: TextStyle(
                                    color: Color(0xFF006FFD),
                                    fontSize: 20,
                                    fontFamily: 'Inter-bold',
                                  ),
                                ),
                                SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 4.0),
                                  child: Text(
                                    'Faculty of Social Science and Humanities',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 15,
                                      fontFamily: 'Inter-medium',
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6),
                                // GridView.builder for two-column layout with padding
                                Container(
                                  height: 300, // Set a height for the GridView
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Number of columns
                                      crossAxisSpacing:
                                          1.0, // Space between columns
                                      mainAxisSpacing:
                                          1.0, // Space between rows
                                      childAspectRatio:
                                          2.1, // Aspect ratio of each item
                                    ),
                                    itemCount: 5, // Number of items
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical:
                                                8), // Padding around each container
                                        child: SizedBox(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 23),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                          255, 51, 115, 255)
                                                      .withOpacity(0.1),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.school,
                                                  color: Colors.blue,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                    width:
                                                        15), // Reduce spacing between icon and text
                                                Expanded(
                                                  child: Text(
                                                    'Khmer Literature', // Replace with dynamic content as needed
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      fontSize:
                                                          14, // Reduce text size
                                                      fontFamily: 'Inter-bold',
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: screenHeight * 0.08 - 70, // Center logo on the boundary
              left: (screenWidth - 100) / 2,
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4.0),
                ),
                child: ClipOval(
                  child: Image.asset('assets/images/rupp_logo.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contactInfo(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color.fromARGB(255, 179, 179, 179), size: 24),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Color.fromARGB(255, 117, 117, 117),
                fontSize: 14,
                fontFamily: 'Inter-regular',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
