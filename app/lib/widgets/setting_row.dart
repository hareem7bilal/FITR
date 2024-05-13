import 'package:flutter/material.dart';
import '../utils/color_extension.dart';
import '../views/progress_tracker/photo_progress_view.dart'; // Import the PhotoProgressView widget
import '../views/home/activity_tracker_view.dart'; // Import the ActivityTrackerView widget

class SettingRow extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onPressed;

  const SettingRow({super.key, required this.icon, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Conditionally navigate based on the title
        if (title == "Workout Progress") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PhotoProgressView()),
          );
        } else if (title == "Activity History") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ActivityTrackerView()),
          );
        }
      },
      child: SizedBox(
        height: 30,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 25),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 12,
                ),
              ),
            ),
            Image.asset(
              "assets/images/icons/next.png",
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}