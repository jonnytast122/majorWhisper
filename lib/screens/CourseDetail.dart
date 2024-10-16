import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';


class CourseDetail extends StatelessWidget {
  final String chapterName;
  final String courseName;

  CourseDetail({required this.chapterName, required this.courseName});

  @override
  Widget build(BuildContext context) {
    final userId =
        FirebaseAuth.instance.currentUser!.uid; // Fetch current user's ID

    // Fetch the user's course data from Firestore
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
      final chapters = data['chapters']; // Assuming 'chapters' is a map
      print("Chapters: $chapters");

      // Now, we need to loop through the chapters list to find the matching chapter
      Map<String, dynamic>? matchingChapter;

      // Assuming chapters map holds course names as keys and lists as values
      chapters.forEach((courseName, chapterList) {
        for (var chapter in chapterList) {
          if (chapter['chapter_name'] == chapterName) {
            matchingChapter = chapter;
            break;
          }
        }
      });

      if (matchingChapter == null) {
        print("No matching chapter found");
        return null;
      }

      print("Chapter: $matchingChapter");
      return matchingChapter; // Return the matching chapter's content
    }

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
                Navigator.pop(context);
              },
            ),
          ),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              chapterName, // Display the course name here
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Inter-bold",
                color: Colors.black,
              ),
            ),
          ),
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

          final chapterContent = snapshot.data!['content']
              as List<dynamic>; // Fetch the content array

          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
              itemCount: chapterContent.length,
              itemBuilder: (context, index) {
                final content = chapterContent[index] as Map<String, dynamic>;

                // Style the first content without code (use your example)
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

                // Style the rest of the content (may have code)
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
                        data : content['explanation'],
                          styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter-regular',
                            color: Colors.black,
                          ),
                        ),
                      ),
                      // Text(
                      //   content['explanation'],
                      //   style: const TextStyle(
                      //     fontSize: 13,
                      //     fontFamily: "Inter-regular",
                      //     color: Color.fromARGB(255, 85, 85, 85),
                      //   ),
                      // ),
                      const SizedBox(height: 8.0),
                      if (content['code_example'] != null &&
                          content['code_example'].isNotEmpty)
                        Container(
                          margin: EdgeInsets.all(0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 0.0),
                                height: 34.0, // Set an explicit height
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.copy,
                                          color: Colors.white, size: 10),
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                            text: content['code_example']));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Code copied to clipboard!"),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .start, // Aligns children to the start
                                  children: [
                                    Expanded(
                                      // Makes the Container take up maximum width
                                      child: Text(
                                        content['code_example'],
                                        style: TextStyle(
                                          fontFamily: "Spacemono-Regular",
                                          fontSize: 10.0,
                                          color: Colors.white,
                                        ),
                                        softWrap:
                                            true, // Allows text to wrap within the container
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
