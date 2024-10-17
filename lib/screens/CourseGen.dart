import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:majorwhisper/screens/CourseLayout.dart';
import 'package:majorwhisper/screens/CreateCourse.dart';

class CourseGen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top half (blue with bottom radius and search bar)
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30.0), // Radius for the bottom corners
            ),
            child: Container(
              color: Color(0xFF006FFD),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Generate custom courses with AI.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Inter-semibold",
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Search Course',
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 221, 221, 221),
                                ),
                                prefixIcon: Icon(Icons.search,
                                    color: Color.fromARGB(255, 108, 108, 108)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateCourse()),
                              );
                            },
                            child: Image.asset(
                              'assets/images/add_course.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom half (content from Firestore)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('course_layout_generated')
                    .doc(userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('No courses available.'));
                  }

                  // Get the 'course_layouts' data
                  var courseLayouts = snapshot.data!['course_layouts'];
                  if (courseLayouts == null || courseLayouts.isEmpty) {
                    return Center(child: Text('No courses available.'));
                  }

                  return ListView.builder(
                    itemCount: courseLayouts.length,
                    itemBuilder: (context, index) {
                      var course = courseLayouts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Courselayout(
                                  topicController:
                                      course['course_name'] ?? 'Unknown Course',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child:
                                      (course['thumbnail']?.isNotEmpty == true
                                          ? Image.network(
                                              course['thumbnail'],
                                              height: 150,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/images/select_file.png',
                                              height: 150,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        course['course_name'] ?? 'Course Name',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Inter-bold",
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        course['category'] ?? 'Category',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Inter-semibold",
                                          color: Color.fromARGB(
                                              255, 179, 179, 179),
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF006FFD)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.book,
                                                    color: Color(0xFF006FFD),
                                                    size: 16),
                                                SizedBox(width: 4),
                                                Text(
                                                  '${course['number_of_chapters'] ?? 0} Chapters',
                                                  style: TextStyle(
                                                    color: Color(0xFF006FFD),
                                                    fontFamily:
                                                        "Inter-semibold",
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF006FFD)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              course['level'] ?? 'Level',
                                              style: TextStyle(
                                                color: Color(0xFF006FFD),
                                                fontFamily: "Inter-semibold",
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.grey),
                                            onPressed: () async {
                                              // Show confirmation dialog
                                              bool? confirmDelete =
                                                  await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text('Confirm Delete'),
                                                    content: Text(
                                                        'Are you sure you want to delete this course?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(
                                                              false); // Cancel the action
                                                        },
                                                        child: Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(
                                                              true); // Confirm the action
                                                        },
                                                        child: Text('Yes'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                              // If the user confirmed, delete the course
                                              if (confirmDelete == true) {
                                                try {
                                                  final userId = FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      ?.uid;
                                                  final courseToDelete =
                                                      courseLayouts[index];

                                                  // Remove the course from Firestore
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'course_layout_generated')
                                                      .doc(userId)
                                                      .update({
                                                    'course_layouts':
                                                        FieldValue.arrayRemove(
                                                            [courseToDelete]),
                                                  });

                                                  print(
                                                      'Course deleted successfully.');
                                                } catch (e) {
                                                  print(
                                                      'Error deleting course: $e');
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
