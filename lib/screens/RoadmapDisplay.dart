import 'package:flutter/material.dart';
import 'package:widget_arrows/widget_arrows.dart';

class RoadmapDisplay extends StatefulWidget {
  final String majorName;
  final Map<String, dynamic> data;

  RoadmapDisplay({
    required this.majorName,
    required this.data,
  });

  @override
  _RoadmapDisplayState createState() => _RoadmapDisplayState();
}

class _RoadmapDisplayState extends State<RoadmapDisplay> {
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
                widget.majorName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              ArrowContainer(
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 800),
                  painter: MindMapPainter(),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: _buildRoadmapNodes(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build roadmap nodes from the data map
List<Widget> _buildRoadmapNodes() {
  List<Widget> nodes = [];

  // Loop through the milestones in the data map
  for (var milestone in widget.data['roadmap']) {
    // Add milestone title node
    var milestoneKey = milestone['milestone_name'];
    
    nodes.add(
      ArrowElement(
        id: milestoneKey, // Unique ID for milestone
        child: NodeWidget(
          label: milestone['milestone_name'],
          color: Color(0xFF006FFD),
        ),
      ),
    );

    // Create a row for topics
    nodes.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: (milestone['topics'] as List<dynamic>)
              .sublist(0, 4)
              .map((topic) {
            var topicKey = topic.toString();
            return Column(
              children: [
                // Connect arrow from milestone to the topic
                ArrowElement(
                  id: topicKey, // Unique ID for the arrow connection
                  targetId: milestoneKey, // ID for the topic
                  sourceAnchor: Alignment.centerRight, // Anchor at the bottom of the milestone
                  targetAnchor: Alignment.bottomCenter, // Anchor at the top of the topic
                  child: NodeWidget(label: topic.toString()),
                ),
              ],
            );
          }).toList(),
        ),
        Column(
          children: (milestone['topics'] as List<dynamic>)
              .sublist(4)
              .map((topic) {
            var topicKey = topic.toString();
            return Column(
              children: [
                // Connect arrow from milestone to the topic
                ArrowElement(
                  id: topicKey, // Unique ID for the arrow connection
                  targetId: milestoneKey, // ID for the topic
                  sourceAnchor: Alignment.centerLeft, // Anchor at the bottom of the milestone
                  targetAnchor: Alignment.bottomCenter, // Anchor at the top of the topic
                  child: NodeWidget(label: topic.toString()),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    ));
  }

  return nodes;
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
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 100,
          maxWidth: 150,
          minHeight: 30,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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
    Paint linePaint = Paint()
      ..color = Color(0xFF006FFD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw central vertical line
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
