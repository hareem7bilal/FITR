import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyWorkoutEntity extends Equatable {
    final String id;
    final List<String> allowedUserIds; 
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
    final int numberOfExercises;
    final List<String> itemsNeeded;
    final List<Map<String, dynamic>> sets;

    const MyWorkoutEntity({
        required this.id, // Include ID in constructor
        required this.allowedUserIds,
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
        required this.numberOfExercises,
        required this.itemsNeeded,
        required this.sets,
    });

    Map<String, Object?> toDocument() {
        return {
            'id': id, // Include the ID in the document map
            'allowedUserIds':allowedUserIds,
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
            'numberOfExercises': numberOfExercises,
            'itemsNeeded': itemsNeeded,
            'sets': sets,
        };
    }

    static MyWorkoutEntity fromDocument(Map<String, dynamic> doc) {
    return MyWorkoutEntity(
        id: doc['id'] as String? ?? '',
        allowedUserIds: List<String>.from(doc['allowedUserIds'] as List<dynamic>? ?? []),
        name: doc['name'] as String? ?? '',
        description: doc['description'] as String? ?? '',
        image: doc['image'] as String?,
        kcal: (doc['kcal'] as num?)?.toDouble(),
        time: doc['time'] as Timestamp? ?? Timestamp.now(),
        progress: (doc['progress'] as num?)?.toDouble() ?? 0.0,
        difficultyLevel: (doc['difficultyLevel'] as num?)?.toDouble() ?? 0.0,
        customReps: doc['customReps'] as int?,
        customWeights: (doc['customWeights'] as num?)?.toDouble(),
        duration: doc['duration'] as String? ?? '0 min',
        date: (doc['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
        video: doc['video'] as String?,
        numberOfExercises: doc['numberOfExercises'] as int? ?? 0,
        itemsNeeded: List<String>.from(doc['itemsNeeded'] as List<dynamic>? ?? []),
        sets: List<Map<String, dynamic>>.from(doc['sets'] as List<dynamic>? ?? []),
    );
}


    @override
    List<Object?> get props => [
        id, // Include ID in Equatable properties
        allowedUserIds,
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
        video,
        numberOfExercises,
        itemsNeeded,
        sets,
    ];
}

