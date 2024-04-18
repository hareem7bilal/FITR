import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class OpenposeView extends StatefulWidget {
  const OpenposeView({super.key});

  @override
  State<OpenposeView> createState() => _OpenposeViewState();
}

class _OpenposeViewState extends State<OpenposeView> {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  late Interpreter _interpreter;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _initializeCamera();
  }

  Future<void> _loadModel() async {
    // Adjust with your model's path and options
    _interpreter = await Interpreter.fromAsset('assets/models/openpose.tflite');
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.medium);
    await _cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      // Start the camera stream
      _cameraController!.startImageStream((CameraImage image) {
        // Perform inference with your model
        _predictPose(image);
      });
      setState(() {
        _isReady = true;
      });
    });
  }

  Future<void> _predictPose(CameraImage image) async {
    // Convert the CameraImage to an image library compatible format
    img.Image convertedImage = _convertCameraImage(image);

    // Resize the image to the size expected by your model
    img.Image resizedImage =
        img.copyResize(convertedImage, width: 368, height: 368);

    // Normalize pixel values if required by your model
    // Assuming pixel values need to be normalized to the range [0,1] from the original [0,255]
    // Adjust normalization parameters as needed for your model
    var normalizedImage =
        _imageToByteListFloat32(resizedImage, 368, 127.5, 127.5);

    // Perform inference
    // Ensure that the output buffer is adjusted based on your model's specific output structure
    List<dynamic>? output = List.filled(1 * 18 * 2, 0).reshape([1, 18, 2]);
    _interpreter.run(normalizedImage.buffer.asUint8List(), output[0]);

    // Process the output to render poses or perform other actions
    // This step is highly model and application specific
  }

  img.Image _convertCameraImage(CameraImage image) {
    var convertedBytes = Uint8List(0);
    var planes = image.planes;
    var format = image.format.group;
    final width = image.width;
    final height = image.height;

    if (format == ImageFormatGroup.yuv420) {
      debugPrint("_yuv420toImageColor");
      convertedBytes = _yuv420toImageColor(planes, width, height);
      
    } else if (format == ImageFormatGroup.bgra8888) {
      debugPrint("_bgraToImageColor");
      convertedBytes = _bgraToImageColor(planes, width, height);
      
    } else {
      debugPrint("sigh");
    }

    // The img.decodeImage function expects a complete image file, which might not work directly with raw RGB bytes.
    // For demonstration, assuming conversion functions return a proper image file byte data.
    final img.Image resultImage = img.decodeImage(convertedBytes)!;

    return resultImage;
  }

// Simplified YUV420 to RGB conversion.
// Note: This method might not be optimized for real-time processing.
  Uint8List _yuv420toImageColor(List<Plane> planes, int width, int height) {
    final yPlane = planes[0];
    final uPlane = planes[1];
    final vPlane = planes[2];

    final yBuffer = yPlane.bytes;
    final uBuffer = uPlane.bytes;
    final vBuffer = vPlane.bytes;

    // Strides
    final yStride = yPlane.bytesPerRow;
    final uvStride = uPlane.bytesPerRow;

    // Output RGB buffer
    var rgbBuffer = Uint8List(width * height * 3);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final yIndex = y * yStride + x;
        final uvIndex = (y ~/ 2) * uvStride + (x ~/ 2);

        final Y = yBuffer[yIndex];
        final U = uBuffer[uvIndex] - 128;
        final V = vBuffer[uvIndex] - 128;

        // Convert YUV to RGB
        int R = (Y + V * 1.370705).clamp(0, 255).round().toInt();
        int G =
            (Y - (U * 0.337633 + V * 0.698001)).clamp(0, 255).round().toInt();
        int B = (Y + U * 1.732446).clamp(0, 255).round().toInt();

        // Clamping to byte range
        R = R.clamp(0, 255).round();
        G = G.clamp(0, 255).round();
        B = B.clamp(0, 255).round();

        // Assign to the RGB buffer
        final rgbIndex = y * width + x;
        rgbBuffer[rgbIndex * 3 + 0] = R;
        rgbBuffer[rgbIndex * 3 + 1] = G;
        rgbBuffer[rgbIndex * 3 + 2] = B;
      }
    }

    return rgbBuffer;
  }

  Uint8List _bgraToImageColor(List<Plane> planes, int width, int height) {
    final bgra8888 = planes[0].bytes;
    final rgbBytes = Uint8List(width * height * 3);

    for (int i = 0; i < height * width; i++) {
      final bIndex = i * 4;
      final rIndex = i * 3;
      // BGRA8888 to RGB conversion by swapping R and B
      rgbBytes[rIndex + 0] = bgra8888[bIndex + 2]; // R
      rgbBytes[rIndex + 1] = bgra8888[bIndex + 1]; // G
      rgbBytes[rIndex + 2] = bgra8888[bIndex + 0]; // B
    }
    return rgbBytes;
  }

// Normalizes the image and converts it to a Float32List for TensorFlow Lite
  // Convert img.Image (RGB format) to a Float32List to use as input to the TFLite model
  Float32List _imageToByteListFloat32(
      img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
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
    return buffer;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Center(child: CircularProgressIndicator());
    }
    return CameraPreview(_cameraController!);
  }
}
