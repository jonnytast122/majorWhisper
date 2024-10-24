import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:majorwhisper/screens/Home.dart';

class Bigfive extends StatefulWidget {
  @override
  _BigfiveState createState() => _BigfiveState();
}

class _BigfiveState extends State<Bigfive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.73,
              decoration: const BoxDecoration(
                color: Color(0xFF006FFD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: 2, // Update based on your list length
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20.0),
                          Text(
                            "Openness to Experience", // Replace with dynamic data
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: "Inter-bold",
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // Wrap the gauge in a SizedBox to control its size
                          SizedBox(
                            height: 250, // Adjust this height to make the gauge smaller
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
                                      value: 70,
                                      width: 0.3, // Adjust width to control pointer size
                                      sizeUnit: GaugeSizeUnit.factor,
                                      color: Color(0xFF805FDD),
                                      cornerStyle: CornerStyle.bothCurve,
                                    ),
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    // Annotation for the percentage value (70)
                                    GaugeAnnotation(
                                      widget: Text(
                                        '70',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      angle: 90,
                                      positionFactor:
                                          0.00001, // Position closer to the center
                                    ),
                                    // Additional annotation for the text below the percentage
                                    GaugeAnnotation(
                                      widget: Text(
                                        'You enjoy reflecting on your emotions (Q8) and helping others (Q6), which suggests a willingness to explore thoughts and experiences beyond the practical. However, you may prefer familiar routines (Q3), keeping this trait from being even higher.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color.fromARGB(255, 93, 93, 93),
                                          fontFamily: "Inter-regular",
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      angle: 90,
                                      positionFactor:
                                          0.6, // Increase positionFactor to move the text lower
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
