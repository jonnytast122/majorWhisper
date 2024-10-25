import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart'; // Ensure you have this package for Lottie animations
import 'package:majorwhisper/screens/Holland.dart'; // Import the Holland screen
import 'package:firebase_auth/firebase_auth.dart';
import 'routes/RouteHosting.dart';

class Bigfive extends StatefulWidget {
  final List<dynamic>
      personalityTraits; // Accepting personality traits in the constructor

  const Bigfive({required this.personalityTraits, Key? key}) : super(key: key);

  @override
  _BigfiveState createState() => _BigfiveState();
}

class _BigfiveState extends State<Bigfive> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final List<Color> traitColors = [
      Color(0xFF805FDD), // Color for Trait 1
      Color(0xFFFE6D6E), // Color for Trait 2
      Color(0xFF5CB85C), // Color for Trait 3
      Color(0xFF5BC0DE), // Color for Trait 4
      Color.fromARGB(255, 150, 191, 28), // Color for Trait 5
      // Add more colors as needed for additional traits
    ];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
            100.0), // Adjust height for title and subtitle
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          leading: Padding(
            padding: const EdgeInsets.only(top: 21.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: const Color.fromARGB(255, 0, 0, 0),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          flexibleSpace: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0), // Space adjustment
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Big Five Personality',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: "Inter-semibold",
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 1.0),
                  const Text(
                    'Discover Your Personality Traits',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter-medium",
                      color: Color.fromARGB(255, 100, 100, 100),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: Color(0xFF006FFD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
child: ListView.builder(
  itemCount: widget.personalityTraits.length,
  itemBuilder: (context, index) {
    final trait = widget.personalityTraits[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Allow height to be flexible
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15.0),
          Text(
            trait['trait'], // Display the trait name dynamically
            style: const TextStyle(
              fontSize: 24,
              fontFamily: "Inter-bold",
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15.0), // Add spacing between text and gauge
          SizedBox(
            // Remove fixed height; allow gauge to dictate size
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  startAngle: 180,
                  endAngle: 0,
                  minimum: 0,
                  maximum: 100,
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: AxisLineStyle(
                    thickness: 0.3,
                    thicknessUnit: GaugeSizeUnit.factor,
                    color: Colors.grey.withOpacity(0.3),
                    cornerStyle: CornerStyle.bothCurve,
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: trait['percentage'].toDouble(),
                      width: 0.3,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: traitColors[index % traitColors.length], // Assign color based on index
                      cornerStyle: CornerStyle.bothCurve,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Text(
                        '${trait['percentage']}',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      angle: 90,
                      positionFactor: 0.000001,
                    ),
                    GaugeAnnotation(
                      widget: Text(
                        trait['reasoning'], // Use the reasoning dynamically
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 93, 93, 93),
                          fontFamily: "Inter-regular",
                        ),
                        textAlign: TextAlign.left,
                      ),
                      angle: 90,
                      positionFactor: 0.8,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 60.0), // Optional spacing at the bottom
        ],
      ),
    );
  },
),

                    ),
//                     const SizedBox(height: 16.0), // Add some spacing
//                     // Elevated button to fetch Holland Code
//                     ElevatedButton(
//                       onPressed: () async {
//                         // Show loading dialog
//                         showDialog(
//                           context: context,
//                           barrierDismissible: false,
//                           builder: (context) {
//                             return Dialog(
//                               child: Container(
//                                 padding: const EdgeInsets.all(16),
//                                 height: 300,
//                                 width: 300,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Lottie.asset(
//                                       'assets/icon/learning_loading.json', // Path to your Lottie animation file
//                                       width: 100,
//                                       height: 100,
//                                       fit: BoxFit.fill,
//                                     ),
//                                     const SizedBox(height: 20),
//                                     const Text(
//                                       'Holland Code is Generating\nAlmost Ready!',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontFamily: 'Inter-semibold',
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         );

// try {
//   // Make the API request
//   final response = await http.post(
//     Uri.parse('${RouteHosting.baseUrl}holland-code-personality-traits'),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({'uuid': userId}),
//   );

//   if (response.statusCode == 200) {
//     // Print the raw response to check its structure
//     print('Response body: ${response.body}');

//     // Parse the response as a Map
//     final Map<String, dynamic> data = jsonDecode(response.body);

//     // Check if the Holland_Code_Report key exists
//     if (data.containsKey('Holland_Code_Report')) {
//       final List<dynamic> hollandReport = data['Holland_Code_Report'];
//       print('Holland Code Report: $hollandReport');

//       // Convert the report to a List<Map<String, dynamic>>
//       List<Map<String, dynamic>> convertedReport = hollandReport.map((item) {
//         return {
//           'holland_code_name': item['holland_code_name'],
//           'percentage': item['percentage'].toDouble(), // Ensure percentage is a double
//           'reasoning': item['reasoning']
//         };
//       }).toList();

//       // Close the loading dialog
//       Navigator.of(context).pop();

//       // Navigate to Holland screen, passing the convertedReport data
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => Holland(
//             hollandData: convertedReport, // Pass the modified List directly
//           ),
//         ),
//       );
//     } else {
//       throw Exception('Holland_Code_Report data not found in response.');
//     }
//   } else {
//     throw Exception('Failed to load personality traits');
//   }
// } catch (e) {
//   print(e);
//   // Handle errors (e.g., show a Snackbar or AlertDialog)
//   Navigator.of(context).pop(); // Close the loading dialog
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Error'),
//         content: const Text('Failed to fetch personality traits. Please try again later.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       );
//     },
//   );
// }

//                       },
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Color(0xFF006FFD),
//                         backgroundColor: Color.fromARGB(255, 255, 255, 255),
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 12, horizontal: 22),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                       ),
//                       child: const Text(
//                         'Holland Code',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontFamily: "Inter-semibold",
//                         ),
//                       ),
//                     ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
