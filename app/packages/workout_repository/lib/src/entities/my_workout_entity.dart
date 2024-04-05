import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyWorkoutEntity extends Equatable {
  final String name;
  final String description; // Added compulsory description attribute
  final String? image;
  final double? kcal;
  final Timestamp time;
  final double progress;

  const MyWorkoutEntity({
    required this.name,
    required this.description, // Mark as required in the constructor
    this.image,
    this.kcal,
    required this.time,
    required this.progress,
  });

  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'description': description, // Include in document map
      'image': image,
      'kcal': kcal,
      'time': time,
      'progress': progress,
    };
  }

  static MyWorkoutEntity fromDocument(Map<String, dynamic> doc) {
    return MyWorkoutEntity(
      name: doc['name'] as String,
      description: doc['description'] as String, // Extract from document
      image: doc['image'] as String?,
      kcal: (doc['kcal'] as num?)?.toDouble(),
      time: doc['time'] as Timestamp,
      progress: (doc['progress'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [name, description, image, kcal, time, progress]; // Include description in props

  @override
  String toString() => 'MyWorkoutEntity(name: $name, description: $description, image: $image, kcal: $kcal, time: $time, progress: $progress)';
}
