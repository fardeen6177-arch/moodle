import 'package:flutter/material.dart';
import 'package:moodle/constants.dart';
import 'package:moodle/widgets/moodle_scaffold.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    const notifications = [
      'New coursework brief is available.',
      'Demo booking deadline is approaching.',
      'Your profile information was updated.',
    ];

    return MoodleScaffold(
      title: 'Notifications',
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () => Navigator.pushReplacementNamed(context, '/profile'),
        ),
        const SizedBox(width: 8),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Announcements',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: moodlePurple,
            ),
          ),
          const SizedBox(height: 24),
          const Card(
            color: moodleWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: moodleBorder),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'You have 3 unread announcements and 2 upcoming reminders.',
                style: TextStyle(color: moodleTextDark),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...notifications.map(
            (notification) => Card(
              color: moodleWhite,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: moodleBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.notifications_active_outlined,
                    color: moodlePurple),
                title: Text(notification),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
