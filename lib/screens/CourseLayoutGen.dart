import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:majorwhisper/screens/CourseLayout.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:majorwhisper/screens/Home.dart';
import 'routes/RouteHosting.dart';


class CourselayoutGen extends StatefulWidget {
  @override
  _CourselayoutGenState createState() => _CourselayoutGenState();
}

class _CourselayoutGenState extends State<CourselayoutGen> {
  List<Map<String, String>> courses = [];
  String userId = FirebaseAuth.instance.currentUser!.uid;

  // Variables to store course details
  String category = '';
  String courseName = '';
  String description = '';
  String duration = '';
  String level = '';
  int numberOfChapters = 0;
  String topic = '';
  String thumbnail = '';
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchCourseData();
  }

  Future<void> fetchCourseData() async {
    print('Fetching course data...');
    try {
      // Fetch the document from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('course_layout_generated')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data();
        print(data);
        if (data != null) {
          final List<dynamic> courseLayouts = data['course_layouts'] ?? [];

          if (courseLayouts.isNotEmpty) {
            // Assuming the latest course is the last one in the list
            final latestCourse = courseLayouts.last;

            category = latestCourse['category'] ?? '';
            courseName = latestCourse['course_name'] ?? '';
            description = latestCourse['description'] ?? '';
            duration = latestCourse['duration'] ?? '';
            level = latestCourse['level'] ?? '';
            numberOfChapters = latestCourse['number_of_chapters'] ?? 0;
            topic = latestCourse['course_name'] ?? '';
            thumbnail = latestCourse['thumbnail'] ?? '';

            List<Map<String, String>> chapters = [];
            final List<dynamic> courseChapters = latestCourse['chapters'] ?? [];

            for (var chapter in courseChapters) {
              chapters.add({
                'chapter_name': chapter['chapter_name'] ?? '',
                'about': chapter['about'] ?? '',
                'duration': chapter['duration'] ?? '',
              });
            }

            setState(() {
              courses = chapters;
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching course data: $e');
    }
  }

  Future<void> _pickImage(String course_name) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      await _uploadImageToFirebase(course_name);
    }
  }

  Future<void> _uploadImageToFirebase(String course_name) async {
    try {
      if (_selectedImage == null) return;

      // Upload image to Firebase Storage
      String fileName = basename(_selectedImage!.path);
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('course_thumbnail/$course_name/$fileName');

      await firebaseStorageRef.putFile(_selectedImage!);
      String downloadURL = await firebaseStorageRef.getDownloadURL();

      // Fetch the current document from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('course_layout_generated')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          List<dynamic> courseLayouts = data['course_layouts'];

          // Update the course with the matching course_name
          for (var course in courseLayouts) {
            if (course['course_name'] == course_name) {
              course['thumbnail'] = downloadURL;
              break;
            }
          }

          // Save the updated list back to Firestore
          await FirebaseFirestore.instance
              .collection('course_layout_generated')
              .doc(userId)
              .update({'course_layouts': courseLayouts});
          print('Image save to firebase successfully');
        }
      }

      print('Upload successful, URL: $downloadURL');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(top: 21.0),
            child: IconButton(
  icon: const Icon(Icons.arrow_back_ios_rounded),
  color: const Color.fromARGB(255, 0, 0, 0),
  onPressed: () {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Exit'),
        content: Text(
          'If you go back now, the current course will not be saved. Do you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              // Delete the last course in Firestore
              try {
                final userId = FirebaseAuth.instance.currentUser?.uid;

                if (userId != null) {
                  // Fetch the document
                  DocumentSnapshot<Map<String, dynamic>> snapshot =
                      await FirebaseFirestore.instance
                          .collection('course_layout_generated')
                          .doc(userId)
                          .get();

                  if (snapshot.exists) {
                    final data = snapshot.data();
                    if (data != null && data.containsKey('course_layouts')) {
                      List<dynamic> courseLayouts = data['course_layouts'];

                      if (courseLayouts.isNotEmpty) {
                        // Remove the last course
                        courseLayouts.removeLast();

                        // Update Firestore with the new course list
                        await FirebaseFirestore.instance
                            .collection('course_layout_generated')
                            .doc(userId)
                            .update({'course_layouts': courseLayouts});
                      }
                    }
                  }
                }
              } catch (e) {
                print('Error deleting the last course: $e');
              }

              // Close the dialog and navigate back
              Navigator.of(context).pop(); // Close the dialog
              
                // Use updateSelectedIndex to change to the CourseGen tab
                context
                    .findAncestorStateOfType<HomeState>()
                    ?.updateSelectedIndex(1);

                // Pop the current screen (e.g., dialog or overlay)
                Navigator.of(context).popUntil((route) => route.isFirst);
              }, // Go back to the previous screen
            
            child: Text('Yes'),
          ),
        ],
      ),
    );
  },
),

          ),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: const Text(
              'Course Layout',
              style: TextStyle(
                fontSize: 30,
                fontFamily: "Inter-bold",
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: ListView(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: GestureDetector(
                      onTap: () => _pickImage(
                          topic), // Call the image upload function when tapped
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : (thumbnail.isNotEmpty
                              ? Image.network(
                                  thumbnail,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/select_file.png',
                                  height: 200,
                                )),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            topic,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "Inter-semibold",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Color(0xFF989898),
                        fontSize: 13.5,
                        fontFamily: "Inter-regular",
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          category,
                          style: TextStyle(
                            color: Color(0xFF006FFD),
                            fontSize: 15,
                            fontFamily: "Inter-semibold",
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 16.0, left: 5, right: 5),
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 5),
                            Container(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icon/skill.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Skill Level',
                                        style: TextStyle(
                                          fontSize: 7,
                                          fontFamily: "Inter-semibold",
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        level,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontFamily: "Inter-semibold",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            Container(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icon/clock.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Duration',
                                        style: TextStyle(
                                          fontSize: 7,
                                          fontFamily: "Inter-semibold",
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        duration,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontFamily: "Inter-semibold",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icon/book.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'No. Chapter',
                                        style: TextStyle(
                                          fontSize: 7,
                                          fontFamily: "Inter-semibold",
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        numberOfChapters.toString(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontFamily: "Inter-semibold",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Chapter',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "Inter-semibold",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: 16.0, left: 5, right: 5),
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Color(0xFF006FFD), // Circle color
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}', // Index starts at 0, so add 1
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: "Inter-bold",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 15), // Spacing between circle and text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course['chapter_name']!,
                                    style: const TextStyle(
                                      fontFamily: "Inter-semibold",
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    course['about']!,
                                    style: const TextStyle(
                                      fontFamily: "Inter-regular",
                                      fontSize: 12.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        size: 14.0,
                                        color: Color(0xFF006FFD),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        course['duration']!,
                                        style: const TextStyle(
                                          fontFamily: "Inter-semibold",
                                          fontSize: 10.0,
                                          color: Color(0xFF006FFD),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0, bottom: 12),
            child: ElevatedButton(
              onPressed: () async {
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
                              'assets/icon/learning_loading.json',
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Course Content is Generating\nAlmost Ready!',
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

                try {
                  // Make the API request
                  final response = await http.post(
                    Uri.parse('${RouteHosting.baseUrl}chapter-generation'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({'uuid': userId}),
                  );

                  if (response.statusCode == 200) {
                    final data = json.decode(response.body);

                    if (data['message'] ==
                        "Content generated and saved successfully") {
                      // Close the loading dialog
                      Navigator.of(context).pop();

                      // Navigate to Courselayout screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Courselayout(
                            topicController:
                                topic, // Replace with your topic if needed
                          ),
                        ),
                      );
                    } else {
                      // Handle unexpected responses
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Unexpected response from the server.')),
                      );
                    }
                  } else {
                    // Handle errors
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Failed to generate content: ${response.statusCode}')),
                    );
                  }
                } catch (e) {
                  // Handle exceptions
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('An error occurred: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
                backgroundColor: Color(0xFF006FFD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ), // Button background color
              ),
              child: Text(
                'Generate Course Content',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Inter-semibold",
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
