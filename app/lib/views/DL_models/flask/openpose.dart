import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:ui' as ui; // For image resolution

class OpenPose extends StatefulWidget {
  const OpenPose({super.key});

  @override
  State<OpenPose> createState() => _OpenPoseState();
}

class _OpenPoseState extends State<OpenPose> {
  File? _image;
  List<Offset>? _points;
  Size? _imageSize;

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      final decodedImage = await decodeImageFromList(image.readAsBytesSync());
      setState(() {
        _image = image;
        _imageSize =
            Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
      });
      uploadImage();
    }
  }

  Future uploadImage() async {
    if (_image == null) return;
    var uri = Uri.parse('http://192.168.18.48:5000/process_image');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      debugPrint('Upload successful');
      var jsonData = jsonDecode(response.body);
      var pointsData = jsonData['points'] as List;
      List<Offset> nonNullPoints = pointsData
          .map((p) {
            if (p != null) {
              return Offset(p[0].toDouble(), p[1].toDouble());
            }
            return null;
          })
          .where((p) => p != null)
          .toList()
          .cast<Offset>();
      debugPrint(nonNullPoints.toString());
      setState(() {
        _points = nonNullPoints;
      });
    } else {
      debugPrint('Upload failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenPose Detection'),
      ),
      body: Center(
        child: _image == null
            ? const Text('No image selected.')
            : _imageSize == null || _points == null
                ? Image.file(_image!)
                : Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      CustomPaint(
                        painter:
                            KeypointPainter(_image!, _points!, _imageSize!),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

class KeypointPainter extends CustomPainter {
  final File image;
  final List<Offset?> points;
  final Size imageSize;

  // Define body parts and pose pairs
  static final Map<String, int> bodyParts = {
    "Nose": 0, "Neck": 1, "RShoulder": 2, "RElbow": 3, "RWrist": 4,
    "LShoulder": 5, "LElbow": 6, "LWrist": 7, "RHip": 8, "RKnee": 9,
    "RAnkle": 10, "LHip": 11, "LKnee": 12, "LAnkle": 13, "REye": 14,
    "LEye": 15, "REar": 16, "LEar": 17, "Background": 18
  };

  static final List<List<String>> posePairs = [
    ["Neck", "RShoulder"], ["Neck", "LShoulder"], ["RShoulder", "RElbow"],
    ["RElbow", "RWrist"], ["LShoulder", "LElbow"], ["LElbow", "LWrist"],
    ["Neck", "RHip"], ["RHip", "RKnee"], ["RKnee", "RAnkle"], ["Neck", "LHip"],
    ["LHip", "LKnee"], ["LKnee", "LAnkle"], ["Neck", "Nose"], ["Nose", "REye"],
    ["REye", "REar"], ["Nose", "LEye"], ["LEye", "LEar"]
  ];

  KeypointPainter(this.image, this.points, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = TColor.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    );
    final textStyle = TextStyle(
      color: TColor.grey,
      fontSize: 12,
    );

    double scale, offsetX, offsetY;
    final double imageRatio = imageSize.width / imageSize.height;
    final double containerRatio = size.width / size.height;

    if (imageRatio > containerRatio) {
      scale = size.width / imageSize.width;
      offsetX = 0;
      offsetY = (size.height - imageSize.height * scale) / 2;
    } else {
      scale = size.height / imageSize.height;
      offsetX = (size.width - imageSize.width * scale) / 2;
      offsetY = 0;
    }

    // Draw lines for each pair
    for (var pair in posePairs) {
      var fromIndex = bodyParts[pair[0]];
      var toIndex = bodyParts[pair[1]];
      var fromPoint = points[fromIndex!]; // Ensure index exists in the map
      var toPoint = points[toIndex!];     // Ensure index exists in the map

      if (fromPoint != null && toPoint != null) {
        canvas.drawLine(
          Offset(fromPoint.dx * scale + offsetX, fromPoint.dy * scale + offsetY),
          Offset(toPoint.dx * scale + offsetX, toPoint.dy * scale + offsetY),
          paint..color = TColor.white
        );
      }
    }

    // Draw keypoints and labels
    for (int i = 0; i < points.length; i++) {
      var point = points[i];
      if (point != null) {
        canvas.drawCircle(
          Offset(point.dx * scale + offsetX, point.dy * scale + offsetY),
          5,
          paint..color = TColor.primaryColor1
        );

        textPainter.text = TextSpan(
          text: bodyParts.keys.elementAt(i), // Get body part name by index
          style: textStyle,
        );
        textPainter.layout(minWidth: 0, maxWidth: size.width);
        textPainter.paint(
          canvas,
          Offset(
            point.dx * scale + offsetX - textPainter.width / 2,
            point.dy * scale + offsetY - 20  // Offset for readability
          )
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}