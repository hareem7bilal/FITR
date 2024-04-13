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
    List<Widget> renderKeypoints() {
      if (model != "posenet") {
        return <Widget>[]; // Return empty list if model check fails
      }

      List<Widget> lists = [];
      for (var re in results) {
        var list = re["keypoints"].values.map<Widget>((k) {
          double x = k["x"];
          double y = k["y"];
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
          return Positioned(
            left: adjustedX - 6,
            top: adjustedY - 6,
            width: 100,
            height: 12,
            child: Text(
              "● ${k["part"]}",
              style: TextStyle(
                color: TColor.primaryColor1,
                fontSize: 12.0,
              ),
            ),
          );
        }).toList();
        lists.addAll(list);
      }
      return lists;
    }

    return Stack(children: renderKeypoints());
  }
}

