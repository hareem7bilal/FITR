import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter/material.dart';

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

  KeypointPainter({
    required this.results,
    required this.previewH,
    required this.previewW,
    required this.screenH,
    required this.screenW,
    required this.model,
  });

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
        [5, 7], // leftShoulder to leftElbow (assuming leftShoulder is 5)
        [7, 9], // leftElbow to leftWrist
        [6, 8], // rightShoulder to rightElbow (assuming rightShoulder is 6)
        [8, 10], // rightElbow to rightWrist
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
