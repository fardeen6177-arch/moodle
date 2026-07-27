import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/mock_data.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Pull the current user from our mock data
    final user = MockData.currentUser;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            accountName: Text(
              user.name, 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
            ),
            accountEmail: Text(
              user.email,
              style: const TextStyle(color: Colors.white70)
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user.name.isNotEmpty ? user.name.substring(0, 1).toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: 24.0, 
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context); // Close the drawer first
              context.go('/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Courses'),
            onTap: () {
              Navigator.pop(context);
              context.go('/courses');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('Calendar'),
            onTap: () {
              Navigator.pop(context);
              context.go('/calendar');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Assessments'),
            onTap: () {
              Navigator.pop(context);
              context.go('/assessments');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              context.go('/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context);
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}