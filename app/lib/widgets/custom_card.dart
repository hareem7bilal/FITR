import 'package:flutter/material.dart';
import '../utils/color_extension.dart';

class CustomCard extends StatelessWidget {
  final String label;
  final Widget viewPage;
  final bool featureCompleted;
  final String imageUrl; // New field for the image

  const CustomCard({
    super.key,
    required this.label,
    required this.viewPage,
    this.featureCompleted = true,
    required this.imageUrl, // Image URL required
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          if (!featureCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('This feature has not been implemented yet')));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => viewPage));
          }
        },
        child: Container(
          height: 150, // Adjust the size to make it square
          width: 150, // Adjust the size to make it square
          decoration: BoxDecoration(
            color: TColor.primaryColor1, // Set the background color here
            borderRadius:
                BorderRadius.circular(10), // Example of rounded corners
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover, // Adjust as needed
                  ),
                ),
              ),
              const SizedBox(height: 10), // Space between image and label
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center, // Center-align the text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
