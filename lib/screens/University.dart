import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majorwhisper/screens/UniversityDetail.dart';

class University extends StatefulWidget {
  @override
  _UniversityState createState() => _UniversityState();
}

class _UniversityState extends State<University> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    // Add a listener to update the search text when typing
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                              controller: _searchController,
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
          // Body section for the list of universities (Fetch from Firestore)
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('universities')
                  .doc('university_list')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error fetching data'));
                }

                if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return Center(child: Text('No data available'));
                }

                final universityData = snapshot.data!.data() as Map<String, dynamic>;
                // Filter universities based on the search text
                final filteredUniversities = universityData.keys.where((universityName) {
                  return universityName
                      .toLowerCase()
                      .contains(_searchText.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filteredUniversities.length,
                  itemBuilder: (context, index) {
                    String universityName = filteredUniversities[index];
                    Map<String, dynamic> universityInfo = universityData[universityName] ?? {};

                    // Fetch address or set default
                    String address = universityInfo['information']?['address'] ?? 'Address not available';
                    
                    // Fetch university logo URL or use placeholder
                    String? universityLogoUrl = universityInfo['university_logo'];
                    String placeholderImage = 'assets/icon/profile_holder.png';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UniversityDetail(
                                universityName: universityName,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: universityLogoUrl != null && universityLogoUrl.isNotEmpty
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
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        universityName, // University name
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Inter-semibold",
                                          color: const Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        address, // University address
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontFamily: "Inter-regular",
                                          color: const Color.fromARGB(255, 117, 117, 117),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
