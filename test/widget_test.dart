import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:module_clone/main.dart';
import 'package:module_clone/models/assignment_model.dart';
import 'package:module_clone/models/course_model.dart';
import 'package:module_clone/models/user_model.dart';
import 'package:module_clone/providers/assignment_provider.dart';
import 'package:module_clone/providers/auth_provider.dart';
import 'package:module_clone/providers/course_provider.dart';
import 'package:module_clone/route/app_router.dart';
import 'package:module_clone/utils/mock_data.dart';

class _FakeAuthProvider extends ChangeNotifier implements AuthProvider {
  _FakeAuthProvider(this._user);

  final UserModel _user;

  @override
  AuthStatus get status => AuthStatus.authenticated;

  @override
  UserModel? get user => _user;

  @override
  String? get errorMessage => null;

  @override
  bool get isAuthenticated => true;

  @override
  Future<bool> loginWithEmail(String email, String password) async => true;

  @override
  Future<bool> register(String name, String email, String password) async =>
      true;

  @override
  Future<void> logout() async {}

  @override
  void clearErrors() {}
}

class _FakeCourseProvider extends ChangeNotifier implements CourseProvider {
  _FakeCourseProvider(this._courses);

  final List<CourseModel> _courses;

  @override
  List<CourseModel> get courses => _courses;

  @override
  bool get isLoading => false;

  @override
  String? get errorMessage => null;

  @override
  List<CourseModel> searchCourses(String query) {
    final lowerQuery = query.toLowerCase();
    return _courses.where((course) {
      return course.title.toLowerCase().contains(lowerQuery) ||
          course.courseCode.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}

class _FakeAssignmentProvider extends ChangeNotifier
    implements AssignmentProvider {
  _FakeAssignmentProvider(this._assignments);

  final List<AssignmentModel> _assignments;

  @override
  List<AssignmentModel> get assignments => _assignments;

  @override
  bool get isLoading => false;

  @override
  bool get isSubmitting => false;

  @override
  String? get errorMessage => null;

  @override
  List<AssignmentModel> getAssignmentsForCourse(String courseId) {
    return _assignments
        .where((assignment) => assignment.courseId == courseId)
        .toList();
  }

  @override
  Future<bool> submitAssignment({
    required String assignmentId,
    required String submissionText,
    String? fileName,
    Uint8List? fileBytes,
  }) async {
    return true;
  }
}

Widget _buildTestApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => _FakeAuthProvider(MockData.currentUser),
      ),
      ChangeNotifierProvider<CourseProvider>(
        create: (_) => _FakeCourseProvider(MockData.courses),
      ),
      ChangeNotifierProvider<AssignmentProvider>(
        create: (_) => _FakeAssignmentProvider(MockData.assignments),
      ),
    ],
    child: const MyApp(),
  );
}

Future<void> _pumpTestApp(WidgetTester tester) async {
  AppRouter.router.go('/dashboard');
  await tester.pumpWidget(_buildTestApp());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('App renders dashboard and courses screen correctly', (
    WidgetTester tester,
  ) async {
    // Set desktop screen size
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await _pumpTestApp(tester);

    expect(find.text('Welcome back, Fardeen'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(Drawer),
        matching: find.text('My Courses'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Courses'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search courses...'), findsOneWidget);
    expect(find.text('Advanced Mathematics'), findsOneWidget);
  });

  testWidgets('Course search filters courses correctly', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await _pumpTestApp(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(Drawer),
        matching: find.text('My Courses'),
      ),
    );
    await tester.pumpAndSettle();

    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'Cloud');
    await tester.pumpAndSettle();

    expect(find.text('Cloud Computing Architecture'), findsOneWidget);
    expect(find.text('Advanced Mathematics'), findsNothing);

    await tester.enterText(searchField, '');
    await tester.pumpAndSettle();
    expect(find.text('Advanced Mathematics'), findsOneWidget);
  });

  testWidgets('Dashboard cards are present and interactive', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await _pumpTestApp(tester);

    expect(find.text('Welcome back, Fardeen'), findsOneWidget);
    expect(find.text('Firebase Connected'), findsOneWidget);

    expect(find.text('My Courses'), findsOneWidget);
    expect(find.text('Assessments'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    await tester.tap(find.text('Profile').hitTestable());
    await tester.pumpAndSettle();

    expect(find.text('Student Profile'), findsOneWidget);
  });

  testWidgets('Navigation through drawer works correctly', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await _pumpTestApp(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(of: find.byType(Drawer), matching: find.text('Profile')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Student Profile'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(Drawer),
        matching: find.text('Dashboard'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome back, Fardeen'), findsOneWidget);
  });
}
