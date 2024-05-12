import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';

class JoinScreen extends StatelessWidget {
  final void Function() onCreateRoomButtonPressed;
  final void Function() onJoinRoomButtonPressed;
  final void Function(String) onRoomIdChanged;

  const JoinScreen({
    super.key,
    required this.onCreateRoomButtonPressed,
    required this.onJoinRoomButtonPressed,
    required this.onRoomIdChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/pics/visual_connect.jpg",
            ), // Background image
            fit: BoxFit.fill, // Stretch the image to fill the container
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20), // Add padding to the entire column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onCreateRoomButtonPressed,
                child: Container(
                  height: 60, // Adjust height as needed
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20), // Add horizontal padding
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color.fromARGB(255, 145, 123, 185), // Set border color
                      width: 1, // Set border width
                    ),
                    color: Colors.white
                        .withOpacity(0.8), // Semi-transparent white background
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons
                            .add_home_work_sharp, // Icon to represent creating a room
                        color: TColor.primaryColor1, // Color of the icon
                        size: 24, // Size of the icon
                      ),
                      const SizedBox(
                          width: 10), // Add space between icon and text
                      Text(
                        "Create a Room",
                        style: TextStyle(
                          color: TColor.primaryColor1,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  hintText: "Room ID",
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Set border radius
                    borderSide: BorderSide(
                      color: TColor.white, // Set border color
                      width: 4.0, // Set border width
                    ),
                  ),
                  filled: true, // Enable field background fill
                  fillColor: TColor.primaryColor1, // Set field background color
                  prefixIcon: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/icons/video_call.png",
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                      color: TColor.white,
                    ),
                  ),
                  hintStyle: TextStyle(color: TColor.white, fontSize: 12),
                ),
                onChanged: onRoomIdChanged,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      TColor.primaryColor1, // Change background color of button
                  backgroundColor: TColor.white, // Change text color of button
                  textStyle:
                      TextStyle(color: TColor.white), // Set the text color
                ),
                onPressed: onJoinRoomButtonPressed,
                child: const Text("Join"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
