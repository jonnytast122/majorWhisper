import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/Onboarding.dart'; 
import 'package:majorwhisper/screens/Home.dart'; // Correct import for OnboardingScreen
import 'package:majorwhisper/screens/auth/Login.dart';
// Correct import for OnboardingScreen
// import 'package:major_whisper/screens/auth/Registration.dart';
import 'package:majorwhisper/screens/auth/Signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:majorwhisper/screens/MyProfile.dart';
import 'package:majorwhisper/screens/Learning.dart';
import 'package:majorwhisper/screens/Career.dart';
import 'package:majorwhisper/screens/Quiz.dart';
import 'package:majorwhisper/screens/Listmajors.dart';
import 'package:majorwhisper/screens/Quiz_Finished.dart';

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
      home:  Quiz(), // Use OnboardingScreen instead of Onboarding
      // home: const Registration(), // Use Registration instead of Onboarding
    );
  }
}
