import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/auth_provider.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    final bool isDashboard = currentRoute == '/dashboard';
    final bool isCourses = currentRoute == '/courses';
    final bool isAssessments = currentRoute == '/assessments';
    final bool isCalendar = currentRoute == '/calendar';
    final bool isNotifications = currentRoute == '/notifications';
    final bool isProfile = currentRoute == '/profile';

    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Drawer(
      backgroundColor: moodlePurple,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(
                color: moodleDarkPurple,
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: moodleWhite,
                      child: Icon(
                        Icons.person,
                        size: 28,
                        color: moodlePurple,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      user?.name ?? "Fardeen Shaikh",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: moodleWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    Text(
                      "UP ID : up2199439",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),

                    Text(
                      user?.email ?? "up2199439@myport.ac.uk",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Dashboard
            ListTile(
              leading: const Icon(
                Icons.speed_outlined,
                color: moodleWhite,
              ),
              title: const Text(
                'Dashboard',
                style: TextStyle(
                  color: moodleWhite,
                  fontSize: 16,
                ),
              ),
              selected: isDashboard,
              selectedTileColor: Colors.white24,
              onTap: () {
                Navigator.pop(context);
                if (!isDashboard) {
                  context.go('/dashboard');
                }
              },
            ),

            // Calendar
            ListTile(
              leading: const Icon(
                Icons.calendar_month_outlined,
                color: moodleWhite,
              ),
              title: const Text(
                'Calendar',
                style: TextStyle(
                  color: moodleWhite,
                  fontSize: 16,
                ),
              ),
              selected: isCalendar,
              selectedTileColor: Colors.white24,
              onTap: () {
                Navigator.pop(context);
                if (!isCalendar) {
                  context.go('/calendar');
                }
              },
            ),

            // My Courses
            ListTile(
              leading: const Icon(
                Icons.school_outlined,
                color: moodleWhite,
              ),
              title: const Text(
                'My courses',
                style: TextStyle(
                  color: moodleWhite,
                  fontSize: 16,
                ),
              ),
              selected: isCourses,
              selectedTileColor: Colors.white24,
              onTap: () {
                Navigator.pop(context);
                if (!isCourses) {
                  context.go('/courses');
                }
              },
            ),

            // Assessments
            ListTile(
              leading: const Icon(
                Icons.assignment_outlined,
                color: moodleWhite,
              ),
              title: const Text(
                'Assessments',
                style: TextStyle(
                  color: moodleWhite,
                  fontSize: 16,
                ),
              ),
              selected: isAssessments,
              selectedTileColor: Colors.white24,
              onTap: () {
                Navigator.pop(context);
                if (!isAssessments) {
                  context.go('/assessments');
                }
              },
            ),

            // Notifications
            ListTile(
              leading: const Icon(
                Icons.notifications_none_outlined,
                color: moodleWhite,
              ),
              title: const Text(
                'Notifications',
                style: TextStyle(
                  color: moodleWhite,
                  fontSize: 16,
                ),
              ),
              selected: isNotifications,
              selectedTileColor: Colors.white24,
              onTap: () {
                Navigator.pop(context);
                if (!isNotifications) {
                  context.go('/notifications');
                }
              },
            ),

            // Profile
            ListTile(
              leading: const Icon(
                Icons.person_outline,
                color: moodleWhite,
              ),
              title: const Text(
                'Profile',
                style: TextStyle(
                  color: moodleWhite,
                  fontSize: 16,
                ),
              ),
              selected: isProfile,
              selectedTileColor: Colors.white24,
              onTap: () {
                Navigator.pop(context);
                if (!isProfile) {
                  context.go('/profile');
                }
              },
            ),

            const Divider(color: Colors.white30),

            // Logout
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: moodleWhite,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: moodleWhite,
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);

                await authProvider.logout();

                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}