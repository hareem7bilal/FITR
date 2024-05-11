// Mocks generated by Mockito 5.4.4 from annotations
// in flutter_application_1/test/mocks/user_repository_mock.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:firebase_auth/firebase_auth.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:user_repository/src/models/models.dart' as _i2;
import 'package:user_repository/src/user_repo.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeMyUserModel_0 extends _i1.SmartFake implements _i2.MyUserModel {
  _FakeMyUserModel_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [UserRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserRepository extends _i1.Mock implements _i3.UserRepository {
  MockUserRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i5.User?> get user => (super.noSuchMethod(
        Invocation.getter(#user),
        returnValue: _i4.Stream<_i5.User?>.empty(),
      ) as _i4.Stream<_i5.User?>);

  @override
  _i4.Future<void> signIn(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #signIn,
          [
            email,
            password,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> signOut() => (super.noSuchMethod(
        Invocation.method(
          #signOut,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<_i2.MyUserModel> signUp(
    _i2.MyUserModel? myUser,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #signUp,
          [
            myUser,
            password,
          ],
        ),
        returnValue: _i4.Future<_i2.MyUserModel>.value(_FakeMyUserModel_0(
          this,
          Invocation.method(
            #signUp,
            [
              myUser,
              password,
            ],
          ),
        )),
      ) as _i4.Future<_i2.MyUserModel>);

  @override
  _i4.Future<void> resetPassword(String? email) => (super.noSuchMethod(
        Invocation.method(
          #resetPassword,
          [email],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> setUserData(_i2.MyUserModel? myUser) => (super.noSuchMethod(
        Invocation.method(
          #setUserData,
          [myUser],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<_i2.MyUserModel> getUserData(String? myUserId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserData,
          [myUserId],
        ),
        returnValue: _i4.Future<_i2.MyUserModel>.value(_FakeMyUserModel_0(
          this,
          Invocation.method(
            #getUserData,
            [myUserId],
          ),
        )),
      ) as _i4.Future<_i2.MyUserModel>);

  @override
  _i4.Future<void> updateUserProfile(_i2.MyUserModel? myUser) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserProfile,
          [myUser],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}