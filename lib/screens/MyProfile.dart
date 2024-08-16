import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/Home.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontFamily: 'Inter-black',
        ),
        backgroundColor: Color(0xFF006FFD),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(
                context); // Navigates back to the previous screen (HomeScreen)
          },
        ),
      ),
      body: Container(
  child: Container(
    padding: const EdgeInsets.only(top: 0),
    height: 310,
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
      alignment: Alignment.center, // Center the child within the container
      child: GestureDetector(
        onTap: () {
          // Handle the tap event here
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()), // Replace with your target screen
          );
        },
        child: Stack(
          children: [
            Image.asset(
              'assets/icon/profile_boy_1.png', // Replace with your image path
              width: 150, // Adjust size as needed
              height: 150, // Adjust size as needed
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Icon(
                Icons.autorenew, // Replace with your desired icon
                size: 50, // Adjust icon size as needed
                color: Colors.white, // Set icon color
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),

    );
  }
}
