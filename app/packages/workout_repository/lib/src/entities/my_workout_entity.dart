import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyWorkoutEntity extends Equatable {
  final String id; // Adding the ID field to uniquely identify each entity
  final String userId;
  final String name;
  final String description;
  final String? image;
  final double? kcal;
  final Timestamp time;
  final double progress;
  final double difficultyLevel;
  final int? customReps;
  final double? customWeights;
  final String duration;
  final DateTime date; // Compulsory date field
  final String? video; // Optional video field

  const MyWorkoutEntity({
    required this.id, // Include ID in constructor
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
    required this.date,
    this.video,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id, // Include the ID in the document map
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
      'date': Timestamp.fromDate(date), // Convert DateTime to Timestamp
      'video': video,
    };
  }

  static MyWorkoutEntity fromDocument(Map<String, dynamic> doc) {
    return MyWorkoutEntity(
      id: doc['id'] as String, // Retrieve the ID from the document
      userId: doc['userId'] as String,
      name: doc['name'] as String,
      description: doc['description'] as String,
      image: doc['image'] as String?,
      kcal: (doc['kcal'] as num?)?.toDouble(),
      time: doc['time'] as Timestamp,
      progress: (doc['progress'] as num).toDouble(),
      difficultyLevel: doc['difficultyLevel'].toDouble(),
      customReps: doc['customReps'] as int?,
      customWeights: (doc['customWeights'] as num?)?.toDouble(),
      duration: doc['duration'] as String,
      date:
          (doc['date'] as Timestamp).toDate(), // Convert Timestamp to DateTime
      video: doc['video'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id, // Include ID in Equatable properties
        userId,
        name,
        description,
        image,
        kcal,
        time,
        progress,
        difficultyLevel,
        customReps,
        customWeights,
        duration,
        date,
        video
      ];
}
