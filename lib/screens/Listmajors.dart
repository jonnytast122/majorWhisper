import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:majorwhisper/screens/MajorDetail.dart';
import 'package:lottie/lottie.dart';
import 'routes/RouteHosting.dart';

class Listmajors extends StatefulWidget {
  final String title;

  const Listmajors({Key? key, required this.title}) : super(key: key);

  @override
  _ListmajorsState createState() => _ListmajorsState();
}

class _ListmajorsState extends State<Listmajors> {
  List<String> majorNames = [];
  List<String> majorDescriptions = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchMajors();
  }

  Future<void> fetchMajors() async {
    setState(() {
      isLoading = true; // Start loading
    });

    final response = await http.post(
      Uri.parse('${RouteHosting.baseUrl}major-base-on-category'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'category': widget.title}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      setState(() {
        majorNames = List<String>.from(data['major_name']);
        majorDescriptions = List<String>.from(data['major_description']);
        isLoading = false; // Stop loading after data is fetched
      });
    } else {
      // Handle errors
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
      print('Failed to load majors');
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 250,
            width: 250,
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
                const SizedBox(height: 20),
                const Text(
                  'Major Detail is Generating\nAlmost Ready!',
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
  }

  void _fetchDataAndNavigate(BuildContext context, String majorName) async {
    _showLoadingDialog(context);

    try {
      final response = await http.post(
        Uri.parse("${RouteHosting.baseUrl}major-detail"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'major_name': majorName,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Navigator.of(context).pop(); // Close the loading dialog

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Majordetail(
              majorName: majorName,
              data: data, // Pass data to Majordetail
            ),
          ),
        );
      } else {
        Navigator.of(context).pop(); // Close the loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

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
                top: 0), // Add padding to the top of the title
            child: Text(
              widget.title, // Use the title passed from the CategoryCard
              style: const TextStyle(
                fontSize: 23,
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
                      fontSize: 20,
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
              padding: const EdgeInsets.only(top: 60.0, left: 98),
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
              child: isLoading
                  ? Center(
                      child: Lottie.asset(
                        'assets/icon/learning_loading.json', // Path to your Lottie animation file
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: majorNames.length, // Number of items
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            // Wrap the entire card in GestureDetector
                            onTap: () {
                              _fetchDataAndNavigate(context, majorNames[index]);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 111, 174, 255),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 60.0,
                                    height: 60.0,
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
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontFamily: "Inter-black",
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          majorNames[
                                              index], // Major name from API
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Inter-semibold",
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          majorDescriptions[
                                              index], // Description from API
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.black54,
                                            fontFamily: "Inter-regular",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/icon/arrow.png', // Path to your custom icon
                                    width: 40.0,
                                    height: 30.0,
                                  ),
                                ],
                              ),
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
