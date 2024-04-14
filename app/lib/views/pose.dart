//originally main.dart
import 'package:flutter/material.dart';
import 'vision_detector/pose_detector_view.dart';
import 'DL_models/posenet/main.dart';
import 'DL_models/flask/openpose_img.dart';
import 'DL_models/flask/openpose_realtime.dart';
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
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  CustomCard(
                      'Google Mediapipe Pose Detection', PoseDetectorView()),
                  CustomCard(
                      'Openpose Realtime Pose Detection', OpenPoseRealtime()),
                  CustomCard(
                      'Openpose Image Pose Detection', OpenPoseImg()),
                  CustomCard(
                      'Posenet Pose Detection', Posenet()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

