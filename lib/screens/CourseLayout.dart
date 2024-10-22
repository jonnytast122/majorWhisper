import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:majorwhisper/screens/CourseDetail.dart';
import 'package:path/path.dart';
import 'package:majorwhisper/screens/CourseGen.dart';
import 'package:majorwhisper/screens/Home.dart';

class Courselayout extends StatefulWidget {
  final String topicController;

  Courselayout({required this.topicController});

  @override
  _CourselayoutState createState() => _CourselayoutState();
}

class _CourselayoutState extends State<Courselayout> {
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
    print('Course layout topic: ${widget.topicController}');
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
          for (var course in data['course_layouts']) {
            print('course:' + course['course_name']);
            print('widget:' + widget.topicController);
            if (course['course_name'] == widget.topicController) {
              category = course['category'] ?? '';
              courseName = course['course_name'] ?? '';
              description = course['description'] ?? '';
              duration = course['duration'] ?? '';
              level = course['level'] ?? '';
              numberOfChapters = course['number_of_chapters'] ?? 0;
              topic = course['course_name'] ?? '';
              thumbnail = course['thumbnail'] ?? '';

              List<Map<String, String>> chapters = [];
              final List<dynamic> courseChapters = course['chapters'] ?? [];

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
              break;
            }
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
            if (course['course_name'] == widget.topicController) {
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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(top: 21.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: const Color.fromARGB(255, 0, 0, 0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
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
          backgroundColor: Colors.white,
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
                        fontSize: 13,
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
                      return GestureDetector(
                        onTap: () {
                          // Navigate to CourseDetail and pass the course['chapter_name']
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseDetail(
                                courseName: topic,
                                chapterName: course[
                                    'chapter_name']!, // Pass the chapter name
                              ),
                            ),
                          );
                        },
                        child: Container(
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Course Started!')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
                backgroundColor: Color(0xFF006FFD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ), // Button background color
              ),
              child: Text(
                'Start Course',
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
