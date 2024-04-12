import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyActivityEntity extends Equatable {
  final String userId;
  final String description;
  final Timestamp time;
  final double progress;
  final String? image; // Changed back from 'picture' to 'image'

  const MyActivityEntity({
    required this.userId,
    required this.description,
    required this.time,
    required this.progress,
    this.image,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'description': description,
      'time': time,
      'progress': progress,
      'image': image,
    };
  }

  static MyActivityEntity fromDocument(Map<String, dynamic> doc) {
    return MyActivityEntity(
      userId: doc['userId'] as String,
      description: doc['description'] as String,
      time: doc['time'] as Timestamp,
      progress: (doc['progress'] as num).toDouble(),
      image: doc['image'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    userId, description, time, progress, image
  ];
}
