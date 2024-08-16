import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _username = userDoc['username'];
      });
    }
  }

  void _editUsername() {
    // Implement the logic to edit the username
  }

  void _changePassword() {
    // Implement the logic to change the password
  }

  void _myHistory() {
    // Implement the logic to view the user's history
  }

  void _deleteAccount() {
    // Implement the logic to delete the user's account
  }

  void _logout() {
    // Implement the logic to logout the user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontFamily: 'Inter-semibold',
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
      body: Column(
        children: [
          Container(
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
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  // Handle the tap event here
                },
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icon/profile_boy_1.png',
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _username ?? "Loading...",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontFamily: 'Inter-black',
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 90,
                      right: 0,
                      child: Icon(
                        Icons.autorenew,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: _editUsername,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF0055FF).withOpacity(
                                0.2), // Background color for the circle
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit_rounded,
                            color: Color(0xFF006FFD),
                            size: 28,
                          ), // Icon with a white color
                        ),
                        SizedBox(width: 13),
                        Text(
                          "Edit Username",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Inter-regular',
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF344046)),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: _changePassword,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF0055FF).withOpacity(
                                0.2), // Background color for the circle
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_rounded,
                            color: Color(0xFF006FFD),
                            size: 28,
                          ), // Icon with a white color
                        ),
                        SizedBox(width: 13),
                        Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Inter-regular',
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF344046)),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: _myHistory,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF0055FF).withOpacity(
                                0.2), // Background color for the circle
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.history,
                            color: Color(0xFF006FFD),
                            size: 28,
                          ), // Icon with a white color
                        ),
                        SizedBox(width: 13),
                        Text(
                          "My History",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Inter-regular',
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF344046)),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: _logout,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF0055FF).withOpacity(
                                0.2), // Background color for the circle
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.logout_rounded,
                            color: Color(0xFF006FFD),
                            size: 28,
                          ), // Icon with a white color
                        ),
                        SizedBox(width: 13),
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Inter-regular',
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF344046)),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: _deleteAccount,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 0, 0).withOpacity(
                                0.2), // Background color for the circle
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Color.fromARGB(255, 253, 0, 0),
                            size: 28,
                          ), // Icon with a white color
                        ),
                        SizedBox(width: 13),
                        Text(
                          "Delete Account",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Inter-regular',
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF344046)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
