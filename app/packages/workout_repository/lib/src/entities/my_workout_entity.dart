import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyWorkoutEntity extends Equatable {
  final String userId;
  final String name;
  final String description;
  final String? image;
  final double? kcal;
  final Timestamp time;
  final double progress;
  final String difficultyLevel;
  final int? customReps;
  final double? customWeights;
  final Timestamp duration; // Now using Timestamp

  const MyWorkoutEntity({
    required this.userId,
    required this.name,
    required this.description,
    this.image,
    this.kcal,
    required this.time,
    required this.progress,
    required this.difficultyLevel,
    this.customReps,
    this.customWeights,
    required this.duration,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'name': name,
      'description': description,
      'image': image,
      'kcal': kcal,
      'time': time,
      'progress': progress,
      'difficultyLevel': difficultyLevel,
      'customReps': customReps,
      'customWeights': customWeights,
      'duration': duration,
    };
  }

  static MyWorkoutEntity fromDocument(Map<String, dynamic> doc) {
    return MyWorkoutEntity(
      userId: doc['userId'] as String,
      name: doc['name'] as String,
      description: doc['description'] as String,
      image: doc['image'] as String?,
      kcal: (doc['kcal'] as num?)?.toDouble(),
      time: doc['time'] as Timestamp,
      progress: (doc['progress'] as num).toDouble(),
      difficultyLevel: doc['difficultyLevel'] as String,
      customReps: doc['customReps'] as int?,
      customWeights: (doc['customWeights'] as num?)?.toDouble(),
      duration: doc['duration'] as Timestamp,
    );
  }

  @override
  List<Object?> get props => [
    userId, name, description, image, kcal, time, progress, difficultyLevel, customReps, customWeights, duration
  ];
}
