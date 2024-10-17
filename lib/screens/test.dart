import 'package:flutter/material.dart';
import 'dart:math';

// Arrow painter class
class ArrowPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final double arrowHeadSize;

  ArrowPainter({required this.start, required this.end, this.arrowHeadSize = 10});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw the main line of the arrow
    canvas.drawLine(start, end, paint);

    // Calculate the direction of the arrow
    final angle = atan2(end.dy - start.dy, end.dx - start.dx);

    // Create two points for the arrowhead
    // final arrowP1 = Offset(
    //   // end.dx - arrowHeadSize * cos(angle - radians(30)),
    //   // end.dy - arrowHeadSize * sin(angle - radians(30)),
    // );

    // final arrowP2 = Offset(
    //   end.dx - arrowHeadSize * cos(angle + radians(30)),
    //   end.dy - arrowHeadSize * sin(angle + radians(30)),
    // );

    // Draw the arrowhead
    // canvas.drawLine(end, arrowP1, paint);
    // canvas.drawLine(end, arrowP2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// RoadmapDisplay class
class RoadmapDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define box positions
    Offset box1Position = Offset(50, 100);
    Offset box2Position = Offset(200, 250);
    
    // Calculate box centers
    Offset box1Center = Offset(box1Position.dx + 50, box1Position.dy + 50); // Center of Box 1
    Offset box2Center = Offset(box2Position.dx + 50, box2Position.dy + 50); // Center of Box 2

    return Scaffold(
      appBar: AppBar(title: Text('Roadmap Display')),
      body: Center(
        child: Stack(
          children: [
            // Box 1
            Positioned(
              top: box1Position.dy,
              left: box1Position.dx,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: Center(child: Text('Box 1')),
              ),
            ),
            // Box 2
            Positioned(
              top: box2Position.dy,
              left: box2Position.dx,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.red,
                child: Center(child: Text('Box 2')),
              ),
            ),
            // Arrow between the boxes
            Positioned.fill(
              child: CustomPaint(
                painter: ArrowPainter(
                  start: box1Center,
                  end: box2Center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RoadmapDisplay(),
  ));
}
