import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/my_notification_entity.dart';

class MyNotificationModel extends Equatable {
  final String userId;
  final String description;
  final String? image;
  final Timestamp time;

  const MyNotificationModel({
    required this.userId,
    required this.description,
    this.image,
    required this.time,
  });

  MyNotificationModel copyWith({
    String? userId,
    String? description,
    String? image,
    Timestamp? time,
  }) {
    return MyNotificationModel(
      userId: userId ?? this.userId,
      description: description ?? this.description,
      image: image ?? this.image,
      time: time ?? this.time,
    );
  }

  static MyNotificationModel fromEntity(MyNotificationEntity entity) {
    return MyNotificationModel(
      userId: entity.userId,
      description: entity.description,
      image: entity.image,
      time: entity.time,
    );
  }

  MyNotificationEntity toEntity() {
    return MyNotificationEntity(
      userId: userId,
      description: description,
      image: image,
      time: time,
    );
  }

  @override
  List<Object?> get props => [
    userId, description, image, time
  ];
}
