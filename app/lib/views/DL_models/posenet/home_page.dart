import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

// Ensure these are correctly imported
import 'camera.dart';
import 'bindbox.dart'; // Ensure the file name matches and class name inside is BindBox

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";
  static const String posenet =
      "PoseNet"; // Define posenet if not defined elsewhere

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
        labels: "", // If you have label file add here
      );

      debugPrint("Model loaded: $res");
    } catch (e) {
      debugPrint("Failed to load model: $e");
    }
  }

  void onSelect(String model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  void setRecognitions(recognitions, imageHeight, imageWidth) {
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
      body: _model.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: const Text('PoseNet'),
                    onPressed: () => onSelect(posenet),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Camera(
                  model: _model,
                  setRecognitions: setRecognitions,
                ),
                BindBox(
                    results: _recognitions,
                    previewH: math.max(_imageHeight, _imageWidth),
                    previewW: math.min(_imageHeight, _imageWidth),
                    screenH: screen.height,
                    screenW: screen.width,
                    model: _model),
              ],
            ),
    );
  }
}
