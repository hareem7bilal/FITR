import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class MyUserModel extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime? dob; // Optional
  final String? gender; // Optional
  final double? weight; // Optional
  final double? height; // Optional

  const MyUserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.dob, // Optional
    this.gender, // Optional
    this.weight, // Optional
    this.height, // Optional
  });

  static const empty = MyUserModel(
    id: '',
    email: '',
    firstName: '',
    lastName: '',
    // No need to explicitly set optional attributes to null
  );

  MyUserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    DateTime? dob,
    String? gender,
    double? weight,
    double? height,
  }) {
    return MyUserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        dob: dob ?? this.dob,
        gender: gender ?? this.gender,
        weight: weight ?? this.weight,
        height: height ?? this.height);
  }

  bool get isEmpty => this == MyUserModel.empty;
  bool get isNotEmpty => this != MyUserModel.empty;

  MyUserEntity toEntity() {
    return MyUserEntity(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      dob: dob, // Assuming MyUserEntity also supports these fields
      gender: gender,
      weight: weight,
      height: height,
    );
  }

  static MyUserModel fromEntity(MyUserEntity entity) {
    return MyUserModel(
      id: entity.id,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      dob: entity.dob,
      gender: entity.gender,
      weight: entity.weight,
      height: entity.height,
    );
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, dob, gender, weight, height];
}

