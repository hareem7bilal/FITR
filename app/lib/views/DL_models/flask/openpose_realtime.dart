import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as imglib;

class OpenPoseRealtime extends StatefulWidget {
  const OpenPoseRealtime({super.key});

  @override
  State<OpenPoseRealtime> createState() => _OpenPoseRealtimeState();
}

class _OpenPoseRealtimeState extends State<OpenPoseRealtime> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  WebSocketChannel? _socketChannel;
  List<Keypoint>? keypoints;
  bool _isUsingFrontCamera = true;

  @override
  void initState() {
    super.initState();
    initializeCameras();
    initializeSocket();
  }

  void initializeCameras() async {
    _cameras = await availableCameras();
    initializeCamera(_cameras!.first);
  }

  void initializeCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );
    await _cameraController!.initialize();
    if (mounted) {
      setState(() {});
      startImageStream();
    }
  }

  void switchCamera() {
    if (_cameras == null || _cameras!.isEmpty) return;
    CameraDescription newCamera = _isUsingFrontCamera
        ? _cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back)
        : _cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front);
    _isUsingFrontCamera = !_isUsingFrontCamera;
    initializeCamera(newCamera);
  }

  void startImageStream() {
    _cameraController!.startImageStream((CameraImage image) async {
      // Convert the YUV420 image to a JPEG
      final jpg = await convertYUV420toJPEG(image);
      _socketChannel!.sink.add(jpg);
    });
  }

  // This function now returns an integer ARGB color value
  int yuvToRgb(int y, int u, int v) {
    int r = (y + v * 1436 / 1024 - 179).round().clamp(0, 255);
    int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91)
        .round()
        .clamp(0, 255);
    int b = (y + u * 1814 / 1024 - 227).round().clamp(0, 255);
    // Construct ARGB color integer
    return (0xFF << 24) | (r << 16) | (g << 8) | b;
  }

  Future<Uint8List> convertYUV420toJPEG(CameraImage image) async {
    final int width = image.width;
    final int height = image.height;

    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final uvRowStride = uPlane.bytesPerRow;
    final uvPixelStride = uPlane.bytesPerPixel ?? 1;

    // Initialize the image buffer
    var img = imglib.Image(width: width, height: height);

    // Fill the image buffer with converted RGB data
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final uvIndexX = (x / 2).floor();
        final uvIndexY = (y / 2).floor();
        final uvIndex = uvIndexY * uvRowStride + uvIndexX * uvPixelStride;

        final Y = yPlane.bytes[y * yPlane.bytesPerRow + x];
        final U = uPlane.bytes[uvIndex];
        final V = vPlane.bytes[uvIndex];

        int argbColor = yuvToRgb(Y, U, V);

        int a = (argbColor >> 24) & 0xFF;
        int r = (argbColor >> 16) & 0xFF;
        int g = (argbColor >> 8) & 0xFF;
        int b = argbColor & 0xFF;

        var color = imglib.ColorUint8.rgba(
            r, g, b, a); // Ensure constructor and parameters match your lib

        img.setPixel(x, y, color);
      }
    }

    // Encode the image as a JPEG
    final jpg = imglib.encodeJpg(img, quality: 90);
    return Uint8List.fromList(jpg);
  }

  void initializeSocket() {
    _socketChannel =
        IOWebSocketChannel.connect(Uri.parse('ws://192.168.18.48:5000/ws'));

    _socketChannel!.stream.listen(
      (message) {
        try {
          final jsonData = jsonDecode(message);
          setState(() {
            if (jsonData['keypoints'] != null) {
              keypoints = (jsonData['keypoints'] as List)
                  .map((kp) => Keypoint.fromJson(kp as Map<String, dynamic>))
                  .toList();
            } else if (jsonData['error'] != null) {
              debugPrint('Server error: ${jsonData['error']}');
            }
          });
        } catch (e) {
          debugPrint('Error parsing JSON: $e');
        }
      },
      onError: (error) {
        debugPrint('WebSocket error: $error');
      },
      onDone: () {
        debugPrint('WebSocket closed');
      },
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _socketChannel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenPose Realtime'),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_camera),
            onPressed: switchCamera,
          ),
        ],
      ),
      body: _cameraController == null || !_cameraController!.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CameraPreview(_cameraController!),
                if (keypoints != null)
                  CustomPaint(
                    painter:
                        PosePainter(keypoints!, context, _cameraController!),
                    size: Size(_cameraController!.value.previewSize!.height,
                        _cameraController!.value.previewSize!.width),
                  ),
              ],
            ),
    );
  }
}

class PosePainter extends CustomPainter {
  final List<Keypoint> keypoints;
  final BuildContext context;
  final CameraController cameraController;

  PosePainter(this.keypoints, this.context, this.cameraController);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    final Size imageSize = cameraController.value.previewSize!;
    final double scale = size.width / imageSize.height;

    for (var point in keypoints) {
      if (point.position != null) {
        final scaledX = point.position!.dx * scale;
        final scaledY = point.position!.dy * scale;
        canvas.drawCircle(Offset(scaledY, scaledX), 5, paint);
      }
    }

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    List<List<String>> posePairs = [
      ["Neck", "RShoulder"],
      ["Neck", "LShoulder"],
      ["RShoulder", "RElbow"],
      ["RElbow", "RWrist"],
      ["LShoulder", "LElbow"],
      ["LElbow", "LWrist"],
      ["Neck", "RHip"],
      ["RHip", "RKnee"],
      ["RKnee", "RAnkle"],
      ["Neck", "LHip"],
      ["LHip", "LKnee"],
      ["LKnee", "LAnkle"],
      ["Neck", "Nose"],
      ["Nose", "REye"],
      ["REye", "REar"],
      ["Nose", "LEye"],
      ["LEye", "LEar"]
    ];
    for (var pair in posePairs) {
      var p1 = keypoints.firstWhere((kp) => kp.part == pair[0],
          orElse: () => Keypoint(part: pair[0], position: null));
      var p2 = keypoints.firstWhere((kp) => kp.part == pair[1],
          orElse: () => Keypoint(part: pair[1], position: null));
      if (p1.position != null && p2.position != null) {
        final p1X = p1.position!.dx * scale;
        final p1Y = p1.position!.dy * scale;
        final p2X = p2.position!.dx * scale;
        final p2Y = p2.position!.dy * scale;
        canvas.drawLine(Offset(p1Y, p1X), Offset(p2Y, p2X), linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Keypoint {
  final String part;
  final Offset? position;

  Keypoint({required this.part, this.position});

  factory Keypoint.fromJson(Map<String, dynamic> json) {
    return Keypoint(
      part: json['part'],
      position: json['position'] != null
          ? Offset(
              json['position'][0].toDouble(), json['position'][1].toDouble())
          : null,
    );
  }
}
