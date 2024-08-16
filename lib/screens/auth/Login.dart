import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:majorwhisper/screens/Home.dart';
import 'package:majorwhisper/screens/auth/Signup.dart';
import 'package:majorwhisper/screens/auth/Forgetpassword.dart';
import 'package:majorwhisper/screens/Home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;
  bool _isChecked = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
              Center(
                child: Image.asset(
                  'assets/images/login_illustration.png', // Replace with your image path
                  height: 300,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Welcome!',
                    style: TextStyle(fontSize: 28, fontFamily: 'Inter-black'),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email Address',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter-semibold',
                        color: Color(0xFF2f3036)),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'name@email.com',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 183, 184, 190),
                      fontFamily: 'Inter-regular',
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide:
                          BorderSide(color: Color(0xFF006FFD), width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide:
                          BorderSide(color: Color(0xFFC5C6CC), width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter-semibold',
                        color: Color(0xFF2f3036)),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFFC5C6CC),
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 183, 184, 190),
                      fontFamily: 'Inter',
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide:
                          BorderSide(color: Color(0xFF006FFD), width: 1.5),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide:
                          BorderSide(color: Color(0xFFC5C6CC), width: 1.5),
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Inter-regular',
                  ),
                ),
              ),
              Row(
                children: [
                  // "Forgot password?" button on the left
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Forgetpassword()),
                        );
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Color(0xFF006FFD),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter-semibold',
                        ),
                      ),
                    ),
                  ),

                  // Spacer to push "Remember me" to the right
                  const Spacer(),

                  // "Remember me" with a checkbox
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Aligns checkbox and text vertically
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 6.0), // Space between checkbox and text
                        child: Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF006FFD),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-14.0,
                            0.0), // Adjust offset to move text left or right
                        child: const Text(
                          'Remember me',
                          style: TextStyle(
                            color: Color(0xFF006FFD),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter-semibold',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF006FFD),
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inter-semibold',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Doesn't have an account?",
                    style: TextStyle(
                      fontFamily: 'Inter-semibold',
                      color: Color.fromARGB(255, 163, 163, 163),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                      );
                    },
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: Color(0xFF006FFD),
                        fontSize: 14,
                        fontFamily: 'Inter-semibold',
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Color.fromARGB(255, 218, 218, 218),
                thickness: 1.5,
                indent: 15.0,
                endIndent: 15.0,
              ),
              const SizedBox(height: 10.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Or continue with",
                    style: TextStyle(
                      fontFamily: 'Inter-regular',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color.fromARGB(255, 163, 163, 163),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: _signInWithGoogle,
                    child: Image.asset(
                      'assets/icon/google_logo.png',
                      height: 60.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        if (!user.emailVerified) {
          await _auth.signOut();
          Fluttertoast.showToast(
            msg: "Email not verified. Please check your inbox.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          await _saveUserDataToFirestore(user);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home()), // Replace with your home screen
          );
        }
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "An error occurred. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _saveUserDataToFirestore(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    await userDoc.set({
      'uid': user.uid,
      'email': user.email,
      'username': user.displayName,
      'photoURL': user.photoURL,
      'lastSignIn': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _login() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        Fluttertoast.showToast(
          msg: "Email not verified. Please check your inbox.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Navigate to the home screen if the email is verified
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home()), // Replace with your home screen
        );
      }
    } catch (e) {
      String errorMessage;

      if (e is FirebaseAuthException) {
        print(
            'FirebaseAuthException code: ${e.code}'); // Print the error code for debugging
        switch (e.code) {
          case 'invalid-credential':
            errorMessage = "Your email or password is incorrect.";
            break;
          default:
            errorMessage = "An error occurred. Please try again.";
        }
      } else {
        errorMessage = "An error occurred. Please try again.";
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
