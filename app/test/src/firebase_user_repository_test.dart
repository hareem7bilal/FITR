import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:user_repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../mocks/mock.mocks.dart'; // Adjust this path as needed

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore
      mockFirestore; // Assuming Firestore is used and mocked.
  late FirebaseUserRepository userRepository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore(); // Initialize the Firestore mock.
    userRepository = FirebaseUserRepository(
        firebaseAuth: mockFirebaseAuth, firestore: mockFirestore);
  });

  group('FirebaseUserRepository', () {
    group('signIn', () {
      const testEmail = 'test@example.com';
      const testPassword = 'password';

      test('should call signInWithEmailAndPassword with correct parameters',
          () async {
        // Assuming you have a MockUserCredential. If not, replace MockUserCredential() with a suitable mock.
        final userCredential = MockUserCredential();
        when(mockFirebaseAuth.signInWithEmailAndPassword(
                email: testEmail, password: testPassword))
            .thenAnswer((_) async => userCredential);

        await userRepository.signIn(testEmail, testPassword);

        verify(mockFirebaseAuth.signInWithEmailAndPassword(
                email: testEmail, password: testPassword))
            .called(1);
      });

      test('should throw FirebaseAuthException when signIn fails', () {
        when(mockFirebaseAuth.signInWithEmailAndPassword(
                email: testEmail, password: testPassword))
            .thenThrow(FirebaseAuthException(code: 'user-not-found'));

        expect(userRepository.signIn(testEmail, testPassword),
            throwsA(isA<FirebaseAuthException>()));
      });
    });

    group('signOut', () {
      test('should call signOut', () async {
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        await userRepository.signOut();

        verify(mockFirebaseAuth.signOut()).called(1);
      });
    });

    group('signUp', () {
      const testEmail = 'test@example.com';
      const testPassword = 'password';
      const myUser = MyUserModel(
          id: 'testId', email: testEmail, firstName: 'Test', lastName: 'User');

      test('successful signUp', () async {
        final userCredential = MockUserCredential();
        final firebaseUser = MockUser(); // Ensure this mock is generated

        // Stub the user property to return a MockUser instance
        when(userCredential.user).thenReturn(firebaseUser);
        // If you're using the user's UID in your signUp method, you'll need to stub that as well
        when(firebaseUser.uid).thenReturn('mockUid');

        when(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: testEmail, password: testPassword))
            .thenAnswer((_) async => userCredential);

        await userRepository.signUp(myUser, testPassword);

        verify(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: testEmail, password: testPassword))
            .called(1);
      });
    });

    group('resetPassword', () {
      const testEmail = 'test@example.com';

      test('should call sendPasswordResetEmail with correct email', () async {
        when(mockFirebaseAuth.sendPasswordResetEmail(email: testEmail))
            .thenAnswer((_) async {});

        await userRepository.resetPassword(testEmail);

        verify(mockFirebaseAuth.sendPasswordResetEmail(email: testEmail))
            .called(1);
      });
    });

    group('setUserData', () {
      const myUser = MyUserModel(
          id: '123',
          email: 'user@example.com',
          firstName: 'Test',
          lastName: 'User');

      test('should successfully set user data', () async {
        final mockDocumentReference =
            MockDocumentReference<Map<String, dynamic>>();
        final mockCollectionReference =
            MockCollectionReference<Map<String, dynamic>>();

        // Stub the Firestore interactions
        when(mockFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(myUser.id))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.set(any)).thenAnswer((_) async {});

        // Act
        await userRepository.setUserData(myUser);

        // Assert
        // Verify that the document reference's set method was called with the expected data
        verify(mockDocumentReference.set({
          'id': myUser.id,
          'email': myUser.email,
          'firstName': myUser.firstName,
          'lastName': myUser.lastName,
        })).called(1);
      });
    });
  });
}
