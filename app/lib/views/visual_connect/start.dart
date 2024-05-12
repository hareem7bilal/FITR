import 'package:flutter/material.dart';
import 'api.dart';
import 'join_screen.dart';
import 'room_screen.dart';
import 'package:flutter_application_1/utils/color_extension.dart';

class VideoSDKQuickStart extends StatefulWidget {
  const VideoSDKQuickStart({super.key});

  @override
  State<VideoSDKQuickStart> createState() => _VideoSDKQuickStartState();
}

class _VideoSDKQuickStartState extends State<VideoSDKQuickStart> {
  String roomId = "";
  bool isRoomActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primaryColor1,
        title: const Text(
          "VisualConnect",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w400,
            color: Colors.white, // Add color property here
          ),
        ),
        iconTheme:
            const IconThemeData(color: Colors.white), // Set back button color
      ),
      body: isRoomActive
          ? RoomScreen(
              roomId: roomId,
              token: token,
              leaveRoom: () {
                setState(() => isRoomActive = false);
              },
            )
          : JoinScreen(
              onRoomIdChanged: (value) => roomId = value,
              onCreateRoomButtonPressed: () async {
                roomId = await createRoom();
                setState(() => isRoomActive = true);
              },
              onJoinRoomButtonPressed: () {
                setState(() => isRoomActive = true);
              },
            ),
    );
  }
}
