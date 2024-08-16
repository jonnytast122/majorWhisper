import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:majorwhisper/screens/auth/Login.dart';

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

  Future<bool?> logoutpopscreen() async {
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
                'Oh No, You are leaving...\n Are you sure?',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Inter-black',
                  color: Color(0xFF2f3036),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Makes buttons full width
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006FFD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize:
                        const Size(double.infinity, 50), // Full width button
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Return true to indicate logout
                  },
                  child: const Text(
                    'Yes, Log me out',
                    style: TextStyle(
                      fontFamily: 'Inter-semibold',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Space between the buttons
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Return false to cancel logout
                  },
                  child: const Text(
                    'Nah, Just Kidding',
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

void _editUsername(BuildContext context) {
    final _newNameController = TextEditingController();
    final _confirmNameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width:
                MediaQuery.of(context).size.width * 0.9, // 80% of screen width
            height: MediaQuery.of(context).size.height *
                0.5, // 40% of screen height
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'Edit Username',
                    style: TextStyle(fontSize: 24, fontFamily: 'Inter-medium'),
                  ),
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'New Name',
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'Inter-medium'),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _newNameController,
                        decoration: InputDecoration(
                          hintText: "Enter Name",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 15,
                            fontFamily: 'Inter-medium'
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFDCEDFF),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Confirm Name',
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'Inter-medium'),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _confirmNameController,
                        decoration: InputDecoration(
                          hintText: "Enter Name",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 15,
                            fontFamily: 'Inter-medium'
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFDCEDFF),
                        ),
                        validator: (value) {
                          if (value != _newNameController.text) {
                            return 'Names do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 4), // Adjust padding as needed
                          decoration: BoxDecoration(
                            color: Colors
                                .red, // Set your desired background color here
                            borderRadius: BorderRadius.circular(
                                8), // Optional: to give rounded corners
                          ),
                          alignment: Alignment
                              .center, // Center the text within the container
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Inter-medium',
                              color: Colors
                                  .white, // Set your desired text color here
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Save the new name in Firestore
                            User? user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .update(
                                      {'username': _newNameController.text});

                              // Close the dialog
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 30), // Adjust padding as needed
                          decoration: BoxDecoration(
                            color: Colors
                                .blue, // Set your desired background color here
                            borderRadius: BorderRadius.circular(
                                8), // Optional: to give rounded corners
                          ),
                          alignment: Alignment
                              .center, // Center the text within the container
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Inter-medium',
                              color: Colors
                                  .white, // Set your desired text color here
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
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

  void _logout() async {
    bool? shouldLogout = await logoutpopscreen();
    if (shouldLogout == true) {
      FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false, // Removes all the routes in the stack
      );
    }
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
                    const Positioned(
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
              onTap: () => _editUsername(context),
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
                          child: const Icon(
                            Icons.logout_rounded,
                            color: Color(0xFF006FFD),
                            size: 28,
                          ), // Icon with a white color
                        ),
                        SizedBox(width: 13),
                        const Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Inter-regular',
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
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
