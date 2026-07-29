import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:module_clone/models/assignment_model.dart';
import 'package:module_clone/models/course_model.dart';
import 'package:module_clone/models/user_model.dart';
import 'package:module_clone/providers/assignment_provider.dart';
import 'package:module_clone/providers/auth_provider.dart';
import 'package:module_clone/providers/course_provider.dart';
import 'package:module_clone/screens/auth/login_screen.dart';
import 'package:module_clone/screens/assesments/assessments_view.dart';
import 'package:module_clone/screens/assesments/assignment_submission_screen.dart';
import 'package:module_clone/screens/calendar/calendar_view.dart';
import 'package:module_clone/screens/courses/course_detail_screen.dart';
import 'package:module_clone/screens/courses/courses_list_screen.dart';
import 'package:module_clone/screens/dashboard/dashboard_screen.dart';
import 'package:module_clone/screens/notifications_view.dart';
import 'package:module_clone/screens/profile/profile_screen.dart';
import 'package:module_clone/utils/mock_data.dart';
import 'dart:typed_data';

class _FakeAuthProvider extends ChangeNotifier implements AuthProvider {
  @override
  AuthStatus get status => AuthStatus.authenticated;

  @override
  UserModel? get user => MockData.currentUser;

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
  @override
  List<CourseModel> get courses => MockData.courses;

  @override
  bool get isLoading => false;

  @override
  String? get errorMessage => null;

  @override
  List<CourseModel> searchCourses(String query) {
    final lowerQuery = query.toLowerCase();
    return MockData.courses.where((course) {
      return course.title.toLowerCase().contains(lowerQuery) ||
          course.courseCode.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}

class _FakeAssignmentProvider extends ChangeNotifier
    implements AssignmentProvider {
  @override
  List<AssignmentModel> get assignments => MockData.assignments;

  @override
  bool get isLoading => false;

  @override
  bool get isSubmitting => false;

  @override
  String? get errorMessage => null;

  @override
  List<AssignmentModel> getAssignmentsForCourse(String courseId) {
    return MockData.assignments
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
      ChangeNotifierProvider<AuthProvider>(create: (_) => _FakeAuthProvider()),
      ChangeNotifierProvider<CourseProvider>(
        create: (_) => _FakeCourseProvider(),
      ),
      ChangeNotifierProvider<AssignmentProvider>(
        create: (_) => _FakeAssignmentProvider(),
      ),
    ],
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: GoRouter(
        initialLocation: '/dashboard',
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardView(),
          ),
          GoRoute(
            path: '/courses',
            builder: (context, state) => const CoursesListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final courseId = state.pathParameters['id']!;
                  return CourseDetailsView(courseId: courseId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/assignment/:id',
            builder: (context, state) {
              final assignmentId = state.pathParameters['id']!;
              return AssignmentSubmissionScreen(assignmentId: assignmentId);
            },
          ),
          GoRoute(
            path: '/assessments',
            builder: (context, state) => const AssessmentsView(),
          ),
          GoRoute(
            path: '/calendar',
            builder: (context, state) => const CalendarView(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsView(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileView(),
          ),
        ],
      ),
    ),
  );
}

Future<void> _pumpTestApp(WidgetTester tester) async {
  await tester.pumpWidget(_buildTestApp());
  await tester.pump();
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
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Welcome back, Fardeen'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 2),
    );

    await tester.tap(
      find
          .descendant(
            of: find.byType(Drawer),
            matching: find.text('My Courses'),
          )
          .first,
    );
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 2),
    );

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
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 2),
    );
    await tester.tap(
      find
          .descendant(
            of: find.byType(Drawer),
            matching: find.text('My Courses'),
          )
          .first,
    );
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 2),
    );

    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'Cloud');
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Cloud Computing Architecture'), findsOneWidget);
    expect(find.text('Advanced Mathematics'), findsNothing);

    await tester.enterText(searchField, '');
    await tester.pump(const Duration(milliseconds: 200));
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
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 2),
    );

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
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 2),
    );

    await tester.tap(
      find
          .descendant(of: find.byType(Drawer), matching: find.text('Profile'))
          .first,
    );
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 2),
    );

    expect(find.text('Student Profile'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 2),
    );

    await tester.tap(
      find
          .descendant(of: find.byType(Drawer), matching: find.text('Dashboard'))
          .first,
    );
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 2),
    );

    expect(find.text('Welcome back, Fardeen'), findsOneWidget);
  });
}
