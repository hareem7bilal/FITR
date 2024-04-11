import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';

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
    // This method now returns List<Widget> directly
    List<Widget> renderKeypoints() {
      List<Widget> widgets = [];
      for (var re in results) {
        //var keypoints = re["keypoints"].values as List<dynamic>; // Ensure this cast aligns with your data structure
        var keypointsIterable = re["keypoints"].values;
        var keypoints = keypointsIterable.toList();

        for (var k in keypoints) {
          var x = k["x"] as double; // Assuming 'x' and 'y' are of type double
          var y = k["y"] as double;

          double scaleW, scaleH, posX, posY;

          if (screenH / screenW > previewH / previewW) {
            scaleW = screenH / previewH * previewW;
            scaleH = screenH;
            var difW = (scaleW - screenW) / scaleW;
            posX = (x - difW / 2) * scaleW;
            posY = y * scaleH;
          } else {
            scaleH = screenW / previewW * previewH;
            scaleW = screenW;
            var difH = (scaleH - screenH) / scaleH;
            posX = x * scaleW;
            posY = (y - difH / 2) * scaleH;
          }
          widgets.add(
            Positioned(
              left: posX - 6,
              top: posY - 6,
              width: 100,
              height: 12,
              child: Text(
                "● ${k["part"]}",
                style: TextStyle(
                  color: TColor.primaryColor1,
                  fontSize: 12.0,
                ),
              ),
            ),
          );
        }
      }
      return widgets;
    }

    return Stack(children: renderKeypoints());
  }
}
