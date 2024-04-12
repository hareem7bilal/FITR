import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:async';

typedef Callback = void Function(
    List<dynamic> recognitions, int imageHeight, int imageWidth);

class Camera extends StatefulWidget {
  final String model;
  final Callback setRecognitions;

  const Camera({
    super.key,
    required this.model,
    required this.setRecognitions,
  });

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    // Get the list of available cameras.
    final cameras = await availableCameras();

    // Find the first camera in the list with a front lens direction.
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);

    // Initialize the camera controller with the front camera
    controller = CameraController(frontCamera, ResolutionPreset.high);

    // Initialize the controller and start the stream once initialized
    controller?.initialize().then((_) {
      if (!mounted) return;
      setState(() {});

      controller?.startImageStream((CameraImage img) {
        if (!isDetecting) {
          isDetecting = true;

          // Process the image frame for pose detection
          Tflite.runPoseNetOnFrame(
            bytesList: img.planes.map((plane) => plane.bytes).toList(),
            imageHeight: img.height,
            imageWidth: img.width,
            numResults: 2,
          ).then((recognitions) {
            widget.setRecognitions(
                recognitions!.toList(), img.height, img.width);
            isDetecting = false;
          });
        }
      });
    }).catchError((e) {
      debugPrint('Failed to initialize camera: $e');
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final xScale = controller!.value.aspectRatio / deviceRatio;

    //Correct the aspect ratio to prevent stretching
    final widgetScale = 1 / (xScale * size.aspectRatio);

    return Transform.scale(
      scale: widgetScale,
      child: Center(
        child: CameraPreview(controller!),
      ),
    );
    // return Container(
    //   constraints: const BoxConstraints
    //       .expand(), // Make the preview fill the entire screen space
    //   child: CameraPreview(controller!),
    // );
  }
}
