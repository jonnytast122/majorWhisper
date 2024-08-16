import 'package:flutter/material.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({Key? key}) : super(key: key);

  @override
  _ResetpasswordState createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
                alignment:
                    Alignment.centerLeft, // Adjust the alignment as needed
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 45.0), // Adjust the padding as needed
                  child: Column(
                    children: [
                      Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'Inter-black',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Create a new password. Ensure it differs from\n previous ones for security',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily:
                              'Inter-regular', // Set the font family here
                          color: Color.fromARGB(255, 137, 137, 137),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
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
                        color: Color(0xFF2f3036)),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Enter your new password',
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
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 183, 184, 190),
                      fontFamily: 'Inter-regular',
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
                  obscureText: _isObscuredPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 16.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Confirm Password',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter-semibold',
                        color: Color(0xFF2f3036)),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Re-enter password',
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
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 183, 184, 190),
                      fontFamily: 'Inter-regular',
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
                  obscureText: _isObscuredConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 28.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Same padding as the TextField
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {}
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF006FFD), // Text color
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: const Text(
                    'Update Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily:
                          'Inter-semibold', // Set the font family for the button text
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
