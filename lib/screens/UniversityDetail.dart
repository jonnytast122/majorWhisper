import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/Home.dart';

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
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 50), // Adjusts spacing below the logo
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
                          contactInfo(Icons.place, 'Royal University of Phnom Penh (RUPP) Russian Federation Boulevard, Toul Kork, Phnom Penh, Cambodia.'),
                          contactInfo(Icons.phone, 'Tel: 855-23-883-640/ 855-23-884-154'),
                          contactInfo(Icons.link, 'https://www.facebook.com/rupp.edu.kh'),
                          contactInfo(Icons.link, 'https://www.rupp.edu.kh/'),
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
                  child: Image.asset('assets/images/rupp_logo.png', fit: BoxFit.cover),
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
