import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;

class OpenPoseRealtime extends StatefulWidget {
  const OpenPoseRealtime({super.key});

  @override
  State<OpenPoseRealtime> createState() => _OpenPoseRealtimeState();
}

class _OpenPoseRealtimeState extends State<OpenPoseRealtime> {
  CameraController? _cameraController;
  int selectedCameraIndex = 0;
  Interpreter? _interpreter;
  bool _isDetecting = false;
  List<Offset?> _keypoints = [];
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        debugPrint('No cameras are available');
      } else {
        await loadModel();
        initializeCameras();
      }
    } catch (e) {
      debugPrint('Error initializing cameras: $e');
    }
  }

  Future<void> loadModel() async {
    try {
      final interpreterOptions = InterpreterOptions()..threads = 4;
      _interpreter = await Interpreter.fromAsset('assets/models/openpose.tflite', options: interpreterOptions);
      var inputTensor = _interpreter!.getInputTensor(0);
      debugPrint('Model loaded with input shape: ${inputTensor.shape} and type: ${inputTensor.type}');
    } catch (e) {
      debugPrint('Failed to load model: $e');
    }
  }

  Future<void> initializeCameras() async {
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[selectedCameraIndex], ResolutionPreset.high, enableAudio: false);
      try {
        await _cameraController!.initialize();
        setState(() {});
        startImageStream();
      } catch (e) {
        debugPrint('Error initializing camera: $e');
      }
    }
  }

  void startImageStream() {
    _cameraController?.startImageStream((CameraImage image) {
      if (!_isDetecting) {
        _isDetecting = true;
        runPoseEstimation(image).whenComplete(() => _isDetecting = false);
      }
    });
  }

  Future<void> runPoseEstimation(CameraImage image) async {
    try {
      final imglib.Image? convertedImage = convertYUV420toImageColor(image);
      if (convertedImage == null) {
        debugPrint("Image conversion error!");
        return;
      }
      var resizedImage = imglib.copyResize(convertedImage, width: 368, height: 368);
      var inputImage = imageToByteListFloat32(resizedImage, 368, 255, 127.5);

      if (_interpreter == null) {
        throw Exception('Interpreter is not initialized');
      }

      List<dynamic> output = List.generate(
          1,
          (_) => List.generate(
              38, (_) => List.generate(46, (_) => List.filled(46, 0.0))));

      _interpreter!.run(inputImage, output);
      setState(() {
        _keypoints = extractKeypointsFromHeatmaps(output, image.width, image.height);
        debugPrint('Keypoints: ${_keypoints.length}');
      });
    } catch (e) {
      debugPrint("Inference error: $e");
    }
  }

  List<Offset?> extractKeypointsFromHeatmaps(List<dynamic> heatmaps, int originalWidth, int originalHeight) {
    List<Offset?> keypoints = [];
    int heatmapWidth = heatmaps[0][0][0].length;
    int heatmapHeight = heatmaps[0][0].length;

    for (int i = 0; i < heatmaps[0].length; i++) {
      double maxX = 0, maxY = 0;
      double maxVal = -double.infinity;
      for (int y = 0; y < heatmapHeight; y++) {
        for (int x = 0; x < heatmapWidth; x++) {
          double val = heatmaps[0][i][y][x];
          if (val > maxVal) {
            maxVal = val;
            maxX = x.toDouble();
            maxY = y.toDouble();
          }
        }
      }
      double scaleX = originalWidth / 368;
      double scaleY = originalHeight / 368;
      keypoints.add(Offset(maxX * scaleX, maxY * scaleY));
    }
    return keypoints;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Realtime Pose Estimation')),
      body: Stack(
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
            CameraPreview(_cameraController!),
          CustomPaint(
            painter: PosePainter(_keypoints),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (cameras.isNotEmpty && cameras.length > 1) {
            selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
            _cameraController!.dispose();
            initializeCameras();
          }
        },
        child: const Icon(Icons.switch_camera),
      ),
    );
  }
}

class PosePainter extends CustomPainter {
  final List<Offset?> keypoints;

  PosePainter(this.keypoints);

  @override
  void paint(Canvas canvas, ui.Size size) {
    var paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0;
    for (var point in keypoints) {
      if (point != null) {
        canvas.drawCircle(point, 10, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Helper functions below...

imglib.Image? convertYUV420toImageColor(CameraImage image) {
  try {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel!;
    var img = imglib.Image(width: width, height: height);

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
        final int index = y * width + x;
        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        var r = (yp + 1.370705 * (vp - 128)).round().clamp(0, 255);
        var g = (yp - (0.337633 * (up - 128)) - (0.698001 * (vp - 128))).round().clamp(0, 255);
        var b = (yp + 1.732446 * (up - 128)).round().clamp(0, 255);
        var color = imglib.ColorUint8.rgba(r, g, b, 255);
        img.setPixel(x, y, color);
      }
    }
    return img;
  } catch (e) {
    debugPrint("Failed to convert image: $e");
    return null;
  }
}

Uint8List imageToByteListFloat32(imglib.Image image, int inputSize, double std, double mean) {
  var convertedBytes = Float32List(inputSize * inputSize * 3);
  var buffer = Float32List.view(convertedBytes.buffer);
  int pixelIndex = 0;
  for (int i = 0; i < inputSize; i++) {
    for (int j = 0; j < inputSize; j++) {
      var pixel = image.getPixel(j, i);
      buffer[pixelIndex++] = (pixel.r - mean) / std;
      buffer[pixelIndex++] = (pixel.g - mean) / std;
      buffer[pixelIndex++] = (pixel.b - mean) / std;
    }
  }
  return convertedBytes.buffer.asUint8List();
}
