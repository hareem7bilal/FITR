import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/app_view.dart';
import 'package:flutter_application_1/views/onboarding/starting_view.dart';
import 'package:flutter_application_1/views/onboarding/onboarding_view.dart';
import 'package:firebase_core/firebase_core.dart'; // For Firebase initialization
import 'package:mockito/mockito.dart';
import 'package:user_repository/user_repository.dart';
import 'package:workout_repository/workout_repository.dart';
import 'mocks/firebase_mock.mocks.dart';
import 'mocks/workout_repository_mock.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Initialize Firebase before tests
  });

  group('MyApp Integration Test', () {
    testWidgets('Should initialize and show AppView', (WidgetTester tester) async {
      // Setup FirebaseUserRepository with Firebase initialization
      final userRepository = FirebaseUserRepository();
      final workoutRepository = FirebaseWorkoutRepository();

      // Start the app with MyApp
      await tester.pumpWidget(MyApp(userRepository, workoutRepository));

      // Check if AppView is shown initially
      expect(find.byType(AppView), findsOneWidget);
    });

    group('Authentication Tests', () {
      testWidgets('Should simulate successful sign-in and transition to OnBoardingView', (WidgetTester tester) async {
        // Set up mocks
        final mockFirebaseAuth = MockFirebaseAuth();
        final mockFirebaseUser = MockUser(); // Mock Firebase user
        final mockFirestore = MockFirebaseFirestore(); // Mock Firestore
        final mockWorkoutRepository = MockWorkoutRepository();

        // Simulate user authentication
        when(mockFirebaseAuth.authStateChanges()).thenAnswer(
          (_) => Stream.value(mockFirebaseUser),
        );

        // Create a user repository with mocked FirebaseAuth and Firestore
        final mockUserRepository = FirebaseUserRepository(
          firebaseAuth: mockFirebaseAuth,
          firestore: mockFirestore,
        );

        // Initialize with the mock repository
        await tester.pumpWidget(MyApp(mockUserRepository, mockWorkoutRepository));

        // Verify the initial state
        expect(find.byType(StartingView), findsOneWidget);

        // Tap the "Get Started" button to trigger navigation
        final getStartedButton = find.text("Get Started");
        await tester.tap(getStartedButton);

        await tester.pumpAndSettle(); // Allow transitions to complete

        // Check if OnBoardingView is displayed
        expect(find.byType(OnBoardingView), findsOneWidget);
      });
    });
  });
}
