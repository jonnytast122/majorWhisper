import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:majorwhisper/screens/MyProfile.dart';
import 'package:majorwhisper/screens/Roadmap.dart';
import 'package:majorwhisper/widgets/cateogry_card.dart';
import 'package:majorwhisper/widgets/navbar.dart';
import 'package:majorwhisper/screens/Learning.dart';
import 'package:majorwhisper/screens/Career.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeContent(), // Separate the home content
    Learning(), // Placeholder for Explore screen
    Career(),
    Roadmap(),
    const Center(child: Text('Help')), // Placeholder for Help screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  Future<String?> _getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc['username'] as String?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailMajor(getUsername: _getUsername),
        const Expanded(child: ExploreCategory()),
      ],
    );
  }
}

class DetailMajor extends StatelessWidget {
  final Future<String?> Function() getUsername;

  const DetailMajor({Key? key, required this.getUsername}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      height: 410,
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF006FFD),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.sunny,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "GOOD MORNING",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Inter-regular',
                            ),
                          ),
                        ]),
                    const SizedBox(height: 5),
                    FutureBuilder<String?>(
                      future: getUsername(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Error loading username');
                        } else if (snapshot.hasData) {
                          return Text(
                            "${snapshot.data},",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'Inter-black',
                            ),
                          );
                        } else {
                          return const Text(
                            "John Doe,",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'Inter-medium',
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyProfile()),
                    );
                  },
                  child: Image.asset(
                    'assets/icon/profile_boy_1.png',
                    width: 75,
                    height: 75,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Space between Row and TextFormField
            const Text(
              "Discover Details of Major",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Inter-semibold',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Search Major",
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 18,
                  fontFamily: 'Inter-regular',
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF000000),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFEDEDED),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent Quiz",
                    style: TextStyle(
                      color: Color(0xFF006FFD),
                      fontSize: 20,
                      fontFamily: 'Inter-semibold',
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Complete",
                        style: TextStyle(
                          color: Color(0xFF006FFD),
                          fontSize: 20,
                          fontFamily: 'Inter-semibold',
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.history_rounded,
                            color: Color(0xFF006FFD),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "View History",
                            style: TextStyle(
                              color: Color(0xFF006FFD),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF006FFD),
                              fontSize: 11,
                              fontFamily: 'Inter-semibold',
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExploreCategory extends StatelessWidget {
  const ExploreCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF006FFD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Discover your Future",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Inter-semibold',
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Take the quiz and let us match you \nwith your perfect majors!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Inter-regular',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Button press logic here (currently does nothing)
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Start Quiz',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter-semibold',
                          color: Color(0xFF006FFD),
                        ),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/cloud_illustration.png',
                  width: 150,
                  height: 100,
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Explore Categories",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontFamily: 'Inter-semibold',
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true, // This makes GridView take only the space it needs
            physics: const NeverScrollableScrollPhysics(), // Disables GridView's scrolling
            children: const [
              CategoryCard(
                title: "Business",
                imagePath: "assets/images/business_vector.jpg",
              ),
              CategoryCard(
                title: "Science",
                imagePath: "assets/images/science_vector.jpg",
              ),
              CategoryCard(
                title: "History",
                imagePath: "assets/images/business_vector.jpg",
              ),
              CategoryCard(
                title: "Geography",
                imagePath: "assets/images/business_vector.jpg",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
