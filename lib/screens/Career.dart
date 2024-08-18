import 'package:flutter/material.dart';

class Career extends StatefulWidget {
  @override
  _CareerState createState() => _CareerState();
}

class _CareerState extends State<Career> {
  String selectedCountry = 'Cambodia'; // Default selected button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 0),
        height: 370,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              const Padding(
                padding: EdgeInsets.only(
                    left: 10.0), // Adjust the left padding as needed
                child: Text(
                  "Uncover Your Career Path",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Inter-semibold',
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "Search and see where your future\nleads!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter-regular',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Search Major",
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 18,
                    fontFamily: 'Inter-regular',
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF000000),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFEDEDED),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "Country",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
                  buildCountryButton('General'),
                ],
              ),
            ],
          ),
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
        backgroundColor: isSelected ? Color(0xFF006FFD) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        country,
        style: TextStyle(
          color: isSelected ? Colors.white : Color(0xFF006FFD),
          fontSize: 16,
          fontFamily: 'Inter-semibold',
        ),
      ),
    );
  }
}
