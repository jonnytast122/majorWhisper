import 'package:flutter/material.dart';

class Listmajors extends StatefulWidget {
  final String title;

  const Listmajors({Key? key, required this.title}) : super(key: key);

  @override
  _ListmajorsState createState() => _ListmajorsState();
}

class _ListmajorsState extends State<Listmajors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(kToolbarHeight), // Use default toolbar height
        child: AppBar(
          backgroundColor: const Color(0xFF006FFD), // Blue background color
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the icon color to white
          ),
          title: Padding(
            padding: const EdgeInsets.only(
                top: 10.0), // Add padding to the top of the title
            child: Text(
              widget.title, // Use the title passed from the CategoryCard
              style: const TextStyle(
                fontSize: 28,
                fontFamily: "Inter-bold",
                color: Colors.white,
              ),
            ),
          ),
          centerTitle: true, // Center the title horizontally
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF006FFD), // Blue background color
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  const Text(
                    'Discover Your Path', // Subtitle text
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Inter-semibold",
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 70.0, left: 50),
              child: Column(
                children: [
                  const Text(
                    'Your Future Start Here :)', // Title text
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter-regular",
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height *
                  0.75, // Height of the white container
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: 5, // Number of items
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 111, 174, 255),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/box.png'), // Path to your image
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontFamily: "Inter-black",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Pharmacy', // Placeholder for major name
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Inter-semibold",
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Pharmacy is the field of healthcare dedicated to the preparation ...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontFamily: "Inter-regular",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle button press here
                            },
                            child: Image.asset(
                              'assets/icon/arrow.png', // Path to your custom icon
                              width: 40.0,
                              height: 30.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
