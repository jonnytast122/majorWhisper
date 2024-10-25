import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:majorwhisper/screens/CourseLayoutGen.dart';
import 'routes/RouteHosting.dart';

class CreateCourse extends StatefulWidget {
  @override
  _CreateCourseState createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  int currentStep = 1; // Tracks the current step in the process
  int? selectedCategoryIndex;
  String? selectedCategory; // Store the index of the selected category
  final TextEditingController topicController = TextEditingController();
  String? selectedDifficulty;
  String? selectedDuration;
  String? selectedChapterCount;
  String? userUUID = FirebaseAuth.instance.currentUser?.uid;
  bool isLoading = true; // Add a loading flag

  // New function to show DelightfulToast notifications
  void showToast(String message) {
    DelightToastBar(
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      snackbarDuration: Duration(seconds: 2),
      builder: (context) => ToastCard(
        leading: Icon(
          Icons.error,
          size: 28,
          color: Color.fromARGB(255, 244, 164, 74),
        ),
        title: Text(
          message,
          style: TextStyle(
            fontFamily: "Inter-semibold",
            fontSize: 14,
            color: Color.fromARGB(255, 244, 164, 74),
          ),
        ),
      ),
    ).show(context);
  }

  Future<void> submitCourse() async {
    try {
      // Show loading dialog
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
                    'Course Layout is Generating\nAlmost Ready!',
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

      // Prepare the request body
      final body = jsonEncode({
        "uuid": userUUID,
        "category": selectedCategory,
        "topic": topicController.text,
        "level": selectedDifficulty,
        "duration": selectedDuration,
        "number_of_chapter": selectedChapterCount,
      });
      print(body);
      // Send the API request
      final response = await http.post(
        Uri.parse('${RouteHosting.baseUrl}content-layout-generation'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response if needed
        // Navigate to Courselayout with the topic name
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourselayoutGen(),
          ),
        );
      } else {
        Navigator.pop(context); // Close the loading dialog
        showToast('Failed to create course. Please try again.');
      }
    } catch (e) {
      Navigator.pop(context); // Close the loading dialog
      showToast('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            'Create Course',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontFamily: "Inter-semibold",
            ),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(top: 21.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => setState(() {
                    currentStep = 1; // Move back to Step 1
                  }),
                  child: buildStepIcon(context,
                      icon: Icons.grid_view,
                      label: 'Category',
                      isActive: currentStep >= 1), // Active for Step 1 or above
                ),
                buildLine(context,
                    isActive: currentStep >= 2), // Line between Step 1 & 2
                GestureDetector(
                  onTap: () => setState(() {
                    if (currentStep > 1) currentStep = 2; // Move back to Step 2
                  }),
                  child: buildStepIcon(context,
                      icon: Icons.lightbulb_outline,
                      label: 'Topic',
                      isActive: currentStep >= 2), // Active for Step 2 or above
                ),
                buildLine(context,
                    isActive: currentStep >= 3), // Line between Step 2 & 3
                GestureDetector(
                  onTap: () => setState(() {
                    if (currentStep > 2) currentStep = 3; // Move to Step 3
                  }),
                  child: buildStepIcon(context,
                      icon: Icons.folder_open,
                      label: 'Options',
                      isActive: currentStep >= 3), // Active for Step 3
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: currentStep == 1
                ? buildCategorySelection()
                : currentStep == 2
                    ? buildTextFields()
                    : buildOptionsDropdown(),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () async {
            if (currentStep == 1 && selectedCategoryIndex == null) {
              showToast("Please select one of the choices.");
            } else if (currentStep == 2 && topicController.text.isEmpty) {
              showToast("Please enter a topic.");
            } else if (currentStep == 1) {
              setState(() {
                currentStep = 2;
              });
            } else if (currentStep == 2) {
              setState(() {
                currentStep = 3;
              });
            } else {
              await submitCourse();
            }
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 40.0),
              backgroundColor: Color(0xFF006FFD),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0))),
          child: Text('Next',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Inter-semibold",
                  fontSize: 16)),
        ),
      ),
    );
  }

  Widget buildTextFields() {
  return SingleChildScrollView(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Topic TextField with custom label and hint
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    '💡Write the topic for course generation (e.g., Python...)',
                    style: TextStyle(
                      fontFamily: "Inter-bold",
                      fontSize: 11,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              TextField(
                controller: topicController,
                decoration: InputDecoration(
                  hintText: 'Topic',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 219, 219, 219),
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 219, 219, 219),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Description TextField with custom label and hint
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    '📝 Tell us more about your course (Optional)',
                    style: TextStyle(
                      fontFamily: "Inter-bold",
                      fontSize: 11,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'About your course',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 219, 219, 219),
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 219, 219, 219),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                maxLines: 7,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  // Step 3: Options dropdown
  Widget buildOptionsDropdown() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDropdown(
              '🎓 Difficulty Level',
              ['Beginner', 'Intermediate', 'Expert'],
              selectedDifficulty,
              (val) => setState(() => selectedDifficulty = val)),
          buildDropdown(
              '🕰 Course Duration',
              [
                '1 hour',
                '2 hours',
                '3 hours',
                "4 hours",
                "5 hours",
                'more than 5 hours'
              ],
              selectedDuration,
              (val) => setState(() => selectedDuration = val)),
          buildDropdown(
              '✏️ Number of Chapters',
              ['5', '10', '15', '20'],
              selectedChapterCount,
              (val) => setState(() => selectedChapterCount = val))
        ],
      ),
    );
  }

  TextStyle dropdownTextStyle = TextStyle(
    fontFamily:
        'Inter-medium', // Make sure to include this font in your pubspec.yaml
    fontSize: 15,
    color: Colors.black54, // Choose a suitable color that matches your theme
  );

  TextStyle dropdownMenuItemStyle = TextStyle(
    fontFamily: 'Inter-medium', // Change to your preferred font
    fontSize: 15,
    color:
        const Color.fromARGB(255, 0, 0, 0), // Adjust based on your preference
  );

  InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide:
          BorderSide(color: const Color.fromARGB(255, 219, 219, 219), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide:
          BorderSide(color: const Color.fromARGB(255, 219, 219, 219), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Color(0xFF006FFD), width: 1),
    ),
  );

  Widget buildDropdown(String title, List<String> options, String? value,
      void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter-bold',
                  color: const Color.fromARGB(255, 0, 0, 0))),
          SizedBox(height: 5),
          Container(
            child: DropdownButtonFormField<String>(
              decoration: inputDecoration,
              icon: const Icon(Icons.arrow_drop_down,
                  color: Color.fromARGB(255, 0, 0, 0)),
              iconSize: 24,
              style: dropdownTextStyle,
              value: value,
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: dropdownMenuItemStyle),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategorySelection() {
    List<String> titles = [
      'DESIGN',
      'DEVELOPMENT',
      'PHOTOGRAPHY',
      'BUSINESS',
      'IT AND SOFTWARE',
      'MARKETING'
    ];
    List<IconData> icons = [
      Icons.design_services,
      Icons.developer_mode,
      Icons.camera_alt,
      Icons.business_center,
      Icons.computer,
      Icons.mark_email_read
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 18.0,
              top: 8.0,
              bottom: 10.0), // Adjusted for better vertical and left alignment
          child: Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              'Please Select a Category',
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Inter-medium",
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0), // Added horizontal padding
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 13, // Adjusted cross-axis spacing
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
              children: List.generate(
                  6, (index) => buildCategoryCard(index, titles, icons)),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCategoryCard(
      int index, List<String> titles, List<IconData> icons) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategoryIndex = index;
          selectedCategory = titles[index];
        });
      },
      child: Card(
        color: selectedCategoryIndex == index ? Colors.blue[100] : Colors.white,
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icons[index],
                size: 30,
                color: selectedCategoryIndex == index
                    ? Colors.blue
                    : Colors.black),
            Text(titles[index],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: selectedCategoryIndex == index
                        ? Colors.blue
                        : Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget buildStepIcon(BuildContext context,
      {required IconData icon, required String label, required bool isActive}) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: isActive ? Color(0xFF006FFD) : Colors.grey[300],
          radius: 20,
          child: Icon(icon,
              color: isActive ? Colors.white : Colors.grey, size: 23),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.black : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget buildLine(BuildContext context, {required bool isActive}) {
    return SizedBox(
      width: 100,
      child: Container(
        height: 3,
        color: isActive ? Colors.blue : Colors.grey[300],
      ),
    );
  }
}
