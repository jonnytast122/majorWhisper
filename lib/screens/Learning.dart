import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/LearningResult.dart';

class Learning extends StatefulWidget {
  @override
  _LearningState createState() => _LearningState();
}

class _LearningState extends State<Learning> {
  String selectedDegree = 'Bachelor'; // Default selected button
  final TextEditingController _searchController = TextEditingController();

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
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "Explore your major's path",
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
                  "Search and explore your future\nlearning journey!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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
                    fontFamily: 'Inter-regular',
                    fontSize: 18,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF000000),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(
                        right:
                            10), // Move the entire IconButton, not just the icon
                    child: IconButton(
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Color(0xFF000000),
                      ),
                      onPressed: () {
                        _search(_searchController.text, selectedDegree);
                      },
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFEDEDED),
                ),
                onFieldSubmitted: (value) => _search(value, selectedDegree),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "Degree",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Inter-semibold',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildDegreeButton('Bachelor'),
                  SizedBox(width: 10),
                  buildDegreeButton('Master'),
                  SizedBox(width: 10),
                  buildDegreeButton('PhD'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDegreeButton(String degree) {
    final isSelected = selectedDegree == degree;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedDegree = degree;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        degree,
        style: TextStyle(
          color: isSelected ? Color(0xFF006FFD) : Colors.white,
          fontSize: 16,
          fontFamily: 'Inter-semibold',
        ),
      ),
    );
  }

  void _search(String majorName, String degree) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearningResult(majorName: majorName, degree: degree),
      ),
    );
  }
}
