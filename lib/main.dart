import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'route/app_router.dart';

// Services
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/storage_service.dart';

// Repositories
import 'repositories/auth_repository.dart';
import 'repositories/course_repository.dart';
import 'repositories/assignment_repository.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'providers/assignment_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 1. Initialize Services
  final authService = AuthService();
  final firestoreService = FirestoreService();
  final storageService = StorageService();

  // 2. Initialize Repositories
  final authRepository = AuthRepository(authService, firestoreService);
  final courseRepository = CourseRepository(firestoreService);
  final assignmentRepository = AssignmentRepository(firestoreService, storageService);

  // 3. Inject Providers and Run App
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => CourseProvider(courseRepository)),
        ChangeNotifierProvider(create: (_) => AssignmentProvider(assignmentRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Moodle Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}