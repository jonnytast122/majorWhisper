import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Holland extends StatelessWidget {
  final List<Map<String, dynamic>> hollandData; // Accept the Holland data as a List

  Holland({required this.hollandData});

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
                Navigator.of(context).pop();
              },
            ),
          ),
          title: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Holland Code',
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
      body: Stack(
        children: [
          Container(
            color: Colors.white,
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
                  itemCount: hollandData.length,
                  itemBuilder: (context, index) {
                    final trait = hollandData[index];
                    final traitName = trait['holland_code_name'];
                    final percentage = trait['percentage'];
                    final reasoning = trait['reasoning'];

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
                          const SizedBox(height: 10.0),
                          Text(
                            '$traitName (${percentage.toStringAsFixed(0)}%)', // Display trait name and its percentage
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: "Inter-bold",
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          // Wrap the gauge in a SizedBox to control its size
                          SizedBox(
                            height: 160,
                            child: SfRadialGauge(
                              axes: <RadialAxis>[
                                RadialAxis(
                                  startAngle: 120,
                                  endAngle: 420,
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
                                      value: percentage.toDouble(),
                                      width: 0.3,
                                      sizeUnit: GaugeSizeUnit.factor,
                                      color: Color(0xFF805FDD), // Change color dynamically if needed
                                      cornerStyle: CornerStyle.bothCurve,
                                    ),
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    // Annotation for the percentage value
                                    GaugeAnnotation(
                                      widget: Text(
                                        '${percentage.toStringAsFixed(0)}%', // Show percentage without decimal
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(0.1),
                                              offset: Offset(1, 1),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                      angle: 90,
                                      positionFactor: 0.1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            reasoning,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 107, 107, 107),
                              fontFamily: "Inter-regular",
                            ),
                          ),
                          const SizedBox(height: 20.0),
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
