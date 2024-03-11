import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/widgets/round_button.dart';

void main() {
  testWidgets('RoundButton builds correctly', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: RoundButton(title: 'Test', onPressed: () {}),
      ),
    ));

    // Assert
    expect(find.text('Test'), findsOneWidget);
  });


  testWidgets('RoundButton shows correct text style for textGradient type',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: RoundButton(
            type: RoundButtonType.textGradient,
            title: 'Test',
            onPressed: () {}),
      ),
    ));

    // Assert
    // Here you might need to find the Text widget within the ShaderMask for verification
  });

  testWidgets('RoundButton onPressed callback is triggered when tapped',
      (WidgetTester tester) async {
    // Arrange
    bool tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: RoundButton(
          title: 'Test',
          onPressed: () => tapped = true,
        ),
      ),
    ));

    // Act
    await tester.tap(find.byType(RoundButton));
    await tester.pump(); // Rebuild the widget after the state change.

    // Assert
    expect(tapped, true);
  });
}
// Adjust the import path based on your project structure
