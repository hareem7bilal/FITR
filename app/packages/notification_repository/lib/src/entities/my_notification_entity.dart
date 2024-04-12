import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyNotificationEntity extends Equatable {
  final String userId;
  final String description;
  final String? image;
  final Timestamp time;

  const MyNotificationEntity({
    required this.userId,
    required this.description,
    this.image,
    required this.time,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'description': description,
      'image': image,
      'time': time,
    };
  }

  static MyNotificationEntity fromDocument(Map<String, dynamic> doc) {
    return MyNotificationEntity(
      userId: doc['userId'] as String,
      description: doc['description'] as String,
      image: doc['image'] as String?,
      time: doc['time'] as Timestamp,
    );
  }

  @override
  List<Object?> get props => [
    userId, description, image, time
  ];
}
