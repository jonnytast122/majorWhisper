import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CourseDetail extends StatelessWidget {
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
                Navigator.pop(context);
              },
            ),
          ),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: const Text(
              'Introduction to SQL',
              style: TextStyle(
                fontSize: 30,
                fontFamily: "Inter-bold",
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'What is SQL and Relational Database?',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Inter-semibold",
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'In this lesson, you will gain a fundamental understanding of what databases are and why they are crucial in today’s data-driven world. We will explore the concept of relational databases, how data is structured into tables, and the role of SQL in managing and interacting with these databases.',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Inter-regular",
                  color: Color(0xFF989898),
                ),
              ),
            ),
            const SizedBox(height: 20), // Add spacing between sections
            Expanded(
              // Wrap ListView.builder in Expanded
              child: ListView.builder(
                itemCount: 1, // Number of items to display
                itemBuilder: (context, index) {
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
                    child: Padding(
                      // Add padding inside Expanded
                      padding:
                          const EdgeInsets.all(8.0), // Adjust padding as needed
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "What is SQL?",
                                  style: const TextStyle(
                                    fontFamily: "Inter-semibold",
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  "SQL (Structured Query Language) is a standardized programming language specifically designed for managing and manipulating relational databases. SQL allows users to perform various operations on the data stored in a database.",
                                  style: const TextStyle(
                                    fontFamily: "Inter-regular",
                                    fontSize: 12.0,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 8.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.copy,
                                                  color: Colors.white,
                                                  size: 10),
                                              padding: EdgeInsets
                                                  .zero, // Remove padding around the IconButton
                                              constraints:
                                                  BoxConstraints(), // Removes minimum size constraints
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(
                                                    text:
                                                        "SELECT * FROM Employees;\n-- Retrieve All Columns from a Table:\n\nSELECT FirstName, LastName FROM Employees;\n--Retrieves only the FirstName, and LastName columns from the Employees table."));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        "Code copied to clipboard!"),
                                                    duration:
                                                        Duration(seconds: 2),
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
                                        child: Text(
                                          "SELECT * FROM Employees;\n-- Retrieve All Columns from a Table:\n\nSELECT FirstName, LastName FROM Employees;\n--Retrieves only the FirstName, and LastName columns from the Employees table.",
                                          style: TextStyle(
                                            fontFamily: "Spacemono-Regular",
                                            fontSize: 10.0,
                                            color: Colors.white,
                                          ),
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
