import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';

class RoomControls extends StatelessWidget {
  final void Function() onToggleMicButtonPressed;
  final void Function() onToggleCameraButtonPressed;
  final void Function() onLeaveButtonPressed;
  final bool micEnabled;
  final bool camEnabled;

  const RoomControls({
    super.key,
    required this.onToggleMicButtonPressed,
    required this.onToggleCameraButtonPressed,
    required this.onLeaveButtonPressed,
    required this.micEnabled,
    required this.camEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: TColor.white, //change background color of button
              backgroundColor:
                  TColor.primaryColor1, //change text color of button
              textStyle: TextStyle(color: TColor.white)), // Set the text color
          onPressed: onLeaveButtonPressed,
          child: const Text("Leave"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: TColor.white, //change background color of button
              backgroundColor:
                  TColor.primaryColor1, //change text color of button
              textStyle: TextStyle(color: TColor.white)), // Set the text color
          onPressed: onToggleMicButtonPressed,
          child: Icon(
            micEnabled? Icons.mic
                : Icons.mic_off, // Toggle between mic and mic off icons
            size: 24, // Adjust icon size as needed
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: TColor.white, //change background color of button
              backgroundColor:
                  TColor.primaryColor1, //change text color of button
              textStyle: TextStyle(color: TColor.white)), // Set the text color
          onPressed: onToggleCameraButtonPressed,
           child: Icon(
            camEnabled?
               Icons.videocam : Icons.videocam_off ,// Toggle between cam and cam off icons
            size: 24, // Adjust icon size as needed
          ),
        )
      ],
    );
  }
}
