import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:moodle/main.dart';

void main() {
  testWidgets('App renders dashboard and courses screen correctly',
      (WidgetTester tester) async {
    // Set desktop screen size
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MoodleApp());

    // Verify that the dashboard landing content exists.
    expect(find.text('Welcome back, Fardeen'), findsOneWidget);

    // Open drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Navigate to My Courses in drawer
    await tester.tap(find.text('My courses'));
    await tester.pumpAndSettle();

    // Verify Courses page contains search and module content.
    expect(find.text('My courses'), findsWidgets);
    expect(find.text('Search and open your current modules.'), findsOneWidget);
    expect(
        find.text('USER EXPERIENCE DESIGN AND IMPLEMENTATION'), findsOneWidget);
  });

  testWidgets('Course search filters courses correctly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MoodleApp());

    // Navigate to courses via drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My courses'));
    await tester.pumpAndSettle();

    // Find and use the search field
    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    // Type in search box to filter courses
    await tester.enterText(searchField, 'PROGRAMMING');
    await tester.pumpAndSettle();

    // Verify filtering: should find PROGRAMMING APPLICATIONS and PROGRAMMING LANGUAGES
    expect(find.text('PROGRAMMING APPLICATIONS'), findsOneWidget);
    expect(find.text('PROGRAMMING LANGUAGES'), findsOneWidget);

    // Clear search and verify all courses are back
    await tester.enterText(searchField, '');
    await tester.pumpAndSettle();
    expect(
        find.text('USER EXPERIENCE DESIGN AND IMPLEMENTATION'), findsOneWidget);
  });

  testWidgets('Dashboard cards are present and interactive',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MoodleApp());

    // Check for stat cards
    expect(find.text('1 active module'), findsOneWidget);
    expect(find.text('3 upcoming items'), findsOneWidget);
    expect(find.text('Next deadline'), findsOneWidget);

    // Check for action cards
    expect(find.text('Open course details'), findsOneWidget);
    expect(find.text('Search courses'), findsOneWidget);
    expect(find.text('View profile'), findsOneWidget);

    // Tap on "View profile" action card
    await tester.tap(find.text('View profile'));
    await tester.pumpAndSettle();

    // Verify we navigated to profile
    expect(find.text('Student profile'), findsOneWidget);
  });

  testWidgets('Navigation through drawer works correctly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MoodleApp());

    // Open drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Navigate to Profile
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    // Verify we're on profile
    expect(find.text('Student profile'), findsOneWidget);

    // Open drawer again
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Navigate back to dashboard
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();

    // Verify we're back on dashboard
    expect(find.text('Welcome back, Fardeen'), findsOneWidget);
  });
}
