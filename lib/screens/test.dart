import 'package:flutter/material.dart';

class RoadmapDisplay extends StatelessWidget {
  final Map<String, dynamic> roadmapData = {
    "AI Engineer": {
      "Introduction to AI": [
        "Definition of AI",
        "Importance of AI",
        "Types of AI",
        "Application AI",
        "Future of AI",
        "Limitations of AI"
      ],
      "Mathematics for AI": [
        "Linear Algebra",
        "Calculus",
        "Probability",
        "Optimization",
        "Graph Theory",
        "Complex Variables"
      ],
      "Programming for AI": [
        "Python for AI",
        "Java for AI",
        "R for AI",
        "Julia for AI",
        "Prolog for AI",
        "Lisp for AI"
      ]
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Roadmap')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RoadmapNode(
              category: "AI Engineer",
              milestones: roadmapData["AI Engineer"],
            ),
          ],
        ),
      ),
    );
  }
}

class RoadmapNode extends StatelessWidget {
  final String category;
  final Map<String, List<String>> milestones;

  RoadmapNode({required this.category, required this.milestones});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(height: 20),
        for (String milestone in milestones.keys)
          MilestoneSection(
            milestone: milestone,
            topics: milestones[milestone]!,
          ),
      ],
    );
  }
}

class MilestoneSection extends StatelessWidget {
  final String milestone;
  final List<String> topics;

  MilestoneSection({required this.milestone, required this.topics});

  @override
  Widget build(BuildContext context) {
    // Split topics into left and right
    List<String> leftTopics = topics.sublist(0, (topics.length / 2).ceil());
    List<String> rightTopics = topics.sublist((topics.length / 2).ceil());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left side topics
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (String topic in leftTopics)
                  TopicCard(
                    topic: topic,
                    alignment: CrossAxisAlignment.end,
                  ),
              ],
            ),
          ),
          // Milestone in the center
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  milestone,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Draw lines/arrows from topics to the milestone
              CustomPaint(
                size: Size(100, 100),
                painter: ArrowPainter(),
              ),
            ],
          ),
          // Right side topics
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (String topic in rightTopics)
                  TopicCard(
                    topic: topic,
                    alignment: CrossAxisAlignment.start,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopicCard extends StatelessWidget {
  final String topic;
  final CrossAxisAlignment alignment;

  TopicCard({required this.topic, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        topic,
        style: TextStyle(color: Colors.white),
        textAlign: alignment == CrossAxisAlignment.end
            ? TextAlign.right
            : TextAlign.left,
      ),
    );
  }
}

// Custom painter to draw arrows from topics to the milestone
class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw example arrows from top to bottom
    // You can calculate the exact positions based on the widgets' layout.
    canvas.drawLine(Offset(0, 0), Offset(50, 50), paint); // Example arrow
    canvas.drawLine(Offset(100, 0), Offset(50, 50), paint); // Example arrow
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
