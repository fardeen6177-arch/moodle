import 'package:flutter/material.dart';
import 'package:moodle/constants.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    final bool isDashboard = currentRoute == '/';
    final bool isCourses = currentRoute == '/courses';
    final bool isCourseDetails = currentRoute == '/course-details';
    final bool isProfile = currentRoute == '/profile';
    final bool isCalendar = currentRoute == '/calendar';
    final bool isAssessments = currentRoute == '/assessments';
    final bool isNotifications = currentRoute == '/notifications';
    final bool isLogin = currentRoute == '/login';

    void goTo(String route) {
      Navigator.pop(context);
      if (currentRoute != route) {
        Navigator.pushReplacementNamed(context, route);
      }
    }

    return Drawer(
      backgroundColor: moodlePurple,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: moodleDarkPurple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: moodleWhite,
                    child: Icon(Icons.person, size: 30, color: moodlePurple),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Fardeen Shaikh',
                    style: TextStyle(
                      color: moodleWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'up2199439@myport.ac.uk',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.speed_outlined, color: moodleWhite),
              title: const Text(
                'Dashboard',
                style: TextStyle(color: moodleWhite, fontSize: 16),
              ),
              selected: isDashboard,
              selectedTileColor: Colors.white24,
              onTap: () => goTo('/'),
            ),
            ListTile(
              leading:
                  const Icon(Icons.calendar_month_outlined, color: moodleWhite),
              title: const Text(
                'Calendar',
                style: TextStyle(color: moodleWhite, fontSize: 16),
              ),
              selected: isCalendar,
              selectedTileColor: Colors.white24,
              onTap: () => goTo('/calendar'),
            ),
            ListTile(
              leading: const Icon(Icons.school_outlined, color: moodleWhite),
              title: const Text(
                'My courses',
                style: TextStyle(color: moodleWhite, fontSize: 16),
              ),
              selected: isCourses,
              selectedTileColor: Colors.white24,
              onTap: () => goTo('/courses'),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book_outlined, color: moodleWhite),
              title: const Text(
                'Course details',
                style: TextStyle(color: moodleWhite, fontSize: 16),
              ),
              selected: isCourseDetails,
              selectedTileColor: Colors.white24,
              onTap: () => goTo('/course-details'),
            ),
            ListTile(
              leading:
                  const Icon(Icons.assignment_outlined, color: moodleWhite),
              title: const Text(
                'Assessments',
                style: TextStyle(color: moodleWhite, fontSize: 16),
              ),
              selected: isAssessments,
              selectedTileColor: Colors.white24,
              onTap: () => goTo('/assessments'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications_none_outlined,
                  color: moodleWhite),
              title: const Text(
                'Notifications',
                style: TextStyle(color: moodleWhite, fontSize: 16),
              ),
              selected: isNotifications,
              selectedTileColor: Colors.white24,
              onTap: () => goTo('/notifications'),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: moodleWhite),
              title: const Text(
                'Profile',
                style: TextStyle(color: moodleWhite, fontSize: 16),
              ),
              selected: isProfile,
              selectedTileColor: Colors.white24,
              onTap: () => goTo('/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.login, color: moodleWhite),
              title: const Text(
                'Login',
                style: TextStyle(color: moodleWhite, fontSize: 16),
              ),
              selected: isLogin,
              selectedTileColor: Colors.white24,
              onTap: () => goTo('/login'),
            ),
          ],
        ),
      ),
    );
  }
}
