import 'dart:ui';
import 'package:flutter/material.dart';

class MindMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                "AI Engineer",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 500), // Adjusted height for larger map
                painter: MindMapPainter(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      // Dynamically building node groups
                      buildNodeGroup(["Mathematics in AI"], [], true),
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "SDS"],
                        ["Statistics", "Optimization", "Graph Theory", "Dasdas"],
                        false,
                      ),
                      buildNodeGroup(["Mathematics in AI"], [], true),
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "SDS"],
                        ["Statistics", "Optimization", "Graph Theory", "Dasdas"],
                        false,
                      ),
                      buildNodeGroup(["Mathematics in AI"], [], true),
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "SDS1"],
                        ["Statistics", "Optimization", "Graph Theory", "Dasdas2"],
                        false,
                      ),
                      buildNodeGroup(["Mathematics in AI"], [], true),
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "SDS1"],
                        ["Statistics", "Optimization", "Graph Theory", "Dasdas2"],
                        false,
                      ),
                      buildNodeGroup(["Mathematics in AI"], [], true),
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "SDS1"],
                        ["Statistics", "Optimization", "Graph Theory", "Dasdas2"],
                        false,
                      ),
                      // Dynamically building node groups
                      buildNodeGroup(["Mathematics in AI"], [], true),
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "SDS"],
                        ["Statistics", "Optimization", "Graph Theory", "Dasdas"],
                        false,
                      ),
                      buildNodeGroup(["Mathematics in AI"], [], true),
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "SDS"],
                        ["Statistics", "Optimization", "Graph Theory", "Dasdas"],
                        false,
                      ),
                      buildNodeGroup(["Mathematics in AI"], [], true),
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "SDS1"],
                        ["Statistics", "Optimization", "Graph Theory", "Dasdas2"],
                        false,
                      ),
                      buildNodeGroup(["Mathematics in AI"], [], true),
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "SDS1"],
                        ["Statistics", "Optimization", "Graph Theory", "Dasdas2"],
                        false,
                      ),
                      buildNodeGroup(["Mathematics in AI"], [], true),
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "SDS1"],
                        ["Statistics", "Optimization", "Graph Theory", "Dasdas2"],
                        false,
                      ),
                      buildNodeGroup(["Mathematics in AI"], [], true),
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "SDS1"],
                        ["Statistics", "Optimization", "Graph Theory", "Dasdas2"],
                        false,
                      ),
                      buildNodeGroup(["Mathematics in AI"], [], true),
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "SDS1"],
                        ["Statistics", "Optimization", "Graph Theory", "Dasdas2"],
                        false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build node groups dynamically
  Widget buildNodeGroup(List<String> leftNodes, List<String> rightNodes, bool isCentered) {
    return Row(
      mainAxisAlignment: isCentered
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        if (!isCentered)
          Column(
            children: leftNodes.map((label) => NodeWidget(label: label)).toList(),
          ),
        if (isCentered)
          NodeWidget(
            label: leftNodes[0],
            color: Color(0xFF006FFD), // Highlighted node for centered ones
          ),
        if (!isCentered)
          Column(
            children: rightNodes.map((label) => NodeWidget(label: label)).toList(),
          ),
      ],
    );
  }
}

class NodeWidget extends StatelessWidget {
  final String label;
  final Color color;

  const NodeWidget({
    required this.label,
    this.color = const Color.fromARGB(255, 124, 181, 255), // Default color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      padding: EdgeInsets.symmetric(horizontal: 22.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 120, // Minimum width
          maxWidth: 120, // Set a max width for the container
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: color, // Use the passed color
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    maxLines: 3, // Allow up to 2 lines
                    overflow: TextOverflow.ellipsis, // Show ellipsis for overflow
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MindMapPainter extends CustomPainter {
  // Data for left and right nodes to avoid hardcoding
  final List<String> leftNodes = ["Linear Algebra", "Calculus", "Probability", "SDS"];
  final List<String> rightNodes = ["Statistics", "Optimization", "Graph Theory", "Dasdas"];

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 156, 210, 255)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Central vertical line for the main node "Mathematics in AI"
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
    
    // Initial vertical shift values for node groups
    double verticalShift = 0;
    double verticalStep = 270; // This controls the gap between node groups

    // Loop through as many groups as needed
    for (int groupIndex = 0; groupIndex < 12; groupIndex++) {
      // Apply vertical shift for each new group of nodes
      double groupShift = verticalShift + groupIndex * verticalStep;

      // Left Side Nodes (move down, then left)
      for (int i = 0; i < leftNodes.length; i++) {
        double horizontalShift = 30 - (i * 5); // Adjust horizontal shift slightly for each node
        _drawFlippedLLine(
          canvas, paint,
          Offset(size.width / 2 - horizontalShift, 30 + groupShift),
          Offset(size.width / 3, 85 + i * 50 + groupShift)  // Adjust vertical position per node
        );
      }

      // Right Side Nodes (move down, then right)
      for (int i = 0; i < rightNodes.length; i++) {
        double horizontalShift = 30 - (i * 5); // Adjust horizontal shift slightly for each node
        _drawFlippedLLine(
          canvas, paint,
          Offset(size.width / 2 + horizontalShift, 30 + groupShift),
          Offset(2 * size.width / 3, 85 + i * 50 + groupShift)  // Adjust vertical position per node
        );
      }
    }
  }

  void _drawFlippedLLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    Path path = Path();

    // Draw the vertical part of the L
    path.moveTo(start.dx, start.dy);
    path.lineTo(start.dx, end.dy); // Move down vertically to the same Y-level as the end point

    // Draw the horizontal part of the L
    path.lineTo(end.dx, end.dy); // Move horizontally to the end point (left or right)

    // Dash settings
    double dashWidth = 1.0, dashSpace = 5.0;
    bool draw = true;

    // Create dashed effect by iterating through the path's metrics
    for (PathMetric pathMetric in path.computeMetrics()) {
      for (double distance = 0.0; distance < pathMetric.length; distance += dashWidth + dashSpace) {
        final segment = pathMetric.extractPath(
            distance, distance + (draw ? dashWidth : dashSpace));
        canvas.drawPath(segment, paint);
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
