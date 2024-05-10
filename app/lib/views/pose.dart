import 'package:flutter/material.dart';
import 'vision_detector/pose_detector_view.dart';
import 'DL_models/posenet/main.dart';
import 'DL_models/openpose/openpose_img.dart';
import 'DL_models/openpose/openpose_realtime.dart';
import 'opensim.dart';
import 'instability_assessment.dart';
import '../widgets/custom_card.dart';

class PoseDetector extends StatelessWidget {
  const PoseDetector({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pose Estimation'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 16, // Space between columns
              mainAxisSpacing: 16, // Space between rows
              childAspectRatio: 1, // Ratio to make it square
            ),
            itemCount: 6, // The number of CustomCards
            itemBuilder: (context, index) {
              List<CustomCard> cards = [
                const CustomCard(
                  label: 'Google Mediapipe Pose Detection',
                  viewPage: PoseDetectorView(),
                  imageUrl: 'assets/images/custom_card/mediapipe.png',
                ),
                const CustomCard(
                  label: 'Openpose Realtime Pose Detection',
                  viewPage: OpenPoseRealtime(),
                  imageUrl: 'assets/images/custom_card/openpose.png',
                ),
                const CustomCard(
                  label: 'Openpose Image Pose Detection',
                  viewPage: OpenPoseImg(),
                  imageUrl: 'assets/images/custom_card/openpose.png',
                ),
                const CustomCard(
                  label: 'Posenet Pose Detection',
                  viewPage: Posenet(),
                  imageUrl: 'assets/images/custom_card/posenet.png',
                ),
                const CustomCard(
                  label: 'OpenSim Inverse Kinematics',
                  viewPage: TRCProcessor(),
                  imageUrl: 'assets/images/custom_card/opensim.png',
                ),
                const CustomCard(
                  label: 'Ankle Instability Assessment',
                  viewPage: InstabilityDetector(),
                  imageUrl: 'assets/images/custom_card/ankle_instability.png',
                ),
              ];

              return cards[index]; // Return the CustomCard based on the index
            },
          ),
        ),
      ),
    );
  }
}
