import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/auth/Login.dart'; // Import the Registration screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        fontFamily: 'Inter',
        primarySwatch: Colors.blue,
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: const [
                OnboardingPage(
                  imagePath: 'assets/images/Discover.png',
                  title: 'Discover Your \nPassion',
                  subtitle: 'Start your journey with a quiz that\nreveals your passions and strengths.\n Major Whisper helps you find the\n major that excites you most!',
                ),
                OnboardingPage(
                  imagePath: 'assets/images/Recommendation.png',
                  title: 'Tailored \nRecommendation',
                  subtitle: 'Receive AI-powered major\nrecommendations, personalized\nlearning paths, and career insights—\ncustomized just for you.',
                ),
                OnboardingPage(
                  imagePath: 'assets/images/Guidance.png',
                  title: 'Navigate Your \nFuture',
                  subtitle: 'Get real-time career insights and\nguidance. Stay ahead with up-to-date\njob market trends and expert support\nfrom our AI assistant.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 116),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 8,
                width: currentIndex == index ? 16 : 8,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? const Color(0xFF006FFD)
                      : const Color(0xFFBDBDBD),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 400, // Makes the button as wide as the screen
            child: ElevatedButton(
              onPressed: () {
                if (currentIndex < 2) {
                  // Move to the next page
                  _pageController.animateToPage(
                    currentIndex + 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // Navigate to the Registration screen when on the last page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006FFD),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 223, 223, 223),
                  fontFamily: 'Inter-semibold',
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              // Navigate to the Registration screen when Skip is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color.fromARGB(255, 121, 121, 121),
                fontSize: 18,
                fontFamily: 'inter-medium',
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 148),
          Image.asset(
            imagePath,
            height: 300,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 34,
              fontFamily: 'Inter-black',
              fontWeight: FontWeight.w900,
              color: Color(0xFF006FFD),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Inter-regular',
              color: Color.fromARGB(255, 116, 116, 116),
            ),
          ),
        ],
      ),
    );
  }
}
