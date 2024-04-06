import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../entities/my_workout_entity.dart'; // Make sure this path is correct

class MyWorkoutModel extends Equatable {
  final String userId; // Added userId attribute
  final String name;
  final String description;
  final String? image;
  final double? kcal;
  final Timestamp time;
  final double progress;

  const MyWorkoutModel({
    required this.userId, // Mark userId as required
    required this.name,
    required this.description,
    this.image,
    this.kcal,
    required this.time,
    required this.progress,
  });

  static final empty = MyWorkoutModel(
    userId: '', // Provide an empty string for userId
    name: '',
    description: '',
    time: Timestamp(0, 0),
    progress: 0.0,
  );

  MyWorkoutModel copyWith({
    String? userId, // Include userId in copyWith
    String? name,
    String? description,
    String? image,
    double? kcal,
    Timestamp? time,
    double? progress,
  }) {
    return MyWorkoutModel(
      userId: userId ?? this.userId, // Ensure null-coalescing for userId
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      kcal: kcal ?? this.kcal,
      time: time ?? this.time,
      progress: progress ?? this.progress,
    );
  }

  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  MyWorkoutEntity toEntity() {
    return MyWorkoutEntity(
      userId: userId, // Include userId when converting to entity
      name: name,
      description: description,
      image: image,
      kcal: kcal,
      time: time,
      progress: progress,
    );
  }

  static MyWorkoutModel fromEntity(MyWorkoutEntity entity) {
    return MyWorkoutModel(
      userId: entity.userId, // Extract userId from entity
      name: entity.name,
      description: entity.description,
      image: entity.image,
      kcal: entity.kcal,
      time: entity.time,
      progress: entity.progress,
    );
  }

  @override
  List<Object?> get props => [userId, name, description, image, kcal, time, progress];
}
