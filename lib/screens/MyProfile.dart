import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:majorwhisper/screens/auth/Login.dart';
import 'package:majorwhisper/screens/MyHistory.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String? _username;
  String _profileImage = 'assets/icon/profile_holder.png'; // Default path

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
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          _username = userDoc['username'] ?? 'Unknown User';
          _profileImage =
              userDoc['profile_picture'] ?? 'assets/icon/profile_holder.png';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _profileImage = 'assets/icon/profile_holder.png'; // Fallback image
      });
    }
  }

  Future<void> _editUsername(BuildContext context) async {
  final _newNameController = TextEditingController();
  final _confirmNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Show the dialog and wait for user action
  bool? usernameUpdated = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
          height: MediaQuery.of(context).size.height * 0.5, // 50% of screen height
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  'Edit Username',
                  style: TextStyle(fontSize: 24, fontFamily: 'Inter-regular'),
                ),
              ),
              const SizedBox(height: 30),
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
                            fontFamily: 'Inter-medium'),
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
                            fontFamily: 'Inter-medium'),
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
                        Navigator.of(context).pop(false); // Pass false to indicate cancel
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Inter-medium',
                            color: Colors.white,
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
                          // Save the new username in Firestore
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .update({'username': _newNameController.text});

                            Navigator.of(context).pop(true); // Pass true to indicate success
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
                        padding: EdgeInsets.symmetric(vertical: 7),
                        alignment: Alignment.center,
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Inter-medium',
                            color: Colors.white,
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

  // Only update the username if the dialog indicates success
  if (usernameUpdated == true) {
    await _getUsername(); // Fetch updated user data
  }
}


  void _changePassword(BuildContext context) {
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _isPasswordVisible = false;
    bool _isConfirmPasswordVisible = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                width: screenWidth * 0.9,
                height: screenHeight * 0.5,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                              fontSize: 24, fontFamily: 'Inter-semibold'),
                        ),
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'New Password',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'Inter-medium'),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: _newPasswordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: "Enter Password",
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 15,
                                  fontFamily: 'Inter-medium',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFDCEDFF),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a new password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Confirm Password',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'Inter-medium'),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 15,
                                  fontFamily: 'Inter-medium',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFDCEDFF),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value != _newPasswordController.text) {
                                  return 'Passwords do not match';
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
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Inter-medium',
                                    color: Colors.white,
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
                                  // Save the new password in Firestore or Firebase Auth
                                  User? user =
                                      FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    await user.updatePassword(
                                        _newPasswordController.text);

                                    // Close the dialog
                                    Navigator.of(context).pop();

                                    // Optionally show a success message or update UI
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Password updated successfully!'),
                                      ),
                                    );
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
                                    vertical: 7),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Inter-medium',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _myHistory() {
    // Implement the logic to view the user's history
  }

  void _deleteAccount(BuildContext context) {
    showDialog(
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
                'Once it\'s gone, it\'s gone\n Are you sure?',
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
                    backgroundColor: const Color.fromARGB(255, 253, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize:
                        const Size(double.infinity, 50), // Full width button
                  ),
                  onPressed: () async {
                    // Retrieve the current user
                    User? user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      try {
                        // Delete the user's document from Firestore
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .delete();

                        // Delete the user's authentication record
                        await FirebaseAuth.instance.currentUser!.delete();
                        
                        // Navigate back to the login screen
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                          (Route<dynamic> route) => false, // Clear all previous routes
                        );
                      } catch (e) {
                        // Handle errors (e.g., re-authentication needed)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Error deleting account: ${e.toString()}'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Yes, Delete my Account',
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
                    Navigator.of(context).pop(false); // Close the dialog
                  },
                  child: const Text(
                    'Just kidding, let\'s stay.',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
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

  Future<void> _changeProfile(BuildContext context) async {
    String? selectedProfile;

    bool? profileUpdated = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'Select Profile Picture',
                    style: TextStyle(fontSize: 22, fontFamily: 'Inter-medium'),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      List<String> imagePaths = [
                        'assets/icon/profile_boy_1.png',
                        'assets/icon/profile_boy_2.png',
                        'assets/icon/profile_girl_1.png',
                        'assets/icon/profile_girl_2.png'
                      ];

                      return GestureDetector(
                        onTap: () {
                          selectedProfile = imagePaths[index];
                          (context as Element).markNeedsBuild();
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selectedProfile == imagePaths[index]
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.transparent,
                            border: Border.all(
                              color: selectedProfile == imagePaths[index]
                                  ? Colors.blue
                                  : Colors.transparent,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(imagePaths[index]),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedProfile != null) {
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({'profile_picture': selectedProfile});
                        Navigator.of(context)
                            .pop(true); // Pass a result indicating success
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Please select a profile picture.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 30),
                    alignment: Alignment.center,
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Inter-medium',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Only update the profile if the dialog indicates success
    if (profileUpdated == true) {
      await _getUsername(); // Fetch updated user data
    }
  }

  // Move it down a little bit
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Adjust the height of the AppBar
        child: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(
                top: 22.0), // Adjust this value to move the title down
            child: Text(
              'My Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: 'Inter-semibold',
              ),
            ),
          ),
          backgroundColor: Color(0xFF006FFD),
          leading: Padding(
            padding: const EdgeInsets.only(
                top: 21.0), // Adjust this value to move the back arrow down
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context); // Navigates back to the previous screen
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 0),
            height: 270,
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
                onTap: () async {
                  // Call functions and wait for them to complete
                  _changeProfile(context);
                },
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          _profileImage,
                          width: 130,
                          height: 130,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _username ?? "Loading...",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontFamily: 'Inter-black',
                          ),
                        ),
                      ],
                    ),
                    const Positioned(
                      bottom: 80,
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
              onTap: () => _changePassword(context),
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
              onTap: () {
                      // Handle button press here
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Myhistory()),
                      );
                    },
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
              onTap: () => _deleteAccount(context),
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
