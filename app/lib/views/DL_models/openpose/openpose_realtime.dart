import 'dart:async';
import 'dart:isolate';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OpenPoseRealtime extends StatefulWidget {
  const OpenPoseRealtime({super.key});

  @override
  State<OpenPoseRealtime> createState() => _OpenPoseRealtimeState();
}

class _OpenPoseRealtimeState extends State<OpenPoseRealtime> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  Isolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _sendPort;
  WebSocketChannel? _socketChannel;
  List<Keypoint>? keypoints;
  Map<String, double>? angles; // Storing angles

  @override
  void initState() {
    super.initState();
    initializeCameras();
    initializeWebSocket();
  }

  void initializeCameras() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      initializeCamera(_cameras!.first);
    }
  }

  void initializeCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController!.initialize();
    if (mounted) {
      setState(() {});
      startImageStream();
    }
  }

  void initializeWebSocket() {
    _socketChannel =
        IOWebSocketChannel.connect(Uri.parse('ws://192.168.18.48:8000/ws'));

    _socketChannel!.stream.listen(
      (message) {
        debugPrint('Received message: $message');
        try {
          final jsonData = jsonDecode(message);
          setState(() {
            if (jsonData['keypoints'] != null && jsonData['angles'] != null) {
              keypoints = parseKeypoints(jsonData['keypoints']);
              angles = parseAngles(jsonData['angles']);
              debugPrint('Keypoints: $keypoints');
              debugPrint('Angles: $angles');
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

  List<Keypoint> parseKeypoints(Map<String, dynamic> keypointsData) {
    return keypointsData.entries.map((e) {
      var position = e.value;
      if (position != null && position is List && position.length == 2) {
        return Keypoint(
          part: e.key,
          position: Offset(double.tryParse(position[0].toString()) ?? 0.0,
              double.tryParse(position[1].toString()) ?? 0.0),
        );
      }
      return Keypoint(part: e.key, position: null);
    }).toList();
  }

  Map<String, double> parseAngles(Map<String, dynamic> anglesData) {
    Map<String, double> angles = {};
    anglesData.forEach((key, value) {
      try {
        angles[key] = double.parse(value.toString());
      } catch (e) {
        debugPrint('Error parsing angle for $key: $e');
        angles[key] = 0.0; // default or error value
      }
    });
    return angles;
  }

  Future<void> startImageStream() async {
    if (_cameraController != null &&
        !_cameraController!.value.isStreamingImages) {
      _receivePort = ReceivePort();
      _isolate =
          await Isolate.spawn(imageProcessingIsolate, _receivePort!.sendPort);
      _receivePort!.listen(handleIsolateMessage);

      _cameraController!.startImageStream((CameraImage image) {
        _sendPort?.send(image);
      });
    }
  }

  void handleIsolateMessage(dynamic data) {
    if (data is SendPort) {
      _sendPort = data;
    } else if (data is Uint8List) {
      _socketChannel!.sink.add(data); // Send image data to server
    } else {
      debugPrint('Unexpected data from isolate: $data');
    }
  }

  static void imageProcessingIsolate(SendPort mainSendPort) {
    ReceivePort isolateReceivePort = ReceivePort();
    mainSendPort.send(isolateReceivePort.sendPort);
    isolateReceivePort.listen((dynamic message) {
      if (message is CameraImage) {
        Uint8List jpg = convertYUV420toJPEG(message);
        mainSendPort.send(jpg);
      }
    });
  }

  static Uint8List convertYUV420toJPEG(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];
    final uvRowStride = uPlane.bytesPerRow;
    final uvPixelStride = uPlane.bytesPerPixel ?? 1;
    var img = imglib.Image(width: width, height: height);

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

        img.setPixelRgba(x, y, r, g, b, a);
      }
    }
    final jpg = imglib.encodeJpg(img, quality: 95);
    return Uint8List.fromList(jpg);
  }

  static int yuvToRgb(int y, int u, int v) {
    int r = (y + v * 1436 / 1024 - 179).round().clamp(0, 255);
    int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91)
        .round()
        .clamp(0, 255);
    int b = (y + u * 1814 / 1024 - 227).round().clamp(0, 255);
    return (0xFF << 24) | (r << 16) | (g << 8) | b;
  }

  @override
  void dispose() {
    _isolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
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
            onPressed: () => switchCamera(),
          ),
        ],
      ),
      body: _cameraController == null || !_cameraController!.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CameraPreview(_cameraController!),
                if (keypoints != null && angles != null)
                  CustomPaint(
                    painter: PosePainter(
                        keypoints!, angles!, context, _cameraController!),
                    size: Size(_cameraController!.value.previewSize!.height,
                        _cameraController!.value.previewSize!.width),
                  ),
              ],
            ),
    );
  }

  void switchCamera() {
    if (_cameras != null && _cameras!.isNotEmpty) {
      CameraDescription newCamera = _cameras!.firstWhere(
        (camera) =>
            camera.lensDirection !=
            _cameraController!.description.lensDirection,
        orElse: () => _cameras!.first,
      );
      initializeCamera(newCamera);
    }
  }
}

class PosePainter extends CustomPainter {
  final List<Keypoint> keypoints;
  final Map<String, double> angles;
  final BuildContext context;
  final CameraController cameraController;

  PosePainter(this.keypoints, this.angles, this.context, this.cameraController);

  @override
  void paint(Canvas canvas, Size size) {
    final Size imageSize = cameraController.value.previewSize!;
    final double imageRatio = imageSize.width / imageSize.height;
    final double containerRatio = size.width / size.height;

    double scale, offsetX, offsetY;
    if (imageRatio > containerRatio) {
      scale = size.width / imageSize.width;
      offsetX = 0;
      offsetY = (size.height - imageSize.height * scale) / 2;
    } else {
      scale = size.height / imageSize.height;
      offsetX = (size.width - imageSize.width * scale) / 2;
      offsetY = 0;
    }

    final paint = Paint()
      ..color = TColor.primaryColor1 // Ensure TColor.primaryColor1 is defined or replace with Colors.red
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Map<String, Offset> points = {};
    for (var keypoint in keypoints) {
      if (keypoint.position != null) {
        double scaledX = keypoint.position!.dx * scale + offsetX;
        double scaledY = keypoint.position!.dy * scale + offsetY;
        points[keypoint.part] = Offset(scaledX, scaledY);
        canvas.drawCircle(points[keypoint.part]!, 5, paint);
      }
    }

    for (var pair in PosePainter.posePairs) {
      var p1 = points[pair[0]];
      var p2 = points[pair[1]];
      if (p1 != null && p2 != null) {
        canvas.drawLine(p1, p2, linePaint);
        String angleKey = "${pair[0]}_${pair[1]}";
        if (angles.containsKey(angleKey)) {
          final angleTextPainter = TextPainter(
            text: TextSpan(
              text: "${angles[angleKey]!.toStringAsFixed(1)}°",
              style: TextStyle(color: TColor.white, fontSize: 14),
            ),
            textDirection: TextDirection.ltr,
          );
          angleTextPainter.layout();
          angleTextPainter.paint(
              canvas, Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  static final List<List<String>> posePairs = [
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
}

class Keypoint {
  final String part;
  final Offset? position;

  Keypoint({required this.part, this.position});

  factory Keypoint.fromJson(Map<String, dynamic> json) {
    return Keypoint(
      part: json['part'],
      position: json['position'] != null
          ? Offset(double.parse(json['position']['x'].toString()),
              double.parse(json['position']['y'].toString()))
          : null,
    );
  }

  @override
  String toString() {
    // Ensures output is meaningful, showing coordinates or 'Not detected'
    return "$part: ${position != null ? "(${position!.dx}, ${position!.dy})" : "Not detected"}";
  }
}
