import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/my_workout_entity.dart';

class MyWorkoutModel extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String? image;
  final double? kcal;
  final Timestamp time;
  final String duration;
  final double progress;
  final double difficultyLevel;
  final int? customReps;
  final double? customWeights;
  final DateTime date;
  final String? video;

  const MyWorkoutModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    this.image,
    this.kcal,
    required this.time,
    required this.duration,
    required this.progress,
    required this.difficultyLevel,
    this.customReps,
    this.customWeights,
    required this.date,
    this.video,
  });

  MyWorkoutModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? image,
    double? kcal,
    Timestamp? time,
    String? duration,
    double? progress,
    double? difficultyLevel,
    int? customReps,
    double? customWeights,
    DateTime? date,
    String? video,
  }) {
    return MyWorkoutModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      kcal: kcal ?? this.kcal,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      progress: progress ?? this.progress,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      customReps: customReps ?? this.customReps,
      customWeights: customWeights ?? this.customWeights,
      date: date ?? this.date,
      video: video ?? this.video,
    );
  }

  static MyWorkoutModel fromEntity(MyWorkoutEntity entity) {
    return MyWorkoutModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      description: entity.description,
      image: entity.image,
      kcal: entity.kcal,
      time: entity.time,
      duration: entity.duration,
      progress: entity.progress,
      difficultyLevel: entity.difficultyLevel,
      customReps: entity.customReps,
      customWeights: entity.customWeights,
      date: entity.date,
      video: entity.video,
    );
  }

  MyWorkoutEntity toEntity() {
    return MyWorkoutEntity(
      id: id,
      userId: userId,
      name: name,
      description: description,
      image: image,
      kcal: kcal,
      time: time,
      duration: duration,
      progress: progress,
      difficultyLevel: difficultyLevel,
      customReps: customReps,
      customWeights: customWeights,
      date: date,
      video: video,
    );
  }

  @override
  List<Object?> get props => [
    id, userId, name, description, image, kcal, time, duration, progress, difficultyLevel, customReps, customWeights, date, video
  ];
}
