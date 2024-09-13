import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/CareerResult.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

class Career extends StatefulWidget {
  @override
  _CareerState createState() => _CareerState();
}

class _CareerState extends State<Career> {
  String selectedCountry = 'Cambodia'; // Default selected button
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25), // Adjust radius if needed
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF006FFD),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: 800,
          // Adjust this value to fit your content
        ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Ensures dialog size fits content

            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(
                    left: 10.0), // Adjust the left padding as needed
                child: Text(
                  "Uncover Your Career Path",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter-semibold',
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "Search and see where your future leads!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter-regular',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search Major",
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 14,
                    fontFamily: 'Inter-regular',
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF000000),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(
                        right:
                            10), // Move the entire IconButton, not just the icon
                    child: IconButton(
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Color(0xFF000000),
                        size: 20, // Adjust icon size if needed
                      ),
                      onPressed: () {
                        // Add the action you want to perform when the send icon is pressed
                        _search(_searchController.text, selectedCountry);
                      },
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFEDEDED),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),

                ),
                onFieldSubmitted: (value) => _search(value, selectedCountry),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "Country",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter-semibold',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Aligns the buttons to the left
                children: [
                  buildCountryButton('Cambodia'),
                  SizedBox(width: 10), // Add some space between buttons
                  buildCountryButton('Global'),
                ],
              ),
            ],
          ),
        ),
      );
}

  Widget buildCountryButton(String country) {
    final isSelected = selectedCountry == country;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCountry = country; // Update the selected country
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        country,
        style: TextStyle(
          color: isSelected ? Color(0xFF006FFD) : Colors.white,
          fontSize: 12,
          fontFamily: 'Inter-semibold',
        ),
      ),
    );
  }

 Future<Map<String, dynamic>> fetchCareerPath(String majorName, String country) async {
    try {
      final String url = "http://192.168.1.5:5000/";
      final String api = url + "career-path-" + country.toLowerCase();
      print("api : " + api);
      final response = await http.post(
        Uri.parse(api),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'career_name': majorName,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed to load Career path'
        }; // Error message if API call fails
      }
    } catch (e) {
      return {
        'error': 'An error occurred'
      }; // Error message if exception occurs
    }
  }

void _search(String majorName, String country) async {
    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/icon/learning_loading.json', // Path to your Lottie animation file
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 20),
                Text(
                  'Career Path is Generating\nAlmost Ready!',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter-semibold',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Fetch data
    try {
      final data = await fetchCareerPath(majorName, country);

      // Dismiss the loading dialog
      Navigator.of(context).pop();

      // Check if data is empty or contains errors
      if (data.containsKey('error')) {
        // Show error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(data['error']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the error dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
        return; // Exit if there was an error
      }

      // Navigate to LearningResult with fetched data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CareerResult(
            majorName: majorName,
            country: country,
            data: data,
          ),
        ),
      );
    } catch (e) {
      // Handle any unexpected exceptions
      Navigator.of(context).pop(); // Dismiss the loading dialog

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An unexpected error occurred: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the error dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

}
