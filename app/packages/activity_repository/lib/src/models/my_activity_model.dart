import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/my_activity_entity.dart';

class MyActivityModel extends Equatable {
  final String userId;
  final String description;
  final Timestamp time;
  final double progress;
  final String? image;

  const MyActivityModel({
    required this.userId,
    required this.description,
    required this.time,
    required this.progress,
    this.image,
  });

  MyActivityModel copyWith({
    String? userId,
    String? description,
    Timestamp? time,
    double? progress,
    String? image,
  }) {
    return MyActivityModel(
      userId: userId ?? this.userId,
      description: description ?? this.description,
      time: time ?? this.time,
      progress: progress ?? this.progress,
      image: image ?? this.image,
    );
  }

  static MyActivityModel fromEntity(MyActivityEntity entity) {
    return MyActivityModel(
      userId: entity.userId,
      description: entity.description,
      time: entity.time,
      progress: entity.progress,
      image: entity.image,
    );
  }

  MyActivityEntity toEntity() {
    return MyActivityEntity(
      userId: userId,
      description: description,
      time: time,
      progress: progress,
      image: image,
    );
  }

  @override
  List<Object?> get props => [
    userId, description, time, progress, image
  ];
}
