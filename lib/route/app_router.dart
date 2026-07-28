import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/courses/courses_list_screen.dart';
import '../screens/courses/course_detail_screen.dart';
import '../screens/assesments/assessments_view.dart';
import '../screens/assesments/assignment_submission_screen.dart';
import '../screens/calendar/calendar_view.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/notifications_view.dart';
import '../widgets/nav_drawer.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

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
  );
}

/// Temporary placeholder screen
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'm',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 12),
          Icon(Icons.notifications_none),
          SizedBox(width: 12),
          Icon(Icons.chat_bubble_outline),
          SizedBox(width: 12),
          CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFFE0E0E0),
            child: Text(
              'YH',
              style: TextStyle(fontSize: 10, color: Colors.black),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
