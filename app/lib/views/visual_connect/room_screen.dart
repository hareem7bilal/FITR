import 'package:flutter/material.dart';
import 'room_controls.dart';
import 'participant_tile.dart';
import 'package:videosdk/videosdk.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter/services.dart';

class RoomScreen extends StatefulWidget {
  final String roomId;
  final String token;
  final void Function() leaveRoom;

  const RoomScreen(
      {super.key,
      required this.roomId,
      required this.token,
      required this.leaveRoom});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  Map<String, Stream?> participantVideoStreams = {};

  bool micEnabled = true;
  bool camEnabled = true;
  late Room room;

  @override
  void dispose() {
    // Leave the room when the widget is disposed
    room.leave();
    super.dispose();
  }

  void setParticipantStreamEvents(Participant participant) {
    participant.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => participantVideoStreams[participant.id] = stream);
      }
    });

    participant.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => participantVideoStreams.remove(participant.id));
      }
    });
  }

  void setRoomEventListener(Room room) {
    setParticipantStreamEvents(room.localParticipant);
    room.on(
      Events.participantJoined,
      (Participant participant) => setParticipantStreamEvents(participant),
    );
    room.on(Events.participantLeft, (String participantId) {
      if (participantVideoStreams.containsKey(participantId)) {
        setState(() => participantVideoStreams.remove(participantId));
      }
    });
    room.on(Events.roomLeft, () {
      participantVideoStreams.clear();
      widget.leaveRoom();
    });
  }

  @override
  void initState() {
    super.initState();

    room = VideoSDK.createRoom(
      roomId: widget.roomId,
      token: widget.token,
      displayName: "Yash Chudasama",
      micEnabled: micEnabled,
      camEnabled: camEnabled,
      maxResolution: 'hd',
      defaultCameraIndex: 1,
      notification: const NotificationInfo(
        title: "Video SDK",
        message: "Video SDK is sharing screen in the room",
        icon: "notification_share", // drawable icon name
      ),
    );

    setRoomEventListener(room);

    // Join room
    room.join();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/pics/visual_connect.jpg",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 60, // Adjust height as needed
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ), // Add horizontal padding
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color.fromARGB(255, 145, 123, 185),
                    width: 1,
                  ),
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Align the icon and text to the center
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons
                              .auto_awesome_outlined, // Icon to represent creating a room
                          color: TColor.primaryColor1, // Color of the icon
                          size: 24, // Size of the icon
                        ),
                        const SizedBox(
                          width: 10,
                        ), // Add space between icon and text
                        Text(
                          "Room ID: ${widget.roomId}",
                          style: TextStyle(
                            color: TColor.primaryColor1,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        // Implement copy functionality here
                        // For example:
                        Clipboard.setData(ClipboardData(text: widget.roomId));
                        // Show a toast or snackbar to indicate the ID is copied
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Room ID copied!'),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.content_copy,
                        color: TColor.primaryColor1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              RoomControls(
                onToggleMicButtonPressed: () {
                  micEnabled ? room.muteMic() : room.unmuteMic();
                  micEnabled = !micEnabled;
                },
                onToggleCameraButtonPressed: () {
                  camEnabled ? room.disableCam() : room.enableCam();
                  camEnabled = !camEnabled;
                },
                onLeaveButtonPressed: () => room.leave(),
                micEnabled: micEnabled,
                camEnabled: camEnabled,
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection:
                      Axis.vertical, // Change to vertical if needed
                  children: participantVideoStreams.values
                      .map(
                        (e) => ParticipantTile(
                          stream: e!,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ));
  }
}
