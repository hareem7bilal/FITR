import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BindBox extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String model;

  const BindBox({
    super.key,
    required this.results,
    required this.previewH,
    required this.previewW,
    required this.screenH,
    required this.screenW,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    FlutterTts tts = FlutterTts();
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: KeypointPainter(
              results: results,
              previewH: previewH,
              previewW: previewW,
              screenH: screenH,
              screenW: screenW,
              model: model,
              tts: tts, // Pass it here
            ),
          ),
        ),
      ],
    );
  }
}

class KeypointPainter extends CustomPainter {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String model;
  final FlutterTts tts;

  KeypointPainter({
    required this.results,
    required this.previewH,
    required this.previewW,
    required this.screenH,
    required this.screenW,
    required this.model,
    required this.tts,
  });

  // Define dangerous ranges for different joints
  final Map<String, List<int>> dangerRanges = {
    'Left Elbow': [30, 150],
    'Right Elbow': [30, 150],
    'Left Knee': [30, 160],
    'Right Knee': [30, 160],
    'Left Shoulder': [20, 160],
    'Right Shoulder': [20, 160],
    'Left Hip': [30, 150],
    'Right Hip': [30, 150],
    'Left Ankle': [45, 135],
    'Right Ankle': [45, 135],
  };

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = TColor.primaryColor1
      ..strokeWidth = 3
      ..style = PaintingStyle.fill; // Changed to fill for visibility

    final linePaint = Paint()
      ..color = TColor.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final textStyle = TextStyle(
      color: TColor.grey,
      fontSize: 12,
    );

    for (var re in results) {
      if (model != "posenet") continue;
      var keypoints = re["keypoints"];
      Map<String, Offset> points = {};

      debugPrint("Keypoints data: $keypoints"); // Debugging output

      for (var key in keypoints.keys) {
        var k = keypoints[key];
        if (k["x"] != null && k["y"] != null) {
          double x = (k["x"] is int) ? k["x"].toDouble() : k["x"];
          double y = (k["y"] is int) ? k["y"].toDouble() : k["y"];
          double scaleW;
          double scaleH;
          double adjustedX;
          double adjustedY;

          if (screenH / screenW > previewH / previewW) {
            scaleW = screenH / previewH * previewW;
            scaleH = screenH;
            double difW = (scaleW - screenW) / scaleW;
            adjustedX = (x - difW / 2) * scaleW;
            adjustedY = y * scaleH;
          } else {
            scaleH = screenW / previewW * previewH;
            scaleW = screenW;
            double difH = (scaleH - screenH) / scaleH;
            adjustedX = x * scaleW;
            adjustedY = (y - difH / 2) * scaleH;
          }

          points[key.toString()] = Offset(adjustedX, adjustedY);

          canvas.drawCircle(points[key.toString()]!, 5, paint);

          TextSpan span =
              TextSpan(text: k['part'].toString(), style: textStyle);
          TextPainter(
              text: span,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center)
            ..layout()
            ..paint(canvas, points[key.toString()]! - const Offset(20, 12));

          var jointSets = [
            [5, 11, 13], // leftShoulder, leftHip, leftKnee
            [11, 13, 15], // leftHip, leftKnee, leftAnkle
            [6, 12, 14], // rightShoulder, rightHip, rightKnee
            [12, 14, 16], // rightHip, rightKnee, rightAnkle
            // Add more joint sets as needed
          ];

          for (var set in jointSets) {
            if (points.containsKey(set[0].toString()) &&
                points.containsKey(set[1].toString()) &&
                points.containsKey(set[2].toString())) {
              double angle = calculateAngle(
                points[set[0].toString()]!,
                points[set[1].toString()]!,
                points[set[2].toString()]!,
              );
              if (isDangerousAngle(set[1].toString(), angle)) {
                // Assuming isDangerousAngle function exists
                tts.speak(
                    'Dangerous ${set[1]} angle detected: $angle degrees.'); // Speak the warning
              }
              displayAngle(canvas, angle, points[set[1].toString()]!);
            }
          }
        } else {
          debugPrint("Missing x or y for key: $key");
        }
      }

      debugPrint("Points map: $points");

      // var connections = [
      //   ["nose", "leftEye"],
      //   ["nose", "rightEye"],
      //   ["leftEye", "leftEar"],
      //   ["rightEye", "rightEar"],
      //   ["neck", "nose"],
      //   ["neck", "rightShoulder"],
      //   ["neck", "leftShoulder"],
      //   ["leftShoulder", "leftElbow"],
      //   ["leftElbow", "leftWrist"],
      //   ["rightShoulder", "rightElbow"],
      //   ["rightElbow", "rightWrist"],
      //   ["neck", "rightHip"],
      //   ["rightHip", "rightKnee"],
      //   ["rightKnee", "rightAnkle"],
      //   ["neck", "leftHip"],
      //   ["leftHip", "leftKnee"],
      //   ["leftKnee", "leftAnkle"],
      // ];

      var connections = [
        [0, 1], // nose to leftEye
        [0, 2], // nose to rightEye
        [1, 3], // leftEye to leftEar
        [2, 4], // rightEye to rightEar
        // [5, 7], // leftShoulder to leftElbow
        // [7, 9], // leftElbow to leftWrist
        // [6, 8], // rightShoulder to rightElbow
        // [8, 10], // rightElbow to rightWrist
        // [5,11], //leftShoulder to leftHip
        // [6,12], //rightShoulder to rightHip
        // [6,12], //rightShoulder to rightHip
        // [11,13], //leftHip to leftKnee
        // [12,14], //rightHip to rightKnee
        // [13,15], //leftKnee to leftAnkle
        // [14,16], //rightKnee to rightAnkle
      ];

      for (var connection in connections) {
        debugPrint(
            "${points.containsKey(connection[0].toString())} and ${points.containsKey(connection[1].toString())}");

        if (points.containsKey(connection[0].toString()) &&
            points.containsKey(connection[1].toString())) {
          debugPrint(
              "Drawing line between ${connection[0]} and ${connection[1]}"); // Debugging output
          canvas.drawLine(points[connection[0].toString()]!,
              points[connection[1].toString()]!, linePaint);
        }
      }
    }
  }

  double calculateAngle(Offset p1, Offset p2, Offset p3) {
    final dx1 = p1.dx - p2.dx;
    final dy1 = p1.dy - p2.dy;
    final dx2 = p3.dx - p2.dx;
    final dy2 = p3.dy - p2.dy;
    final angle1 = math.atan2(dy1, dx1);
    final angle2 = math.atan2(dy2, dx2);
    double angle = (angle2 - angle1) * 180 / math.pi;
    if (angle < 0) angle += 360; // Ensure the angle is positive
    return angle;
  }

  void displayAngle(Canvas canvas, double angle, Offset position) {
    final angleText = '${angle.toStringAsFixed(1)}°';
    final textPainter = TextPainter(
      text: TextSpan(
          text: angleText, style: TextStyle(color: TColor.white, fontSize: 12)),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        position -
            Offset(textPainter.width / 2, 20)); // Adjust the position as needed
  }

  bool isDangerousAngle(String joint, double angle) {
    if (!dangerRanges.containsKey(joint)) return false;
    var range = dangerRanges[joint];
    return angle < range![0] || angle > range[1];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
