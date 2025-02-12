import 'package:flutter/material.dart';
import 'package:majorwhisper/screens/Listmajors.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ListMajors screen and pass the title
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Listmajors(title: title),
          ),
        );
      },
      child: SizedBox( // Ensures a fixed size
        width: 180, // Set width explicitly
        height: 240, // Set height explicitly
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 75, 75, 75).withOpacity(0.15),
                blurRadius: 8,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded( // Allows image to fill available space
                child: Image.asset(
                  imagePath,
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter-bold',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Listmajors(title: title),
                    ),
                  );
                },
                child: Text(
                  "See Majors",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 86, 86, 86),
                    fontSize: 10,
                    fontFamily: 'Inter-regular',
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
