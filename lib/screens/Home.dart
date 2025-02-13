import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:majorwhisper/screens/MyHistory.dart';
import 'package:majorwhisper/screens/MyProfile.dart';
import 'package:majorwhisper/screens/Roadmap.dart';
import 'package:majorwhisper/screens/auth/Login.dart';
import 'package:majorwhisper/widgets/cateogry_card.dart';
import 'package:majorwhisper/widgets/navbar.dart';
import 'package:majorwhisper/screens/Learning.dart';
import 'package:majorwhisper/screens/Career.dart';
import 'package:majorwhisper/screens/Quiz.dart';
import 'package:majorwhisper/screens/MajorDetail.dart';
import 'package:majorwhisper/screens/Chatbot.dart';
import 'package:lottie/lottie.dart';
import 'package:majorwhisper/screens/SaveMajor.dart';
import 'package:majorwhisper/screens/CourseGen.dart';
import 'package:majorwhisper/screens/SaveCareer.dart';
import 'package:majorwhisper/screens/SaveLearning.dart';
import 'package:majorwhisper/screens/University.dart';
import 'routes/RouteHosting.dart';
import 'package:majorwhisper/screens/Explore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeContent(
          navigateToProfile: _navigateToProfile), // Separate the home content
      const Explore(), // Placeholder for Explore screen
      University(),
      Chatbot(),
    ];
  }

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToProfile() {
    MyProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key, required this.navigateToProfile});

  final void Function() navigateToProfile;

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
        DetailMajor(
          getUsername: _getUsername,
          getProfile: _getProfile,
          onProfileTap: navigateToProfile,
        ),
        const Expanded(child: ExploreCategory()),
      ],
    );
  }
}

class DetailMajor extends StatelessWidget {
  final Future<String?> Function() getUsername;
  final Future<String?> Function() getProfile;
  final void Function() onProfileTap;
  final TextEditingController _searchController = TextEditingController();

  DetailMajor(
      {super.key,
      required this.getUsername,
      required this.getProfile,
      required this.onProfileTap});

  void _showOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows for scrollable content if needed
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(15)), // Smaller radius
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.history, color: Color(0xFF006FFD)),
                title: const Text('Quiz History'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  // Handle Quiz History option tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Myhistory()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark, color: Color(0xFF006FFD)),
                title: const Text('Saved Major Detail'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SaveMajor()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.school, color: Color(0xFF006FFD)),
                title: const Text('Saved Learning Path'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SaveLearning()),
                  );
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.business_center, color: Color(0xFF006FFD)),
                title: const Text('Saved Career Path'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  // Handle Saved Career Path option tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SaveCareer()),
                  );
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.logout_rounded, color: Color(0xFF006FFD)),
                title: const Text('Sign out'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  // Handle Saved Career Path option tap
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Login()), // Replace `HomeScreen()` with your actual home screen widget
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLearningDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissal by tapping outside
      builder: (BuildContext context) {
        return Learning(); // Your Learning dialog widget
      },
    );
  }

  void _showCareerDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissal by tapping outside
      builder: (BuildContext context) {
        return Career(); // Your Learning dialog widget
      },
    );
  }

  void _showRoadmapDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissal by tapping outside
      builder: (BuildContext context) {
        return Roadmap(); // Your Learning dialog widget
      },
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/icon/learning_loading.json', // Path to your Lottie animation file
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Major Detail is Generating\nAlmost Ready!',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter-semibold',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _fetchDataAndNavigate(BuildContext context, String majorName) async {
    _showLoadingDialog(context);

    try {
      final response = await http.post(
        Uri.parse("${RouteHosting.baseUrl}major-detail"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'major_name': majorName,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Navigator.of(context).pop(); // Close the loading dialog
        // print("data: " + data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Majordetail(
              majorName: majorName,
              data: data, // Pass data to Majordetail
            ),
          ),
        );
      } else {
        Navigator.of(context).pop(); // Close the loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load data')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  Map<String, dynamic> getTimeBasedGreeting() {
    // Get the current hour
    final hour = DateTime.now().hour;
    print(hour);
    // Determine the greeting and icon based on the time of day
    String greeting;
    IconData greetingIcon;

    if (hour >= 5 && hour < 12) {
      greeting = "GOOD MORNING";
      greetingIcon = Icons.wb_sunny;
    } else if (hour >= 12 && hour < 17) {
      greeting = "GOOD AFTERNOON";
      greetingIcon = Icons.wb_sunny_outlined;
    } else if (hour >= 17 && hour < 20) {
      greeting = "GOOD EVENING";
      greetingIcon = Icons.nights_stay;
    } else {
      greeting = "GOOD NIGHT";
      greetingIcon = Icons.bedtime;
    }

    // Return the greeting text and icon
    return {
      'greeting': greeting,
      'icon': greetingIcon,
    };
  }

  @override
  Widget build(BuildContext context) {
    final greetingData = getTimeBasedGreeting();
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // Profile and Name Holder
        Column(
          children: [
            const SizedBox(height: 60), // Adjust profile position downward
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onProfileTap,
                        child: FutureBuilder<String?>(
                          future: getProfile(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Image.asset(
                                'assets/icon/profile_holder.png',
                                width: 75,
                                height: 75,
                              );
                            } else if (snapshot.hasData) {
                              String? imagePath = snapshot.data;
                              return Image.asset(
                                imagePath ?? 'assets/icon/profile_holder.png',
                                width: 75,
                                height: 75,
                                fit: BoxFit.cover,
                              );
                            } else {
                              return Image.asset(
                                'assets/icon/profile_holder.png',
                                width: 75,
                                height: 75,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                greetingData['icon'],
                                color: Colors.black,
                                size: 15,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                greetingData['greeting'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'Inter-regular',
                                ),
                              ),
                            ],
                          ),
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
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Inter-black',
                                  ),
                                );
                              } else {
                                return const Text(
                                  "John Doe,",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Inter-medium',
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _showOptionsDialog(context),
                    icon: const Icon(
                      Icons.dehaze_rounded,
                      color: Colors.black,
                    ),
                    iconSize: 35,
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 16), // Controlled spacing before the blue container
          ],
        ),
        // Blue Background Container

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF006FFD),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Discover and \nFind Your Future",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    screenWidth * 0.05, // Responsive font size
                                fontFamily: 'Inter-bold',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Take the quiz and let us match you with your perfect majors!",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 207, 207, 207),
                                fontSize:
                                    screenWidth * 0.03, // Responsive font size
                                fontFamily: 'Inter-regular',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/start_quiz.png',
                      width: screenWidth * 0.4, // Responsive image width
                      height: screenWidth * 0.4, // Responsive image height
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      String? selectedLevel =
                          await showLevelSelectionDialog(context);
                      if (selectedLevel != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Quiz(level: selectedLevel)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Start Quiz',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // Responsive font size
                        fontFamily: 'Inter-bold',
                        color: const Color(0xFF006FFD),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ExploreCategory extends StatelessWidget {
  const ExploreCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explore Categories',
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'Inter-bold',
              color: Color(0xFF2f3036),
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 20,
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
                title: "Agriculture ",
                imagePath: "assets/images/agriculture_vector.jpg",
              ),
              CategoryCard(
                title: "Architecture",
                imagePath: "assets/images/architect_vector.jpg",
              ),
              CategoryCard(
                title: "Media",
                imagePath: "assets/images/media_vector.jpg",
              ),
              CategoryCard(
                title: "Linguistics",
                imagePath: "assets/images/language_vector.jpg",
              ),
              CategoryCard(
                title: "Robotics",
                imagePath: "assets/images/robotic_vector.jpg",
              ),
              CategoryCard(
                title: "Food Technology",
                imagePath: "assets/images/food_vector.jpg",
              ),
              CategoryCard(
                title: "Philosphy",
                imagePath: "assets/images/ethnic_vector.jpg",
              ),
              CategoryCard(
                title: "Religious Studies",
                imagePath: "assets/images/religion_vector.jpg",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
 
Future<String?> showLevelSelectionDialog(BuildContext context) async {
  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please choose the answer that best describes you",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, "high-school");
                },
                child: Container(
                  width: 300,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    children: [
                      Text("High School",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 15),
                      Image.asset("assets/images/highschool.png", height: 70),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, "university");
                },
                child: Container(
                  width: 300,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    children: [
                      Text("University",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Image.asset("assets/images/university.png", height: 70),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
