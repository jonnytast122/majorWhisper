import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:majorwhisper/screens/MyHistory.dart';
import 'package:majorwhisper/screens/MyProfile.dart';
import 'package:majorwhisper/screens/Roadmap.dart';
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
import 'RouteHosting.dart';

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
      CourseGen(), // Placeholder for Explore screen
      University(),
      Chatbot(),
      const MyProfile(),
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
    setState(() {
      _selectedIndex = 4; // Assuming 4 is the index for MyProfile
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
                leading: const Icon(Icons.business_center, color: Color(0xFF006FFD)),
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
        Uri.parse("${RouteHosting.baseUrl}/major-detail"),
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
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: onProfileTap,
                      child: FutureBuilder<String?>(
                        future: getProfile(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              greetingData['icon'],
                              color: Colors.white,
                              size: 15,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              greetingData['greeting'],
                              style: const TextStyle(
                                color: Colors.white,
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
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Inter-black',
                                ),
                              );
                            } else {
                              return const Text(
                                "John Doe,",
                                style: TextStyle(
                                  color: Colors.white,
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
                    Icons
                        .dehaze_rounded, // Use an appropriate icon from Icons or a custom one
                    color: Colors.white,
                  ),
                  iconSize: 35, // Adjust the icon size as needed
                  padding: const EdgeInsets.all(8.0), // Add padding if needed
                ),
              ],
            ),
            const SizedBox(height: 30), // Space between Row and TextFormField
            const Text(
              "Discover and Find Your Future",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Inter-semibold',
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Major",
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 15,
                  fontFamily: 'Inter-regular',
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF000000),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFEDEDED),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 13.0), // Adjust the vertical padding
              ),
              onFieldSubmitted: (value) {
                _fetchDataAndNavigate(context, value);
              },
              onChanged: (value) {
                // Optionally handle input changes
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Button 1
                ElevatedButton(
                  onPressed: () => _showLearningDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(
                        100, 100), // Set uniform size for all buttons
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.school, // Replace with your desired icon
                        color: Color(0xFF006FFD),
                        size: 30,
                      ),
                      SizedBox(height: 8), // Add space between icon and text
                      Text(
                        'Learning\nPath',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF006FFD),
                          fontSize: 12,
                          fontFamily: 'Inter-semibold',
                        ),
                      ),
                    ],
                  ),
                ),
                // Button 2
                ElevatedButton(
                  onPressed: () => _showCareerDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(
                        100, 100), // Set uniform size for all buttons
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.business_center, // Replace with your desired icon
                        color: Color(0xFF006FFD),
                        size: 30,
                      ),
                      SizedBox(height: 8), // Add space between icon and text
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.0, vertical: 4.0),
                        child: Text(
                          'Career\nPath',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF006FFD),
                            fontSize: 12,
                            fontFamily: 'Inter-semibold',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Button 3
                ElevatedButton(
                  onPressed: () => _showRoadmapDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(
                        100, 100), // Set uniform size for all buttons
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assistant, // Replace with your desired icon
                        color: Color(0xFF006FFD),
                        size: 30,
                      ),
                      SizedBox(height: 8), // Add space between icon and text
                      Text(
                        'Generate\nRoadmap',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF006FFD),
                          fontSize: 12,
                          fontFamily: 'Inter-semibold',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
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
                        fontSize: 16,
                        fontFamily: 'Inter-black',
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "take the quiz and let us match\nyou with your perfect majors!",
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
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Start Quiz',
                        style: TextStyle(
                          fontSize: 15,
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
                  height: 110,
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Explore Categories",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
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
                title: "Robotics and Automation",
                imagePath: "assets/images/robotic_vector.jpg",
              ),
              CategoryCard(
                title: "Food Technology",
                imagePath: "assets/images/food_vector.jpg",
              ),
              CategoryCard(
                title: "Ethnic and Philosphy",
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
