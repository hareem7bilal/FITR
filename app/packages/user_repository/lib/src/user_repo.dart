import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/models.dart';

abstract class UserRepository {
  Stream<User?> get user;
  Future<void> signIn(String email, String password);
  Future<void> signOut();
  Future<MyUserModel> signUp(MyUserModel myUser, String password);
  Future<void> resetPassword(String email);
  Future<void> setUserData(MyUserModel myUser);
  Future<MyUserModel> getUserData(String myUserId);
  Future<void> updateUserProfile(MyUserModel myUser);

}
