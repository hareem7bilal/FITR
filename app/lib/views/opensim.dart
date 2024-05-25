import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:flutter_application_1/utils/color_extension.dart'; // Make sure the path matches your project structure
import 'package:http/http.dart' as http;
import 'dart:convert';

class TRCProcessor extends StatelessWidget {
  const TRCProcessor({super.key});

  @override
  Widget build(BuildContext context) {
    return const UploadScreen();
  }
}

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String _response =
      "Upload a scaled model and TRC file to see the joint angles here.";
  bool _isUploading = false;
  final List<Map<String, dynamic>> _angles = [];

  Future<void> _pickAndUploadFiles() async {
    FilePickerResult? modelResult = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    if (modelResult != null && modelResult.files.isNotEmpty) {
      List<File> osimFiles = modelResult.files
          .where((file) => file.extension == 'osim')
          .map((file) => File(file.path ?? ''))
          .toList();

      List<File> trcFiles = modelResult.files
          .where((file) => file.extension == 'trc')
          .map((file) => File(file.path ?? ''))
          .toList();

      if (osimFiles.isNotEmpty && trcFiles.isNotEmpty) {
        File modelFile = osimFiles.first;
        File trcFile = trcFiles.first;

        var uri = Uri.parse('http://10.7.226.143:5000/process_opensim');
        var request = http.MultipartRequest('POST', uri)
          ..files.add(
              await http.MultipartFile.fromPath('model_file', modelFile.path))
          ..files
              .add(await http.MultipartFile.fromPath('trc_file', trcFile.path));

        setState(() {
          _isUploading = true;
        });

        try {
          var response = await request.send();
          var responseData = await response.stream.bytesToString();

          if (response.statusCode == 200) {
            parseResponse(
                responseData); // Parse the JSON data from the response
            setState(() {
              _response = "Joint angles successfully calculated and loaded!";
              _isUploading = false;
            });
          } else {
            setState(() {
              _response = "Error loading data: Status ${response.statusCode}";
              _isUploading = false;
            });
          }
        } catch (e) {
          setState(() {
            _response = 'Failed to upload files: ${e.toString()}';
            _isUploading = false;
          });
        }
      } else {
        setState(() {
          _response =
              'Please select both an OSIM and a TRC file before uploading.';
        });
      }
    }
  }

  void parseResponse(String response) {
    var jsonData = jsonDecode(response);
    _angles.clear();

    // Check if jsonData is not empty and is indeed a Map
    if (jsonData.isNotEmpty && jsonData is Map<String, dynamic>) {
      jsonData.forEach((jointName, dynamic data) {
        // Ensure 'data' is a List before proceeding
        if (data is List) {
          List<String> anglesWithTime = data.map((dynamic pair) {
            // Check if 'pair' is a List and has at least two elements
            if (pair is List && pair.length >= 2) {
              return "${pair[0]}s: ${pair[1]}°";
            } else {
              debugPrint("Incorrect data format for pair: $pair");
              return "Invalid data";
            }
          }).toList();

          _angles.add({
            'joint': jointName,
            'anglesWithTime': anglesWithTime.join(", ")
          });
          debugPrint(
              "Parsed angle data: ${_angles.last}"); // Debugging: Log parsed data
        } else {
          debugPrint("Data format is incorrect for joint $jointName: $data");
        }
      });
    } else {
      debugPrint(
          "No data found in response or response format is incorrect."); // Debugging: Log empty response data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text(
          'OpenSim Inverse Kinematics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20 // Set the text color to white
          ),
        ),
        backgroundColor: TColor.primaryColor1,
        iconTheme:
            const IconThemeData(color: Colors.white), // Set the icon color to white
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo[50], // Set the background color to black
                    borderRadius:
                        BorderRadius.circular(10), // Round the corners
                    border: Border.all(
                      color: TColor.primaryColor2,
                      width: 3, // White border for contrast
                    ),
                  ),
                  padding:
                      const EdgeInsets.all(10), // Padding inside the container
                  child: Text(
                    'Upload your model and TRC files to calculate joint angles using OpenSim\'s '
                    'inverse kinematics tools. This process helps to estimate joint angles from motion '
                    'capture data in a biomechanically accurate manner.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 13,
                      color: TColor
                          .primaryColor1, // Text color set to white for contrast
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0), // Horizontal padding for the button
                child: RoundButton(
                  title: 'Upload Model and TRC Files',
                  onPressed: () {
                    if (!_isUploading) {
                      _pickAndUploadFiles();
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              _isUploading
                  ? const CircularProgressIndicator()
                  : _response.isEmpty || _angles.isEmpty
                      ? const Text("No data to display",
                          style: TextStyle(color: Colors.grey))
                      : DataTable(
                          columns: const [
                            DataColumn(label: Text('Joint')),
                            DataColumn(label: Text('Angles with Times')),
                          ],
                          rows: _angles
                              .map(
                                (angle) => DataRow(cells: [
                                  DataCell(Text(angle['joint'])),
                                  DataCell(
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(angle['anglesWithTime']),
                                    ),
                                  ),
                                ]),
                              )
                              .toList(),
                        ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
