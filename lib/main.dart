import 'package:flutter/material.dart';
import 'package:moodle/views/dashboard_view.dart';
import 'package:moodle/views/courses_view.dart';
import 'package:moodle/views/course_details_view.dart';
import 'package:moodle/views/profile_view.dart';
import 'package:moodle/views/calendar_view.dart';
import 'package:moodle/views/assessments_view.dart';
import 'package:moodle/views/notifications_view.dart';
import 'package:moodle/views/login_view.dart';
import 'package:moodle/constants.dart';

void main() {
  runApp(const MoodleApp());
}

class MoodleApp extends StatelessWidget {
  const MoodleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moodle',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: moodlePurple,
          primary: moodlePurple,
          secondary: moodleSecondary,
          surface: moodleSurface,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardView(),
        '/courses': (context) => const CoursesView(),
        '/course-details': (context) => const CourseDetailsView(),
        '/profile': (context) => const ProfileView(),
        '/calendar': (context) => const CalendarView(),
        '/assessments': (context) => const AssessmentsView(),
        '/notifications': (context) => const NotificationsView(),
        '/login': (context) => const LoginView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
