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
                size: Size(MediaQuery.of(context).size.width,
                    500), // Adjusted height for larger map
                painter: MindMapPainter(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      // Centered Main Node for "Mathematics in AI"
                      buildNodeGroup(["Mathematics in AI"], [], true),

                      // Left and Right Child Nodes
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "sds"],
                        [
                          "Statistics",
                          "Optimization In",
                          "Graph Theory",
                          "dasdas"
                        ],
                        false,
                      ),

                      buildNodeGroup(["Mathematics in AI2"], [], true),

                      // Left and Right Child Nodes
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "sds"],
                        [
                          "Statistics",
                          "Optimization In",
                          "Graph Theory",
                          "dasdas"
                        ],
                        false,
                      ),

                      buildNodeGroup(["Mathematics in AI3"], [], true),

                      // Left and Right Child Nodes
                      buildNodeGroup(
                        ["Linear Algebra", "Calculus", "Probability", "sds"],
                        [
                          "Statistics",
                          "Optimization In",
                          "Graph Theory",
                          "dasdas"
                        ],
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
  Widget buildNodeGroup(
      List<String> leftNodes, List<String> rightNodes, bool isCentered) {
    return Row(
      mainAxisAlignment: isCentered
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        if (!isCentered)
          Column(
            children:
                leftNodes.map((label) => NodeWidget(label: label)).toList(),
          ),
        if (isCentered)
          NodeWidget(
            label: leftNodes[0],
            color: Color(0xFF006FFD), // Highlighted node for centered ones
          ),
        if (!isCentered)
          Column(
            children:
                rightNodes.map((label) => NodeWidget(label: label)).toList(),
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
                    overflow:
                        TextOverflow.ellipsis, // Show ellipsis for overflow
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

    // First Node Group
    // Left Side Flipped L-Shaped Lines (move down, then left, with a slight horizontal shift)
    _drawFlippedLLine(canvas, paint, Offset(size.width / 2 - 40, 10),
        Offset(size.width / 3, 80)); // Linear Algebra
    _drawFlippedLLine(canvas, paint, Offset(size.width / 2 - 35, 10),
        Offset(size.width / 3, 130)); // Calculus
    _drawFlippedLLine(canvas, paint, Offset(size.width / 2 - 30, 10),
        Offset(size.width / 3, 190)); // Probability
    _drawFlippedLLine(canvas, paint, Offset(size.width / 2 - 25, 10),
        Offset(size.width / 3, 240)); // SDS

    // Right Side Flipped L-Shaped Lines (move down, then right, with a slight horizontal shift)
    _drawFlippedLLine(canvas, paint, Offset(size.width / 2 + 40, 10),
        Offset(2 * size.width / 3, 80)); // Statistics
    _drawFlippedLLine(canvas, paint, Offset(size.width / 2 + 35, 10),
        Offset(2 * size.width / 3, 130)); // Optimization
    _drawFlippedLLine(canvas, paint, Offset(size.width / 2 + 30, 10),
        Offset(2 * size.width / 3, 190)); // Graph Theory
    _drawFlippedLLine(canvas, paint, Offset(size.width / 2 + 25, 10),
        Offset(2 * size.width / 3, 240)); // Dasdas

    // Second Node Group (shifted down by 300px to avoid overlap)
    double verticalShift = 270;

    // Left Side Flipped L-Shaped Lines for second node group
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 - 40, 10 + verticalShift),
        Offset(size.width / 3, 80 + verticalShift)); // Linear Algebra
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 - 35, 10 + verticalShift),
        Offset(size.width / 3, 130 + verticalShift)); // Calculus
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 - 30, 10 + verticalShift),
        Offset(size.width / 3, 190 + verticalShift)); // Probability
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 - 25, 10 + verticalShift),
        Offset(size.width / 3, 240 + verticalShift)); // SDS

    // Right Side Flipped L-Shaped Lines for second node group
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 + 40, 10 + verticalShift),
        Offset(2 * size.width / 3, 80 + verticalShift)); // Statistics
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 + 35, 10 + verticalShift),
        Offset(2 * size.width / 3, 130 + verticalShift)); // Optimization
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 + 30, 10 + verticalShift),
        Offset(2 * size.width / 3, 190 + verticalShift)); // Graph Theory
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 + 25, 10 + verticalShift),
        Offset(2 * size.width / 3, 240 + verticalShift)); // Dasdas

    // Second Node Group (shifted down by 300px to avoid overlap)
    double verticalShift2 = 570;

    // Left Side Flipped L-Shaped Lines for second node group
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 - 40, 10 + verticalShift2),
        Offset(size.width / 3, 80 + verticalShift2)); // Linear Algebra
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 - 35, 10 + verticalShift2),
        Offset(size.width / 3, 130 + verticalShift2)); // Calculus
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 - 30, 10 + verticalShift2),
        Offset(size.width / 3, 190 + verticalShift2)); // Probability
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 - 25, 10 + verticalShift2),
        Offset(size.width / 3, 240 + verticalShift2)); // SDS

    // Right Side Flipped L-Shaped Lines for second node group
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 + 40, 10 + verticalShift2),
        Offset(2 * size.width / 3, 80 + verticalShift2)); // Statistics
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 + 35, 10 + verticalShift2),
        Offset(2 * size.width / 3, 130 + verticalShift2)); // Optimization
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 + 30, 10 + verticalShift2),
        Offset(2 * size.width / 3, 190 + verticalShift2)); // Graph Theory
    _drawFlippedLLine(
        canvas, paint, Offset(size.width / 2 + 25, 10 + verticalShift2),
        Offset(2 * size.width / 3, 240 + verticalShift2)); // Dasdas
  }

  void _drawFlippedLLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    Path path = Path();

    // Draw the vertical part of the L
    path.moveTo(start.dx, start.dy);
    path.lineTo(start.dx,
        end.dy); // Move down vertically to the same Y-level as the end point

    // Draw the horizontal part of the L
    path.lineTo(
        end.dx, end.dy); // Move horizontally to the end point (left or right)

    // Dash settings
    double dashWidth = 1.0,
        dashSpace = 5.0; // Adjusted values for better visibility
    bool draw = true;

    // Create dashed effect by iterating through the path's metrics
    for (PathMetric pathMetric in path.computeMetrics()) {
      for (double distance = 0.0;
          distance < pathMetric.length;
          distance += dashWidth + dashSpace) {
        final segment = pathMetric.extractPath(
            distance, distance + (draw ? dashWidth : dashSpace));
        canvas.drawPath(segment, paint);
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // You can return true if you want to trigger a repaint
  }
}
