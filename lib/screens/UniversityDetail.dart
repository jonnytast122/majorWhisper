import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UniversityDetail extends StatelessWidget {
  final String universityName;

  UniversityDetail({required this.universityName});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String placeholderImage = 'assets/icon/profile_holder.png';

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF006FFD),
          toolbarHeight: 100,
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
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('universities')
              .doc('university_list')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('No data available'));
            }

            var universityData = snapshot.data!.data() as Map<String, dynamic>;
            var universityInfo = universityData[universityName] ?? {};
            String universityLogoUrl = universityInfo['university_logo'] ?? '';
            Map<String, dynamic> faculties = universityInfo['faculty'] ??
                universityInfo['school'] ?? universityInfo['program'] ??
                {}; // Fetch either faculties or schools
            String address = universityInfo['information']?['address'] ??
                'Address not available';
            String phone = universityInfo['information']?['phone_number'] ??
                'Phone number not available';
            String website = universityInfo['information']?['website'] ??
                'Website not available';
            String facebook = universityInfo['information']?['social_media'] ??
                'Facebook not available';

            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: screenHeight * 0.06,
                      decoration: BoxDecoration(
                        color: Color(0xFF006FFD),
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(30.0)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 50),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 86.0),
                                child: Text(
                                  universityName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'Inter-bold',
                                  ),
                                ),
                              ),
                              contactInfo(Icons.place, address),
                              contactInfo(Icons.phone, phone),
                              contactInfo(Icons.link, website),
                              contactInfo(Icons.link, facebook),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 26.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: faculties.keys.length,
                                      itemBuilder: (context, index) {
                                        // Get faculty name (key) and majors (value)
                                        String facultyName =
                                            faculties.keys.elementAt(index);
                                        List<dynamic> majors =
                                            faculties[facultyName] ?? [];

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                facultyName, // Display faculty/school name
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontFamily: 'Inter-medium',
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              // Display majors in a GridView
                                              Container(
                                                child: GridView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap:
                                                      true, // Ensures the GridView takes only the needed height
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 8.0,
                                                    mainAxisSpacing: 8.0,
                                                    childAspectRatio: 3.0,
                                                  ),
                                                  itemCount: majors.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        51,
                                                                        115,
                                                                        255)
                                                                .withOpacity(
                                                                    0.1),
                                                            spreadRadius: 2,
                                                            blurRadius: 2,
                                                            offset:
                                                                Offset(0, 1),
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
                                                          SizedBox(width: 8),
                                                          Expanded(
                                                            child: Text(
                                                              majors[index] ??
                                                                  'Unknown Major',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Inter-bold',
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
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
                  top: screenHeight * 0.08 - 70,
                  left: (screenWidth - 100) / 2,
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: universityLogoUrl.isNotEmpty
                          ? Image.network(
                              universityLogoUrl,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              placeholderImage,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
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
          Icon(icon, color: Color(0xFFB3B3B3), size: 24),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Color(0xFF757575),
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
