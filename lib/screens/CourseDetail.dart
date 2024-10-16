import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CourseDetail extends StatelessWidget {
  final String chapterName;
  final String courseName;

  CourseDetail({required this.chapterName, required this.courseName});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    Future<Map<String, dynamic>?> _fetchCourseContent() async {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance
              .collection('course_content')
              .doc(userId)
              .get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return null;
      }

      final data = docSnapshot.data()!;
      final chapters = data['chapters'];
      Map<String, dynamic>? matchingChapter;

      chapters.forEach((courseName, chapterList) {
        for (var chapter in chapterList) {
          if (chapter['chapter_name'] == chapterName) {
            matchingChapter = chapter;
            break;
          }
        }
      });

      return matchingChapter;
    }

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(top: 21.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              chapterName,
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Inter-bold",
                color: Colors.black,
              ),
            ),
          ),
          backgroundColor: const Color.fromARGB(
              255, 255, 255, 255), // Set the AppBar background to white
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchCourseContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data.'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No content available.'));
          }

          final chapterContent = snapshot.data!['content'] as List<dynamic>;

          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
              itemCount: chapterContent.length,
              itemBuilder: (context, index) {
                final content = chapterContent[index] as Map<String, dynamic>;

                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: .0),
                        child: Text(
                          content['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: "Inter-semibold",
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          content['explanation'],
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter-regular",
                            color: Color(0xFF989898),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 165, 195, 255),
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
                      Text(
                        content['title'],
                        style: const TextStyle(
                          fontFamily: "Inter-semibold",
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      MarkdownBody(
                        data: content['explanation'],
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter-regular',
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      if (content['code_example'] != null &&
                          content['code_example'].isNotEmpty)
                        Container(
                          margin: EdgeInsets.all(0.0),
                          width: double
                              .infinity, // Ensure the container takes up all available width
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color.fromRGBO(254, 247, 255, 1.000),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Code Example",
                                  style: TextStyle(
                                    fontFamily: "Inter-semibold",
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                MarkdownBody(
                                  data: content['code_example'],
                                  styleSheet: MarkdownStyleSheet(
                                    p: TextStyle(
                                      fontSize: 10,
                                      fontFamily: "Spacemono-Regular",
                                      color: Colors.black,
                                    ),
                                    code: TextStyle(
                                      backgroundColor: const Color.fromRGBO(
                                          254, 247, 255, 1.000),
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
