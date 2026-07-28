import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:module_clone/firebase_options.dart';
import 'package:module_clone/main.dart';
import 'package:module_clone/models/assignment_model.dart';
import 'package:module_clone/models/course_model.dart';
import 'package:module_clone/models/user_model.dart';
import 'package:module_clone/providers/assignment_provider.dart';
import 'package:module_clone/providers/auth_provider.dart';
import 'package:module_clone/providers/course_provider.dart';
import 'package:module_clone/repositories/assignment_repository.dart';
import 'package:module_clone/repositories/auth_repository.dart';
import 'package:module_clone/repositories/course_repository.dart';
import 'package:module_clone/route/app_router.dart';
import 'package:module_clone/services/auth_service.dart';
import 'package:module_clone/services/firestore_service.dart';
import 'package:module_clone/services/storage_service.dart';
import 'package:module_clone/utils/mock_data.dart';

class _FakeAuthService extends AuthService {
  @override
  Stream<auth.User?> get authStateChanges => Stream.value(null);

  @override
  auth.User? get currentUser => null;

  @override
  Future<auth.UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<auth.UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {}
}

class _FakeFirestoreService extends FirestoreService {
  @override
  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    return Stream.value(<T>[]);
  }

  @override
  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentId) builder,
  }) {
    return Stream.value(builder(null, ''));
  }
}

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository() : super(_FakeAuthService(), _FakeFirestoreService());

  @override
  Stream<auth.User?> get authStateChanges => Stream.value(null);

  @override
  auth.User? get currentUser => null;

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return MockData.currentUser;
  }

  @override
  Future<UserModel> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    return MockData.currentUser;
  }

  @override
  Future<void> signOut() async {}
}

class _FakeCourseRepository extends CourseRepository {
  _FakeCourseRepository() : super(_FakeFirestoreService());

  @override
  Stream<List<CourseModel>> getAllCourses() {
    return Stream.value(MockData.courses);
  }
}

class _FakeAssignmentRepository extends AssignmentRepository {
  _FakeAssignmentRepository()
    : super(_FakeFirestoreService(), StorageService());

  @override
  Stream<List<AssignmentModel>> getAllAssignments() {
    return Stream.value(MockData.assignments);
  }
}

class _FakeAuthProvider extends AuthProvider {
  _FakeAuthProvider() : super(_FakeAuthRepository());

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

class _FakeCourseProvider extends CourseProvider {
  _FakeCourseProvider() : super(_FakeCourseRepository());

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

class _FakeAssignmentProvider extends AssignmentProvider {
  _FakeAssignmentProvider() : super(_FakeAssignmentRepository());

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
    child: const MyApp(),
  );
}

Future<void> _pumpTestApp(WidgetTester tester) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
