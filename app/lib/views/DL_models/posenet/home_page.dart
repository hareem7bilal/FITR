import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bindbox.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomePage({
    super.key,
    required this.cameras,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "posenet"; // Pre-select the model

  @override
  void initState() {
    super.initState();
    onSelect(_model); // Load model and initialize camera on startup
  }

  Future<void> loadModel() async {
    String? res;
    switch (_model) {
      case 'posenet':
        res = await Tflite.loadModel(
          model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
          labels: "assets/labels.txt", // Including labels if they are used by your app
        );
        debugPrint('Model loaded: $res');
        break;
      default:
        res = 'Model not supported';
        debugPrint(res);
        break;
    }
  }

  void onSelect(String model) {
    setState(() {
      _model = model;
    });
    loadModel().catchError((e) {
      debugPrint("Failed to load the model: $e");
    });
  }

  void setRecognitions(
      List<dynamic> recognitions, int imageHeight, int imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Camera(
            cameras: widget.cameras,
            model: _model,
            setRecognitions: setRecognitions,
          ),
          BindBox(
            results: _recognitions,
            previewH: math.max(_imageHeight, _imageWidth),
            previewW: math.min(_imageHeight, _imageWidth),
            screenH: screen.height,
            screenW: screen.width,
            model: _model,
          ),
        ],
      ),
    );
  }
}
