import 'package:equatable/equatable.dart';

import '../entities/entities.dart';

class MyUserModel extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;

  const MyUserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  static const empty = MyUserModel(
    id: '',
    email: '',
    firstName: '',
    lastName: '',
  );

  MyUserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
  }) {
    return MyUserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName);
  }

  bool get isEmpty => this == MyUserModel.empty;
  bool get isNotEmpty => this != MyUserModel.empty;

  MyUserEntity toEntity() {
    return MyUserEntity(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
  }

  static MyUserModel fromEntity(MyUserEntity entity) {
    return MyUserModel(
      id: entity.id,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
    );
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName];
}
