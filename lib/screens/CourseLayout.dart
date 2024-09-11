import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/Home.dart';

class Courselayout extends StatefulWidget {
  @override
  _CourselayoutState createState() => _CourselayoutState();
}

class _CourselayoutState extends State<Courselayout> {
  void _onImageTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image button tapped!')),
    );
  }

  // List of courses
  final List<Map<String, String>> courses = [
    {
      'title': 'Introduction to Database',
      'description':
          'This course is designed for beginners with no prior experience in SQL or databases. Throughout the course, you will learn the fundamental concepts and techniques required to work with relational databases, enabling you to store, retrieve, and analyze data efficiently.',
      'duration': '15 minutes',
    },
    {
      'title': 'Basic SQL Syntax',
      'description':
          'This lesson introduces you to the basics of SQL syntax. You\'ll learn how to write your first SQL queries, covering essential commands like SELECT, INSERT, UPDATE, and DELETE. By the end of this lesson, you will be able to execute basic data manipulation tasks in a database.',
      'duration': '20 minutes',
    },
  ];

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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
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
                    child: Image.asset(
                      'assets/images/sql_vector.png',
                      height: 210,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Introduction to SQL for Beginners',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "Inter-semibold",
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: _onImageTap,
                          child: Image.asset(
                            'assets/icon/Pencil_Edit.png',
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'This course is designed for beginners with no prior experience in SQL or databases. Throughout the course, you will learn the fundamental concepts and techniques required to work with relational databases, enabling you to store, retrieve, and analyze data efficiently.',
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
                        InkWell(
                          onTap: _onImageTap,
                          child: Image.asset(
                            'assets/icon/card_membership.png',
                            height: 15,
                            width: 15,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Development",
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
                    margin: const EdgeInsets.only(bottom: 16.0),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 5),
                            Container(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icon/skill.png',
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Skill Level',
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontFamily: "Inter-semibold",
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Beginner',
                                        style: TextStyle(
                                          fontSize: 12,
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
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Duration',
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontFamily: "Inter-semibold",
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '1 hour',
                                        style: TextStyle(
                                          fontSize: 12,
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
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'No. Chapter',
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontFamily: "Inter-semibold",
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '5',
                                        style: TextStyle(
                                          fontSize: 12,
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
                            Container(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icon/youtube.png',
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Video included',
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontFamily: "Inter-semibold",
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Yes',
                                        style: TextStyle(
                                          fontSize: 12,
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
                        margin: const EdgeInsets.only(bottom: 16.0),
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
                                    course['title']!,
                                    style: const TextStyle(
                                      fontFamily: "Inter-semibold",
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    course['description']!,
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
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Course Started!')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
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
