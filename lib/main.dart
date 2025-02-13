import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/Chatbot.dart';
import 'package:majorwhisper/screens/CourseDetail.dart';
import 'package:majorwhisper/screens/CourseLayout.dart';
import 'package:majorwhisper/screens/CourseGen.dart';
import 'package:majorwhisper/screens/CreateCourse.dart';
import 'package:majorwhisper/screens/MyHistory.dart';
import 'package:majorwhisper/screens/Onboarding.dart'; 
import 'package:majorwhisper/screens/Home.dart'; 
import 'package:majorwhisper/screens/RecommendedMajorHistory.dart';
import 'package:majorwhisper/screens/University.dart';
import 'package:majorwhisper/screens/UniversityDetail.dart';
import 'package:majorwhisper/screens/auth/Login.dart';
import 'package:majorwhisper/screens/auth/Signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:majorwhisper/screens/test.dart';
import 'package:majorwhisper/screens/MajorRecommendation.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setStatusBarStyle();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _setStatusBarStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent background
        statusBarIconBrightness: Brightness.dark, // Dark icons
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reapply the status bar style when the app resumes
      _setStatusBarStyle();
    }
  }

  @override
  @override
  Future<bool> didPushRoute(String route) async {
    // Reapply the status bar style when a new route is pushed
    _setStatusBarStyle();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Major Whisper',
      theme: ThemeData(
        fontFamily: 'Inter',
        primarySwatch: Colors.blue,
      ),
      home: Onboarding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
