import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyWorkoutEntity extends Equatable {
  final String userId; // Added userId attribute
  final String name;
  final String description;
  final String? image;
  final double? kcal;
  final Timestamp time;
  final double progress;

  const MyWorkoutEntity({
    required this.userId, // Mark userId as required
    required this.name,
    required this.description,
    this.image,
    this.kcal,
    required this.time,
    required this.progress,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId, // Include userId in document map
      'name': name,
      'description': description,
      'image': image,
      'kcal': kcal,
      'time': time,
      'progress': progress,
    };
  }

  static MyWorkoutEntity fromDocument(Map<String, dynamic> doc) {
    return MyWorkoutEntity(
      userId: doc['userId'] as String, // Extract userId from document
      name: doc['name'] as String,
      description: doc['description'] as String,
      image: doc['image'] as String?,
      kcal: (doc['kcal'] as num?)?.toDouble(),
      time: doc['time'] as Timestamp,
      progress: (doc['progress'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [userId, name, description, image, kcal, time, progress]; // Include userId in props

  @override
  String toString() {
    return 'MyWorkoutEntity(userId: $userId, name: $name, description: $description, image: $image, kcal: $kcal, time: $time, progress: $progress)';
  }
}
