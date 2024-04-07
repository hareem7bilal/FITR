import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/my_workout_entity.dart';

class MyWorkoutModel extends Equatable {
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

  const MyWorkoutModel({
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

  MyWorkoutModel copyWith({
    String? userId,
    String? name,
    String? description,
    String? image,
    double? kcal,
    Timestamp? time,
    double? progress,
    String? difficultyLevel,
    int? customReps,
    double? customWeights,
    Timestamp? duration,
  }) {
    return MyWorkoutModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      kcal: kcal ?? this.kcal,
      time: time ?? this.time,
      progress: progress ?? this.progress,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      customReps: customReps ?? this.customReps,
      customWeights: customWeights ?? this.customWeights,
      duration: duration ?? this.duration,
    );
  }

  static MyWorkoutModel fromEntity(MyWorkoutEntity entity) {
    return MyWorkoutModel(
      userId: entity.userId,
      name: entity.name,
      description: entity.description,
      image: entity.image,
      kcal: entity.kcal,
      time: entity.time,
      progress: entity.progress,
      difficultyLevel: entity.difficultyLevel,
      customReps: entity.customReps,
      customWeights: entity.customWeights,
      duration: entity.duration,
    );
  }

  MyWorkoutEntity toEntity() {
    return MyWorkoutEntity(
      userId: userId,
      name: name,
      description: description,
      image: image,
      kcal: kcal,
      time: time,
      progress: progress,
      difficultyLevel: difficultyLevel,
      customReps: customReps,
      customWeights: customWeights,
      duration: duration,
    );
  }

  @override
  List<Object?> get props => [
    userId, name, description, image, kcal, time, progress, difficultyLevel, customReps, customWeights, duration
  ];
}

