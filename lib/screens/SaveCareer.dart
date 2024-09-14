import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:majorwhisper/screens/Home.dart';
import 'package:majorwhisper/screens/SaveCareerDetail.dart';

class SaveCareer extends StatefulWidget {
  @override
  _SaveCareerState createState() => _SaveCareerState();
}

class _SaveCareerState extends State<SaveCareer> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId;
  List<Map<String, dynamic>> careerList = [];

  @override
  void initState() {
    super.initState();
    userId = getCurrentUserUID();
    fetchCareerDetails(); // Start by fetching the career details
  }

  String? getCurrentUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> fetchCareerDetails() async {
    if (userId == null) return;

    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('career_paths').doc(userId).get();

      if (doc.exists) {
        Map<String, dynamic>? data = doc.data();
        if (data != null) {
          List<dynamic> dataList = data['data'] ?? [];
          setState(() {
            careerList = dataList.map((entry) {
              final careerName = entry['major_name'];
              final country = entry['country'] ?? 'Unknown';
              final details = entry['career_path'] ?? {};
              return {
                'career_name': careerName,
                'country': country,
                'details': details,
              };
            }).toList();
          });
        }
      }
    } catch (e) {
      print('Error fetching career details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 22.0),
          child: Text(
            'Saved Career Details',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 25,
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
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: careerList.length,
                    itemBuilder: (context, index) {
                      var careerEntry = careerList[index];
                      String careerName = careerEntry['career_name'];
                      String country = careerEntry['country'];
                      Map<String, dynamic> careerDetail =
                          careerEntry['details'];
                      String imageUrl = careerDetail['image_url'] ?? '';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SaveCareerDetail(
                                majorName: careerName,
                                data: careerDetail,
                                imageUrl: imageUrl,
                                country: country,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF006FFD),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 70.0,
                                height: 70.0,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: imageUrl.isNotEmpty
                                        ? NetworkImage(imageUrl)
                                        : AssetImage(
                                                'assets/icon/profile_holder.png')
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      careerName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Inter-semibold",
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      country,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Inter-regular",
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
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
                                  'assets/icon/arrow.png',
                                  width: 40.0,
                                  height: 30.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
