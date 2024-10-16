import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';

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
  bool isSaved = false;

  Future<void> saveToFirestore() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('career_paths')
            .doc(userId);

        await userDoc.update({
          'data': FieldValue.arrayUnion([{
            'major_name': widget.majorName,
            'career_path': widget.data,
          }])
        }).catchError((error) async {
          await userDoc.set({
            'data': [{
              'major_name': widget.majorName,
              'career_path': widget.data,
            }]
          });
        });

        setState(() {
          isSaved = true;
        });

        DelightToastBar(
          position: DelightSnackbarPosition.top,
          autoDismiss: true,
          snackbarDuration: Duration(seconds: 2),
          builder: (context) => const ToastCard(
            leading: Icon(
              Icons.check_circle,
              size: 28,
              color: Colors.green,
            ),
            title: Text(
              "Career path saved successfully!",
              style: TextStyle(
                fontFamily: "Inter-semibold",
                fontSize: 14,
                color: Colors.green,
              ),
            ),
          ),
        ).show(context);
      } else {
        print('No user logged in');
      }
    } catch (e) {
      print('Error saving career path: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final major = widget.data['goal']; // Accessing the 'goal' in the data
    final milestones = widget.data['roadmap']; // Accessing the roadmap list

    if (milestones == null || milestones.isEmpty) {
      return Center(child: Text('No roadmap available.'));
    }

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header section
              Container(
                padding: const EdgeInsets.only(top: 0),
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4A90E2), // Blue color
                      Color(0xFF006FFD), // White color
                    ],
                    stops: [0.3, 1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(height: 60),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context); // Navigates back to the previous screen
                            },
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "$major Roadmap",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Inter-semibold',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Content section with milestones
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var milestone in milestones)
                      MilestoneCard(milestone: milestone),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget for rendering a Milestone
class MilestoneCard extends StatelessWidget {
  final Map<String, dynamic> milestone;

  MilestoneCard({required this.milestone});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              milestone['milestone_name'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (String topic in milestone['topics'])
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(topic)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
