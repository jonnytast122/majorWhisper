import 'package:flutter/material.dart';

class University extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Static list of university names and locations
    final universityData = [
      {
        'name': 'Royal University of Phnom Penh',
        'location':
            'Royal University of Phnom Penh (RUPP) Russian Federation Boulevard, Toul Kork, Phnom Penh, Cambodia. Tel: 855-23-883-640',
        'image': 'assets/images/rupp_logo.png',
      },
      {
        'name': 'Cambodia Academy of Digital Technology',
        'location':
            'Bridge 2, National Road 6A, Sangkat Prek Leap, Khan Chroy Changva, Phnom Penh',
        'image': 'assets/images/cadt_logo.png',
      }
    ];

    return Scaffold(
      body: Column(
        children: [
          // Top half (blue with bottom radius and search bar)
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30.0),
            ),
            child: Container(
              color: Color(0xFF006FFD),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.26,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Center(
                        child: Text(
                          'University',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: "Inter-semibold",
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Discover Popular University',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Inter-semibold",
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Search University',
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Body section for the list of universities (Static Information)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: ListView.builder(
                itemCount:
                    universityData.length, // Use the length of universityData
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0), // Padding around the container
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to quiz history or desired page
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Image.asset(
                                universityData[index]
                                    ['image']!, // Static image asset
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      universityData[index]
                                          ['name']!, // University name
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Inter-semibold",
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      universityData[index]
                                          ['location']!, // University location
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontFamily: "Inter-regular",
                                        color: const Color.fromARGB(
                                            255, 117, 117, 117),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Handle button press here
                              },
                              child: Image.asset(
                                'assets/icon/arrow.png', // Path to your custom icon
                                width: 40.0,
                                height: 30.0,
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
          ),
        ],
      ),
    );
  }
}
