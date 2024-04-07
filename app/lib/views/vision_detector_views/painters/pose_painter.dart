import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'coordinates_translator.dart';

class PosePainter extends CustomPainter {
  PosePainter(
    this.poses,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
  );

  final List<Pose> poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.blue;

    final lpaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = Colors.white;

    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
            Offset(
              translateX(
                landmark.x,
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
              translateY(
                landmark.y,
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
            ),
            2,
            lpaint);
      });

      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
            Offset(
                translateX(
                  joint1.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint1.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            Offset(
                translateX(
                  joint2.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint2.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            paintType);
      }

      //Draw arms
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, paint);
      paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, paint);
      paintLine(
          PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, paint);
      paintLine(
          PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, paint);

      //Draw Body
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, paint);
      paintLine(
          PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, paint);

      //Draw legs
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, paint);
      paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, paint);
      paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, paint);
      paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, paint);

      // Left hand
      paintLine(PoseLandmarkType.leftWrist, PoseLandmarkType.leftThumb,
          paint); // Thumb
      paintLine(PoseLandmarkType.leftWrist, PoseLandmarkType.leftIndex,
          paint); // Index finger
      paintLine(PoseLandmarkType.leftWrist, PoseLandmarkType.leftPinky,
          paint); // Middle finger

      // Right hand
      paintLine(PoseLandmarkType.rightWrist, PoseLandmarkType.rightThumb,
          paint); // Thumb
      paintLine(PoseLandmarkType.rightWrist, PoseLandmarkType.rightIndex,
          paint); // Index finger
      paintLine(PoseLandmarkType.rightWrist, PoseLandmarkType.rightPinky,
          paint); // Middle finger

      // Draw lines for toes and feet
      // Left foot
      paintLine(
          PoseLandmarkType.leftAnkle, PoseLandmarkType.leftHeel, paint); // Heel
      paintLine(PoseLandmarkType.leftHeel, PoseLandmarkType.leftFootIndex,
          paint); // Foot index

      // Right foot
      paintLine(PoseLandmarkType.rightAnkle, PoseLandmarkType.rightHeel,
          paint); // Heel
      paintLine(PoseLandmarkType.rightHeel, PoseLandmarkType.rightFootIndex,
          paint); // Foot inde

      // Now, let's draw angle annotations
      pose.angles?.forEach((angleName, angleValue) {
        // Determine the position for displaying the angle based on related landmarks
        // Here, we simply choose a landmark's position as an example
        PoseLandmark? landmark;

        if (angleName.contains("Elbow")) {
          landmark = angleName.contains("Right")
              ? pose.landmarks[PoseLandmarkType.rightElbow]
              : pose.landmarks[PoseLandmarkType.leftElbow];
        } else if (angleName.contains("Knee")) {
          landmark = angleName.contains("Right")
              ? pose.landmarks[PoseLandmarkType.rightKnee]
              : pose.landmarks[PoseLandmarkType.leftKnee];
        } else if (angleName.contains("Shoulder")) {
          landmark = angleName.contains("Right")
              ? pose.landmarks[PoseLandmarkType.rightShoulder]
              : pose.landmarks[PoseLandmarkType.leftShoulder];
        } else if (angleName.contains("Hip")) {
          landmark = angleName.contains("Right")
              ? pose.landmarks[PoseLandmarkType.rightHip]
              : pose.landmarks[PoseLandmarkType.leftHip];
        } else if (angleName.contains("Ankle")) {
          landmark = angleName.contains("Right")
              ? pose.landmarks[PoseLandmarkType.rightAnkle]
              : pose.landmarks[PoseLandmarkType.leftAnkle];
        } else if (angleName.contains("Foot")) {
          landmark = angleName.contains("Right")
              ? pose.landmarks[PoseLandmarkType
                  .rightHeel] // Using Heel as a reference for Foot
              : pose.landmarks[PoseLandmarkType.leftHeel];
        } else if (angleName.contains("Toe Point")) {
          landmark = angleName.contains("Right")
              ? pose.landmarks[PoseLandmarkType
                  .rightFootIndex] // Using Foot Index as a reference for Toe Point
              : pose.landmarks[PoseLandmarkType.leftFootIndex];
        }
        // Add other conditions for different angles as necessary

        if (landmark != null) {
          final Offset offset = Offset(
            translateX(
                landmark.x, size, imageSize, rotation, cameraLensDirection),
            translateY(
                landmark.y, size, imageSize, rotation, cameraLensDirection),
          );
          drawText(canvas, offset, "$angleValue°", textStyle);
        }
      });
    }
  }

  void drawText(
      Canvas canvas, Offset position, String text, TextStyle textStyle) {
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }
}
