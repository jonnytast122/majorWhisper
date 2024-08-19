import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majorwhisper/screens/auth/Login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;
  bool _isChecked = false;
  bool _isCheckboxValid = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _showEmailVerificationDialog() async {
    return showDialog<void>(
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
                  'assets/images/verification_illustration.png', // Replace with your image path
                  height: 250,
                ),
              ),
              const Text(
                'Verify your email\n before we send the code',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Inter-black',
                  color: Color(0xFF2f3036),
                ),
                textAlign: TextAlign.center,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Inter-regular',
                    fontSize: 16,
                    color: Color.fromARGB(255, 138, 138, 138),
                  ),
                  children: [
                    const TextSpan(text: 'Is this correct? '),
                    TextSpan(
                      text: _emailController.text,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Inter-regular',
                        color: Color.fromARGB(255, 138, 138, 138),
                      ),
                    ),
                  ],
                ),
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
                  onPressed: () async {
                    Navigator.of(context).pop();
                    
                    Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Login()),
                      );
                    await _sendVerificationEmail();
                  },
                  child: const Text(
                    'YES',
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
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'NO',
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

  Future<void> _sendVerificationEmail() async {
  try {
    // Register user with Firebase Authentication
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    // Get the newly registered user
    User? user = userCredential.user;

    if (user != null) {
      // Send email verification
      await user.sendEmailVerification();

      // Reference to the user's Firestore document
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Get the user document
      DocumentSnapshot docSnapshot = await userDoc.get();

      // If the document doesn't exist, it means it's the first login
      if (!docSnapshot.exists) {
        // Define the list of image paths
        List<String> imagePaths = [
          'assets/icon/profile_boy_1.png',
          'assets/icon/profile_boy_2.png',
          'assets/icon/profile_girl_1.png',
          'assets/icon/profile_girl_2.png'
        ];

        // Randomly select an image path
        String randomImagePath =
            imagePaths[Random().nextInt(imagePaths.length)];

        // Save user information along with the random profile picture to Firestore
        await userDoc.set({
          'uid': user.uid,
          'username': _usernameController.text,
          'email': _emailController.text,
          'profile_picture': randomImagePath, // Save the random image path
        });
      }
    }
  } catch (e) {
    // Handle registration error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Inter-black',
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Create an account to get started',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter-regular',
                      color: Color.fromARGB(255, 137, 137, 137),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/images/sign_up_illustration.png', // Replace with your image path
                  height: 275,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Username Header
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter-semibold',
                            color: Color(0xFF2f3036),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Enter your username',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 183, 184, 190),
                            fontFamily: 'Inter-regular',
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(
                                color: Color(0xFF006FFD), width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(
                                color: Color(0xFFC5C6C8), width: 1.5),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Email Header
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter-semibold',
                            color: Color(0xFF2f3036),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Enter your email',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 183, 184, 190),
                            fontFamily: 'Inter-regular',
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(
                                color: Color(0xFF006FFD), width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(
                                color: Color(0xFFC5C6C8), width: 1.5),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Password Header
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter-semibold',
                            color: Color(0xFF2f3036),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscuredPassword,
                        decoration: InputDecoration(
                          labelText: 'Enter your password',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 183, 184, 190),
                            fontFamily: 'Inter-regular',
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(
                                color: Color(0xFF006FFD), width: 1.5),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(
                                color: Color(0xFFC5C6C8), width: 1.5),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscuredPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFFC5C6CC),
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscuredPassword = !_isObscuredPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Confirm Password Header
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter-semibold',
                            color: Color(0xFF2f3036),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _isObscuredConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Re-enter your password',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 183, 184, 190),
                            fontFamily: 'Inter-regular',
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(
                                color: Color(0xFF006FFD), width: 1.5),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(
                                color: Color(0xFFC5C6C8), width: 1.5),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscuredConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFFC5C6CC),
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscuredConfirmPassword =
                                    !_isObscuredConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Transform.scale(
                            scale:
                                1.5, // Adjust the scale factor to make the checkbox bigger
                            child: Checkbox(
                              value: _isChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked = value ?? false;
                                  _isCheckboxValid =
                                      true; // Reset validation flag on change
                                });
                              },
                              checkColor:
                                  Colors.white, // Checkmark color when checked
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return const Color.fromARGB(
                                        255, 79, 96, 249); // Color when checked
                                  }
                                  return _isCheckboxValid
                                      ? const Color.fromARGB(255, 226, 226,
                                          226) // Color when unchecked and valid
                                      : Colors
                                          .red; // Color when unchecked and invalid
                                },
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(4), // Border radius
                              ),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "I've read and agree to the ",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 148, 148, 148),
                                      fontSize: 15,
                                      fontFamily: 'Inter-regular',
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Terms and Conditions ",
                                    style: const TextStyle(
                                      color: Color(0xFF006FFD),
                                      fontSize: 15,
                                      fontFamily: 'Inter-semibold',
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Add the action you want to perform on clicking Terms and Conditions
                                      },
                                  ),
                                  const TextSpan(
                                    text: "and the ",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 148, 148, 148),
                                      fontSize: 15,
                                      fontFamily: 'Inter-regular',
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: const TextStyle(
                                      color: Color(0xFF006FFD),
                                      fontSize: 15,
                                      fontFamily: 'Inter-semibold',
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Add the action you want to perform on clicking Privacy Policy
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!_isCheckboxValid)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'You must agree to the Privacy Policy and Terms & Conditions',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontFamily: 'Inter-regular',
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006FFD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_isChecked) {
                              _showEmailVerificationDialog();
                            } else {
                              setState(() {
                                _isCheckboxValid = false;
                              });
                            }
                          }
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Inter-semibold',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
