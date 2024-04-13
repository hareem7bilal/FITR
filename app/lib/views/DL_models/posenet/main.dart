import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home_page.dart';

// CameraInitializer Widget
class CameraInitializer extends StatefulWidget {
  final Widget Function(List<CameraDescription>) onCamerasReady;
  final Widget onError;

  const CameraInitializer({
    super.key,
    required this.onCamerasReady,
    required this.onError,
  });

  @override
  State<CameraInitializer> createState() => _CameraInitializerState();
}

class _CameraInitializerState extends State<CameraInitializer> {
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _loadCameras();
  }

  // Asynchronous function to load available cameras
  Future<void> _loadCameras() async {
    try {
      final List<CameraDescription> cameraList = await availableCameras();
      if (cameraList.isEmpty) {
        throw Exception('No cameras found');
      }
      setState(() {
        cameras = cameraList;
      });
    } on CameraException catch (e) {
      debugPrint(
          'Error loading cameras: ${e.code}\nError Message: ${e.description}');
      setState(() {});
    } catch (e) {
      debugPrint('Unknown error occurred while loading cameras: $e');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator until cameras are initialized
    if (cameras == null) {
      return const Center(child: CircularProgressIndicator());
    }
    // Pass the cameras to the HomePage or show an error if none are available
    return cameras!.isEmpty ? widget.onError : widget.onCamerasReady(cameras!);
  }
}

// Main App Widget
class Posenet extends StatelessWidget {

  const Posenet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posenet Real-time Detection',
      home: CameraInitializer(
        onCamerasReady: (cameras) => HomePage(cameras:cameras),
        onError: const Scaffold(
          body: Center(
            child: Text('Failed to load cameras.'),
          ),
        ),
      ),
    );
  }
}
