import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

/// A detector for performing body-pose estimation.
class PoseDetector {
  static const MethodChannel _channel =
      MethodChannel('google_mlkit_pose_detector');
  final PoseDetectorOptions options;
  final String id = DateTime.now().microsecondsSinceEpoch.toString();
  final FlutterTts tts = FlutterTts(); // TTS instance

  PoseDetector({required this.options}) {
    initializeTts();
  }

  Future<void> initializeTts() async {
    await tts.setLanguage('en-US');
    await tts.setSpeechRate(0.5);
    await tts.setVolume(1.0);
    await tts.setPitch(1.0);
  }

  Future<List<Pose>> processImage(InputImage inputImage) async {
    final result = await _channel.invokeMethod('vision#startPoseDetector', {
      'options': options.toJson(),
      'id': id,
      'imageData': inputImage.toJson()
    });

    final List<Pose> poses = [];
    for (final poseData in result) {
      final Map<PoseLandmarkType, PoseLandmark> landmarks = {};
      for (final point in poseData) {
        final landmark = PoseLandmark.fromJson(point);
        landmarks[landmark.type] = landmark;
      }
      final Pose pose = Pose(landmarks: landmarks);
      pose.angles = calculateAllBodyAngles(pose);
      poses.add(pose);
    }

    return poses;
  }

  Map<String, int> calculateAllBodyAngles(Pose pose) {
    final Map<String, int> angles = {};
    final Map<String, List<PoseLandmarkType>> angleDefinitions = {
      'Right Elbow': [
        PoseLandmarkType.rightShoulder,
        PoseLandmarkType.rightElbow,
        PoseLandmarkType.rightWrist
      ],
      'Left Elbow': [
        PoseLandmarkType.leftShoulder,
        PoseLandmarkType.leftElbow,
        PoseLandmarkType.leftWrist
      ],
      'Right Knee': [
        PoseLandmarkType.rightHip,
        PoseLandmarkType.rightKnee,
        PoseLandmarkType.rightAnkle
      ],
      'Left Knee': [
        PoseLandmarkType.leftHip,
        PoseLandmarkType.leftKnee,
        PoseLandmarkType.leftAnkle
      ],
      'Right Shoulder': [
        PoseLandmarkType.rightElbow,
        PoseLandmarkType.rightShoulder,
        PoseLandmarkType.rightHip
      ],
      'Left Shoulder': [
        PoseLandmarkType.leftElbow,
        PoseLandmarkType.leftShoulder,
        PoseLandmarkType.leftHip
      ],
      'Right Hip': [
        PoseLandmarkType.rightShoulder,
        PoseLandmarkType.rightHip,
        PoseLandmarkType.rightKnee
      ],
      'Left Hip': [
        PoseLandmarkType.leftShoulder,
        PoseLandmarkType.leftHip,
        PoseLandmarkType.leftKnee
      ],

      // Added detailed angles for lower extremity
      'Right Ankle': [
        PoseLandmarkType.rightKnee,
        PoseLandmarkType.rightAnkle,
        PoseLandmarkType.rightHeel
      ],
      'Left Ankle': [
        PoseLandmarkType.leftKnee,
        PoseLandmarkType.leftAnkle,
        PoseLandmarkType.leftHeel
      ],
      'Right Foot': [
        PoseLandmarkType.rightAnkle,
        PoseLandmarkType.rightHeel,
        PoseLandmarkType.rightFootIndex
      ],
      'Left Foot': [
        PoseLandmarkType.leftAnkle,
        PoseLandmarkType.leftHeel,
        PoseLandmarkType.leftFootIndex
      ],

      // Assuming the line from heel to foot index approximates the line of the foot,
      // and using the ankle as a pivot, we can define an angle that might approximate
      // "toe lift" or "toe point" angles relative to the leg.
      'Right Toe Point': [
        PoseLandmarkType.rightKnee,
        PoseLandmarkType.rightAnkle,
        PoseLandmarkType.rightFootIndex
      ],
      'Left Toe Point': [
        PoseLandmarkType.leftKnee,
        PoseLandmarkType.leftAnkle,
        PoseLandmarkType.leftFootIndex
      ],

      // Additional detailed angles considering the pelvis and the relation between upper and lower legs
      'Right Upper and Lower Leg': [
        PoseLandmarkType.rightHip,
        PoseLandmarkType.rightKnee,
        PoseLandmarkType.rightAnkle
      ],
      'Left Upper and Lower Leg': [
        PoseLandmarkType.leftHip,
        PoseLandmarkType.leftKnee,
        PoseLandmarkType.leftAnkle
      ],
    };

    for (final entry in angleDefinitions.entries) {
      final String angleName = entry.key;
      final List<PoseLandmarkType> landmarks = entry.value;
      if (landmarks.every((type) => pose.landmarks.containsKey(type))) {
        final PoseLandmark a = pose.landmarks[landmarks[0]]!;
        final PoseLandmark b = pose.landmarks[landmarks[1]]!;
        final PoseLandmark c = pose.landmarks[landmarks[2]]!;
        final int angle = PoseAngleCalculator.calculate3DAngle(a, b, c);
        angles[angleName] = angle;
        // Check if the angle is dangerous
        if (isDangerousAngle(angleName, angle)) {
          tts.speak(
              'Warning: Dangerous $angleName angle of $angle degrees detected.');
          debugPrint(
              'Warning: Dangerous $angleName angle of $angle degrees detected.');
        }
      }
    }

    return angles;
  }

  bool isDangerousAngle(String joint, int angle) {
    // Define dangerous ranges for different joints
    final Map<String, List<int>> dangerRanges = {
      'Right Elbow': [10, 170],
      'Left Elbow': [10, 170],
      'Right Knee': [15, 175],
      'Left Knee': [15, 175],
      'Right Shoulder': [20, 160],
      'Left Shoulder': [20, 160],
      'Right Hip': [30, 130],
      'Left Hip': [30, 130],
      'Right Ankle': [15, 50],
      'Left Ankle': [15, 50],
      'Right Wrist': [10, 160],
      'Left Wrist': [10, 160]
    };

    if (!dangerRanges.containsKey(joint)) return false;
    return angle < dangerRanges[joint]![0] || angle > dangerRanges[joint]![1];
  }

  Future<void> close() =>
      _channel.invokeMethod('vision#closePoseDetector', {'id': id});
}

/// Determines the parameters on which [PoseDetector] works.
class PoseDetectorOptions {
  /// Specifies whether to use base or accurate pose model.
  final PoseDetectionModel model;

  /// The mode for the pose detector.
  final PoseDetectionMode mode;

  /// Constructor to create an instance of [PoseDetectorOptions].
  PoseDetectorOptions(
      {this.model = PoseDetectionModel.base,
      this.mode = PoseDetectionMode.stream});

  /// Returns a json representation of an instance of [PoseDetectorOptions].
  Map<String, dynamic> toJson() => {
        'model': model.name,
        'mode': mode.name,
      };
}

// Specifies whether to use base or accurate pose model.
enum PoseDetectionModel {
  /// Base pose detector with streaming.
  base,

  /// Accurate pose detector on static images.
  accurate,
}

/// The mode for the pose detector.
enum PoseDetectionMode {
  /// To process a static image. This mode is designed for single images where the detection of each image is independent.
  single,

  /// To process a stream of images. This mode is designed for streaming frames from video or camera.
  stream,
}

/// Available pose landmarks detected by [PoseDetector].
enum PoseLandmarkType {
  nose,
  leftEyeInner,
  leftEye,
  leftEyeOuter,
  rightEyeInner,
  rightEye,
  rightEyeOuter,
  leftEar,
  rightEar,
  leftMouth,
  rightMouth,
  leftShoulder,
  rightShoulder,
  leftElbow,
  rightElbow,
  leftWrist,
  rightWrist,
  leftPinky,
  rightPinky,
  leftIndex,
  rightIndex,
  leftThumb,
  rightThumb,
  leftHip,
  rightHip,
  leftKnee,
  rightKnee,
  leftAnkle,
  rightAnkle,
  leftHeel,
  rightHeel,
  leftFootIndex,
  rightFootIndex
}

/// Describes a pose detection result.
class Pose {
  /// A map of all the landmarks in the detected pose.
  final Map<PoseLandmarkType, PoseLandmark> landmarks;
  Map<String, int>? angles;

  /// Constructor to create an instance of [Pose].
  Pose({required this.landmarks, this.angles});
}

/// A landmark in a pose detection result.
class PoseLandmark {
  /// The landmark type.
  final PoseLandmarkType type;

  /// Gives x coordinate of landmark in image frame.
  final double x;

  /// Gives y coordinate of landmark in image frame.
  final double y;

  /// Gives z coordinate of landmark in image space.
  final double z;

  /// Gives the likelihood of this landmark being in the image frame.
  final double likelihood;

  /// Constructor to create an instance of [PoseLandmark].
  PoseLandmark({
    required this.type,
    required this.x,
    required this.y,
    required this.z,
    required this.likelihood,
  });

  /// Returns an instance of [PoseLandmark] from a given [json].
  factory PoseLandmark.fromJson(Map<dynamic, dynamic> json) {
    return PoseLandmark(
      type: PoseLandmarkType.values[json['type'].toInt()],
      x: json['x'],
      y: json['y'],
      z: json['z'],
      likelihood: json['likelihood'] ?? 0.0,
    );
  }
}

class PoseAngleCalculator {
  static int calculate3DAngle(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
    final double abX = b.x - a.x;
    final double abY = b.y - a.y;
    final double abZ = b.z - a.z;
    final double bcX = c.x - b.x;
    final double bcY = c.y - b.y;
    final double bcZ = c.z - b.z;
    final double dotProduct = abX * bcX + abY * bcY + abZ * bcZ;
    final double magnitudeAB = sqrt(abX * abX + abY * abY + abZ * abZ);
    final double magnitudeBC = sqrt(bcX * bcX + bcY * bcY + bcZ * bcZ);
    final double cosAngle = dotProduct / (magnitudeAB * magnitudeBC);
    final double angleRad = acos(cosAngle);
    final int angleDeg =
        (angleRad * 180 / pi).round(); // Round off to nearest integer
    return angleDeg;
  }
}
