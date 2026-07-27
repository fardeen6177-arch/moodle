import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:module_clone/constants.dart';
import '../providers/auth_provider.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    bool isSelected(String route) {
      return currentRoute == route;
    }

    void goTo(String route) {
      Navigator.pop(context);

      if (currentRoute != route) {
        context.go(route);
      }
    }

    return Drawer(
      backgroundColor: moodlePurple,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: moodleDarkPurple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: moodleWhite,
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: moodlePurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.name ?? "Student",
                    style: const TextStyle(
                      color: moodleWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    user?.email ?? "",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(
                Icons.dashboard_outlined,
                color: moodleWhite,
              ),
              title: const Text(
                'Dashboard',
                style: TextStyle(color: moodleWhite),
              ),
              selected: isSelected('/dashboard'),
              selectedTileColor: Colors.white24,
              onTap: () => goTo('/dashboard'),
            ),

            ListTile(
              leading: const Icon(
                Icons.school_outlined,
                color: moodleWhite,
              ),
              title: const Text(
                'My Courses',
                style: TextStyle(color: moodleWhite),
              ),
              selected: isSelected('/courses'),
              selectedTileColor: Colors.white24,
              onTap: () => goTo('/courses'),
            ),

            ListTile(
              leading: const Icon(
                Icons.assignment_outlined,
                color: moodleWhite,
              ),
              title: const Text(
                'Assessments',
                style: TextStyle(color: moodleWhite),
              ),
              selected: isSelected('/assessments'),
              selectedTileColor: Colors.white24,
              onTap: () => goTo('/assessments'),
            ),

            ListTile(
              leading: const Icon(
                Icons.calendar_month_outlined,
                color: moodleWhite,
              ),
              title: const Text(
                'Calendar',
                style: TextStyle(color: moodleWhite),
              ),
              selected: isSelected('/calendar'),
              selectedTileColor: Colors.white24,
              onTap: () => goTo('/calendar'),
            ),

            ListTile(
              leading: const Icon(
                Icons.notifications_none_outlined,
                color: moodleWhite,
              ),
              title: const Text(
                'Notifications',
                style: TextStyle(color: moodleWhite),
              ),
              selected: isSelected('/notifications'),
              selectedTileColor: Colors.white24,
              onTap: () => goTo('/notifications'),
            ),

            ListTile(
              leading: const Icon(
                Icons.person_outline,
                color: moodleWhite,
              ),
              title: const Text(
                'Profile',
                style: TextStyle(color: moodleWhite),
              ),
              selected: isSelected('/profile'),
              selectedTileColor: Colors.white24,
              onTap: () => goTo('/profile'),
            ),

            const Divider(color: Colors.white30),

            ListTile(
              leading: const Icon(
                Icons.logout,
                color: moodleWhite,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: moodleWhite),
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