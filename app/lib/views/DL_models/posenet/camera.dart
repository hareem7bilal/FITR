import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

typedef Callback = void Function(List<dynamic> list, int h, int w);

enum CameraType { front, back }

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final String model;
  final CameraType cameraType;

  const Camera({
    super.key,
    required this.cameras,
    required this.model,
    required this.setRecognitions,
    this.cameraType = CameraType.back, // Default to using the back camera
  });

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    if (widget.cameras.isEmpty) {
      debugPrint('No camera is found');
    } else {
      // Select the camera based on the camera type
      final cameraDescription = widget.cameras.firstWhere(
        (camera) =>
            camera.lensDirection ==
            (widget.cameraType == CameraType.front
                ? CameraLensDirection.front
                : CameraLensDirection.back),
        orElse: () => widget.cameras.first, // Fallback to the first camera
      );

      controller = CameraController(
        cameraDescription,
        ResolutionPreset.high,
      );

      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
          if (!isDetecting) {
            isDetecting = true;
            int startTime = DateTime.now().millisecondsSinceEpoch;

            if (widget.model == 'posenet') {
              Tflite.runPoseNetOnFrame(
                bytesList: img.planes.map((plane) => plane.bytes).toList(),
                imageHeight: img.height,
                imageWidth: img.width,
                numResults: 2,
              ).then((recognitions) {
                int endTime = DateTime.now().millisecondsSinceEpoch;
                debugPrint("Detection took ${endTime - startTime}");

                widget.setRecognitions(recognitions!, img.height, img.width);

                isDetecting = false;
              });
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    var tmpSize = controller.value.previewSize!;
    var previewH = math.max(tmpSize.height, tmpSize.width);
    var previewW = math.min(tmpSize.height, tmpSize.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller),
    );
  }
}
