import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/Home.dart';

class Courselayout extends StatefulWidget {
  @override
  _CourselayoutState createState() => _CourselayoutState();
}

class _CourselayoutState extends State<Courselayout> {
  void _onImageTap() {
    // Define what happens when the image button is tapped
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image button tapped!')),
    );
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
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: ListView(
          children: [
            // Existing content
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.asset(
                'assets/images/sql_vector.png', // Corrected the image path usage
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
                      'assets/icon/Pencil_Edit.png', // Replace with your image path
                      height: 30,
                      width: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'This course is designed for beginners with no prior experience in SQL or databases. Throughout the course, you will learn the fundamental concepts and techniques required to work with relational databases, enabling you to store, retrieve, and analyze data efficiently.',
                style: TextStyle(
                  color: Color(0xFF989898),
                  fontSize: 13.5,
                  fontFamily: "Inter-regular",
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: _onImageTap,
                    child: Image.asset(
                      'assets/icon/card_membership.png', // Replace with your image path
                      height: 20,
                      width: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Development',
                    style: TextStyle(
                      color: Color(0xFF006FFD),
                      fontSize: 15,
                      fontFamily: "Inter-semibold",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Static container 1
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Major 1', // Replace with major name
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter-bold",
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Description of Major 1', // Replace with major description
                          style: const TextStyle(
                            fontSize: 9,
                            fontFamily: "Inter-regular",
                            color: Color(0xFF898A8D),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Add your onPressed logic here
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFF006FFD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: EdgeInsets.zero,
                            minimumSize: Size(60, 23),
                          ),
                          child: const Text(
                            'Learn More',
                            style: TextStyle(
                              fontSize: 7,
                              fontFamily: 'Inter-semibold',
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
  }
}
