import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../entities/my_workout_entity.dart'; // Adjust the import path as necessary

class MyWorkoutModel extends Equatable {
  final String name;
  final String description; // Added description attribute
  final String? image; // Assuming this could be a URL to an image.
  final double? kcal;
  final Timestamp time; // Timestamp for when the workout occurred or will occur.
  final double progress;

  const MyWorkoutModel({
    required this.name,
    required this.description, // Mark description as required
    this.image,
    this.kcal,
    required this.time,
    required this.progress,
  });

  static final empty = MyWorkoutModel(
    name: '',
    description: '', // Default empty string for description
    time: Timestamp(0, 0), // Placeholder timestamp.
    progress: 0.0,
  );

  MyWorkoutModel copyWith({
    String? name,
    String? description, // Include description in copyWith
    String? image,
    double? kcal,
    Timestamp? time,
    double? progress,
  }) {
    return MyWorkoutModel(
      name: name ?? this.name,
      description: description ?? this.description, // Ensure null-coalescing for description
      image: image ?? this.image,
      kcal: kcal ?? this.kcal,
      time: time ?? this.time,
      progress: progress ?? this.progress,
    );
  }

  bool get isEmpty => this == MyWorkoutModel.empty;
  bool get isNotEmpty => this != MyWorkoutModel.empty;

  MyWorkoutEntity toEntity() {
    return MyWorkoutEntity(
      name: name,
      description: description, // Include description when converting to entity
      image: image,
      kcal: kcal,
      time: time,
      progress: progress,
    );
  }

  static MyWorkoutModel fromEntity(MyWorkoutEntity entity) {
    return MyWorkoutModel(
      name: entity.name,
      description: entity.description, // Extract description from entity
      image: entity.image,
      kcal: entity.kcal,
      time: entity.time,
      progress: entity.progress,
    );
  }

  @override
  List<Object?> get props => [name, description, image, kcal, time, progress];
}
