import 'package:flutter/material.dart';
import 'package:widget_arrows/arrows.dart';
import 'package:widget_arrows/widget_arrows.dart';
import 'package:majorwhisper/screens/Home.dart';

// Define NodeWidget class first
class NodeWidget extends StatelessWidget {
  final String label;
  final Color color;

  const NodeWidget({
    required this.label,
    this.color = const Color.fromARGB(255, 124, 181, 255),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 50,
          maxWidth: 100,
          minHeight: 30,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.data['goal'] + "\nRoadmap",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
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

    for (var milestone in widget.data['roadmap']) {
      var milestoneKey = milestone['milestone_name'];

      // Adding milestone
      nodes.add(
        ArrowElement(
          id: milestoneKey,
          child: NodeWidget(
            label: milestone['milestone_name'],
            color: Color(0xFF006FFD),
          ),
        ),
      );

      // Adding arrows coming out of the left and right side of the milestone
      nodes.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side topics (arrows coming out of the left)
          Column(
            children: (milestone['topics'] as List<dynamic>)
                .sublist(0, 4) // Adjust for the number of topics you have
                .map((topic) {
              var topicKey = topic.toString();
              return ArrowElement(
                id: topicKey,
                targetId: milestoneKey,
                sourceAnchor: Alignment.centerRight, // Arrow comes out from right side of the topic
                targetAnchor: Alignment.centerLeft, // Points to the left side of the milestone
                arcDirection: ArcDirection.Right, // Curves to the right
                tipLength: 1,
                flip: true, // Flip to reverse the direction of the arrow
                child: NodeWidget(label: topic.toString()),
              );
            }).toList(),
          ),
          // Right side topics (arrows coming out of the right)
          Column(
            children: (milestone['topics'] as List<dynamic>)
                .sublist(4) // Adjust for the number of topics you have
                .map((topic) {
              var topicKey = topic.toString();
              return ArrowElement(
                id: topicKey,
                targetId: milestoneKey,
                sourceAnchor: Alignment.centerLeft, // Arrow comes out from left side of the topic
                targetAnchor: Alignment.centerRight, // Points to the right side of the milestone
                arcDirection: ArcDirection.Left, // Curves to the left
                tipLength: 1,
                child: NodeWidget(label: topic.toString()),
              );
            }).toList(),
          ),
        ],
      ));
    }

    return nodes;
  }
}

class MindMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = Color.fromARGB(255, 60, 144, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

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