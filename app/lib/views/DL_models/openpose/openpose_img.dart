import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenPoseImg extends StatefulWidget {
  const OpenPoseImg({super.key});

  @override
  State<OpenPoseImg> createState() => _OpenPoseImgState();
}

class _OpenPoseImgState extends State<OpenPoseImg> {
  File? _image;
  List<Keypoint>? _keypoints;
  Size? _imageSize;

  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      _pickImage(source);
    }
  }

  Future<void> getImage() async {
    await _showImageSourceActionSheet(context);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
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
    var uri = Uri.parse('http://LoadBalancer1-1188636977.ap-south-1.elb.amazonaws.com/process_image');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      debugPrint('Upload successful');
      var jsonData = jsonDecode(response.body);
      var pointsData = jsonData['points'] as Map<String, dynamic>;
      List<Keypoint> keypoints = pointsData.entries
          .map((e) => Keypoint.fromJson({
                'part': e.key,
                'position': e.value,
                'angle': jsonData['angles'][e.key] // Include angle data
              }))
          .toList();
      setState(() {
        _keypoints = keypoints;
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
            : _keypoints == null || _imageSize == null
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
                            KeypointPainter(_image!, _keypoints!, _imageSize!),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showImageSourceActionSheet(context),
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

class KeypointPainter extends CustomPainter {
  final File image;
  final List<Keypoint> keypoints;
  final Size imageSize;

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
    ["RAnkle", "RHeel"],
    ["RHeel", "RBigToe"],
    ["RHeel", "RSmallToe"],
    ["Neck", "LHip"],
    ["LHip", "LKnee"],
    ["LKnee", "LAnkle"],
    ["LAnkle", "LHeel"],
    ["LHeel", "LBigToe"],
    ["LHeel", "LSmallToe"],
    ["Neck", "Nose"],
    ["Nose", "REye"],
    ["REye", "REar"],
    ["Nose", "LEye"],
    ["LEye", "LEar"]
  ];

  KeypointPainter(this.image, this.keypoints, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = TColor.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    final pointPaint = Paint()
      ..color = TColor.primaryColor1
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    final textPainter = TextPainter(
        textDirection: TextDirection.ltr, textAlign: TextAlign.center);
    final textStyle = TextStyle(
      color: TColor.white,
      fontSize: 8,
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

    // Create a map to easily access keypoints by part name
    Map<String, Offset?> points = {};
    for (Keypoint keypoint in keypoints) {
      if (keypoint.position != null) {
        points[keypoint.part] = Offset(
          keypoint.position!.dx * scale + offsetX,
          keypoint.position!.dy * scale + offsetY,
        );
      } else {
        points[keypoint.part] = null;
      }
    }

    // Draw lines between related keypoints
    for (var pair in posePairs) {
      Offset? fromPoint = points[pair[0]];
      Offset? toPoint = points[pair[1]];
      if (fromPoint != null && toPoint != null) {
        canvas.drawLine(fromPoint, toPoint, linePaint);
      }
    }

    // Draw keypoints and labels
    for (Keypoint keypoint in keypoints) {
      if (keypoint.position != null) {
        Offset scaledPosition = Offset(
          keypoint.position!.dx * scale + offsetX,
          keypoint.position!.dy * scale + offsetY,
        );

        // Draw the keypoint
        canvas.drawCircle(scaledPosition, 5, pointPaint);

        // Draw the label
        textPainter.text = TextSpan(
            text: keypoint.angle != null
                ? '${keypoint.part} ${keypoint.angle!.toStringAsFixed(1)}°'
                : keypoint.part,
            style: textStyle);
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(scaledPosition.dx - textPainter.width / 2,
              scaledPosition.dy - 20),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Keypoint {
  final String part;
  final Offset? position;
  final double? angle; // Add an optional angle field

  Keypoint({required this.part, this.position, this.angle});

  factory Keypoint.fromJson(Map<String, dynamic> json) {
    return Keypoint(
      part: json['part'],
      position: json['position'] != null
          ? Offset(
              json['position'][0].toDouble(), json['position'][1].toDouble())
          : null,
      angle: json['angle']?.toDouble(), // Deserialize the angle if available
    );
  }
}
