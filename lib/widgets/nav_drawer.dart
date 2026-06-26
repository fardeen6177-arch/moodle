import 'package:flutter/material.dart';
import 'package:moodle/constants.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    final bool isDashboard = currentRoute == '/';
    final bool isCourses = currentRoute == '/courses';

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
              onTap: () {
                Navigator.pop(context);
                if (!isDashboard) {
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.calendar_month_outlined, color: moodleWhite),
              title: const Text(
                'Calendar',
                style: TextStyle(color: moodleWhite, fontSize: 16),
              ),
              onTap: () {
                // placeholder
              },
            ),
            ListTile(
              leading: const Icon(Icons.school_outlined, color: moodleWhite),
              title: const Text(
                'My courses',
                style: TextStyle(color: moodleWhite, fontSize: 16),
              ),
              selected: isCourses,
              selectedTileColor: Colors.white24,
              onTap: () {
                Navigator.pop(context);
                if (!isCourses) {
                  Navigator.pushReplacementNamed(context, '/courses');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
