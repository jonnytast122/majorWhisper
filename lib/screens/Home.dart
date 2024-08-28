import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:majorwhisper/screens/MyProfile.dart';
import 'package:majorwhisper/screens/Roadmap.dart';
import 'package:majorwhisper/widgets/cateogry_card.dart';
import 'package:majorwhisper/widgets/navbar.dart';
import 'package:majorwhisper/screens/Learning.dart';
import 'package:majorwhisper/screens/Career.dart';
import 'package:majorwhisper/screens/Quiz.dart';
import 'package:majorwhisper/screens/MajorDetail.dart';

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

  Future<String?> _getProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc['profile_picture'] as String?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailMajor(getUsername: _getUsername, getProfile: _getProfile),
        const Expanded(child: ExploreCategory()),
      ],
    );
  }
}

class DetailMajor extends StatelessWidget {
  final Future<String?> Function() getUsername;
  final Future<String?> Function() getProfile;
  final TextEditingController _searchController = TextEditingController();

  DetailMajor({Key? key, required this.getUsername, required this.getProfile})
      : super(key: key);

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
            SizedBox(
              height: 50,
            ),
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                      MaterialPageRoute(
                          builder: (context) => const MyProfile()),
                    );
                  },
                  child: FutureBuilder<String?>(
                    future: getProfile(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Loading indicator
                      } else if (snapshot.hasError) {
                        return Image.asset(
                          'assets/icon/profile_holder.png', // Fallback image on error
                          width: 75,
                          height: 75,
                        );
                      } else if (snapshot.hasData) {
                        String? imagePath = snapshot.data;
                        if (imagePath != null) {
                          return Image.asset(
                            imagePath, // Use network image if URL is provided
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Image.asset(
                            'assets/icon/profile_holder.png', // Fallback image if no path is returned
                            width: 75,
                            height: 75,
                          );
                        }
                      } else {
                        return Image.asset(
                          'assets/icon/profile_holder.png', // Fallback image if no data
                          width: 75,
                          height: 75,
                        );
                      }
                    },
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
              controller: _searchController,
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
              onFieldSubmitted: (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Majordetail(majorName: value),
                  ),
                );
              },
              onChanged: (value) {
                // Optionally handle input changes
              },
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
                      fontSize: 18,
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
                          fontSize: 15,
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
                        fontSize: 17,
                        fontFamily: 'Inter-black',
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Take the quiz and let us match you \nwith your perfect majors!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Inter-regular',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        bool? shouldNavigate =
                            await Quizpopscreen(context); // Show the dialog

                        if (shouldNavigate == true) {
                          // Navigate to Quiz if confirmed
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Quiz()),
                          );
                        }
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
                  width: 130,
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
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                title: "Engineering",
                imagePath: "assets/images/engineering_vector.jpg",
              ),
              CategoryCard(
                title: "Art",
                imagePath: "assets/images/art_vector.jpg",
              ),
              CategoryCard(
                title: "Humanity",
                imagePath: "assets/images/humanity_vector.jpg",
              ),
              CategoryCard(
                title: "Technology",
                imagePath: "assets/images/technology_vector.jpg",
              ),
              CategoryCard(
                title: "Natural Science",
                imagePath: "assets/images/natural_science_vector.jpg",
              ),
              CategoryCard(
                title: "Social Science",
                imagePath: "assets/images/social_science_vector.jpg",
              ),
              CategoryCard(
                title: "Education",
                imagePath: "assets/images/education_vector.jpg",
              ),
              CategoryCard(
                title: "Law",
                imagePath: "assets/images/law_vector.jpg",
              ),
              CategoryCard(
                title: "Health Science",
                imagePath: "assets/images/health_science_vector.jpg",
              ),
              CategoryCard(
                title: "Sport Science",
                imagePath: "assets/images/sport_vector.jpg",
              ),
              CategoryCard(
                title: "Agriculture and Environmental ",
                imagePath: "assets/images/agriculture_vector.jpg",
              ),
              CategoryCard(
                title: "Architecture and Design",
                imagePath: "assets/images/architect_vector.jpg",
              ),
              CategoryCard(
                title: "Media and Communication",
                imagePath: "assets/images/media_vector.jpg",
              ),
              CategoryCard(
                title: "Linguistics and Language",
                imagePath: "assets/images/language_vector.jpg",
              ),
              CategoryCard(
                title: "Robotics and Automation",
                imagePath: "assets/images/robotic_vector.jpg",
              ),
              CategoryCard(
                title: "Food Science and Nutrition",
                imagePath: "assets/images/food_vector.jpg",
              ),
              CategoryCard(
                title: "Ethnic and Philosphy",
                imagePath: "assets/images/ethnic_vector.jpg",
              ),
              CategoryCard(
                title: "Religious",
                imagePath: "assets/images/religion_vector.jpg",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<bool?> Quizpopscreen(BuildContext context) {
  return showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logout_illustration.png', // Replace with your image path
                height: 250,
              ),
            ),
            const Text(
              'You\'re about to start the quiz. Are you sure?',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Inter-black',
                color: Color(0xFF2f3036),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'You have to complete 10 questions',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Inter-regular',
                color: Color(0xFF71727A),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006FFD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true); // Return true
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontFamily: 'Inter-semibold',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Return false
                },
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Color(0xFF006FFD),
                    fontFamily: 'Inter-semibold',
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
