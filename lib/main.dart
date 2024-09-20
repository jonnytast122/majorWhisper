import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/Chatbot.dart';
import 'package:majorwhisper/screens/CourseDetail.dart';
import 'package:majorwhisper/screens/CourseLayout.dart';
import 'package:majorwhisper/screens/CourseGen.dart';
import 'package:majorwhisper/screens/CreateCourse.dart';
import 'package:majorwhisper/screens/MyHistory.dart';
import 'package:majorwhisper/screens/Onboarding.dart'; 
import 'package:majorwhisper/screens/Home.dart'; // Correct import for OnboardingScreen
import 'package:majorwhisper/screens/RecommendedMajorHistory.dart';
import 'package:majorwhisper/screens/University.dart';
import 'package:majorwhisper/screens/UniversityDetail.dart';
import 'package:majorwhisper/screens/auth/Login.dart';
import 'package:majorwhisper/screens/auth/Signup.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Major Whisper',
      theme: ThemeData(
        fontFamily: 'Inter',
        primarySwatch: Colors.blue,
      ),
      home:  Home(), // Use OnboardingScreen instead of Onboarding
      // home: const Registration(), // Use Registration instead of Onboarding
    );
  }
}
 