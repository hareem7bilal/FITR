import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/my_workout_entity.dart';

class Exercise extends Equatable {
  final String name;
  final String? image;
  final String? duration;
  final int? repetitions;

  const Exercise({
    required this.name,
    this.image,
    this.duration,
    this.repetitions,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'] as String? ?? '',
      image: map['image'] as String?,
      duration: map['duration'] as String?,
      repetitions: map['repetitions'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'duration': duration,
      'repetitions': repetitions,
    };
  }

  @override
  List<Object?> get props => [name, image, duration, repetitions];
}

class WorkoutSet extends Equatable {
  final String title;
  final List<Exercise> exercises;

  const WorkoutSet({
    required this.title,
    required this.exercises,
  });

  WorkoutSet copyWith({
    String? title,
    List<Exercise>? exercises,
  }) {
    return WorkoutSet(
      title: title ?? this.title,
      exercises: exercises ?? List<Exercise>.from(this.exercises),
    );
  }

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    var exerciseList = map['exercises'] as List<dynamic>? ?? [];
    List<Exercise> exercises = exerciseList.map((e) {
      return Exercise.fromMap(e as Map<String, dynamic>? ?? {});
    }).toList();
    return WorkoutSet(
      title: map['title'] as String? ?? '',
      exercises: exercises,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'exercises': exercises.map((e) => e.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [title, exercises];
}

class MyWorkoutModel extends Equatable {
  final String id;
  final List<String> allowedUserIds;
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
  final int numberOfExercises;
  final List<String> itemsNeeded;
  final List<WorkoutSet> sets;

  const MyWorkoutModel({
    required this.id,
    required this.allowedUserIds,
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
    required this.numberOfExercises,
    required this.itemsNeeded,
    required this.sets,
  });

  MyWorkoutModel copyWith({
    String? id,
    List<String>? allowedUserIds,
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
    int? numberOfExercises,
    List<String>? itemsNeeded,
    List<WorkoutSet>? sets,
  }) {
    return MyWorkoutModel(
      id: id ?? this.id,
      allowedUserIds: allowedUserIds ?? this.allowedUserIds,
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
      numberOfExercises: numberOfExercises ?? this.numberOfExercises,
      itemsNeeded: itemsNeeded ?? this.itemsNeeded,
      sets: sets ?? this.sets,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'allowedUserIds': allowedUserIds,
      'name': name,
      'description': description,
      'image': image,
      'kcal': kcal,
      'time': time,
      'duration': duration,
      'progress': progress,
      'difficultyLevel': difficultyLevel,
      'customReps': customReps,
      'customWeights': customWeights,
      'date': Timestamp.fromDate(date), // Store as Firestore Timestamp
      'video': video,
      'numberOfExercises': numberOfExercises,
      'itemsNeeded': itemsNeeded,
      'sets': sets.map((s) => s.toMap()).toList(), // Ensure each WorkoutSet has its own toMap
    };
  }

  static MyWorkoutModel fromEntity(MyWorkoutEntity entity) {
    return MyWorkoutModel(
      id: entity.id,
      allowedUserIds: entity.allowedUserIds,
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
      numberOfExercises: entity.numberOfExercises,
      itemsNeeded: entity.itemsNeeded,
      sets: entity.sets.map((s) => WorkoutSet.fromMap(s)).toList(),
    );
  }

  MyWorkoutEntity toEntity() {
    return MyWorkoutEntity(
      id: id,
      allowedUserIds: allowedUserIds,
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
      numberOfExercises: numberOfExercises,
      itemsNeeded: itemsNeeded,
      sets: sets.map((s) => s.toMap()).toList(),
    );
  }

  static MyWorkoutModel fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};

    List<String> parseItemsNeeded(dynamic items) {
      if (items is List) {
        // Safe cast and handling of items, ensuring only string types are added
        return List<String>.from(items.map((item) => item.toString()));
      } else {
        return [];
      }
    }

    return MyWorkoutModel(
      id: snapshot.id,
      allowedUserIds:
          List<String>.from(data['allowedUserIds'] as List<dynamic>? ?? []),
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      time: data['time'] as Timestamp? ?? Timestamp.now(),
      duration: data['duration'] as String? ?? '',
      progress: (data['progress'] as num?)?.toDouble() ?? 0.0,
      difficultyLevel: (data['difficultyLevel'] as num?)?.toDouble() ?? 0.0,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      numberOfExercises: (data['numberOfExercises'] as int?) ?? 0,
      image: data['image'] as String?,
      kcal: num.tryParse(data['kcal']?.toString() ?? '0')?.toDouble(),
      customReps: data['customReps'] as int?,
      customWeights: (data['customWeights'] as num?)?.toDouble(),
      video: data['video'] as String?,
      itemsNeeded: parseItemsNeeded(data['itemsNeeded']),
      sets: (data['sets'] as List<dynamic>?)
              ?.map((s) => WorkoutSet.fromMap(s as Map<String, dynamic>? ?? {}))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [
        id,
        allowedUserIds,
        name,
        description,
        image,
        kcal,
        time,
        duration,
        progress,
        difficultyLevel,
        customReps,
        customWeights,
        date,
        video,
        numberOfExercises,
        itemsNeeded,
        sets
      ];
}
