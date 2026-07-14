import 'package:flutter/material.dart';
import 'package:moodle/constants.dart';
import 'package:moodle/widgets/moodle_scaffold.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    const events = [
      {
        'date': '29 Jul 2026',
        'title': 'Submission deadline',
        'subtitle': 'Coursework repository link due',
      },
      {
        'date': '03 Aug 2026',
        'title': 'Demo booking closes',
        'subtitle': 'Final demo slots should be booked',
      },
      {
        'date': '05 Aug 2026',
        'title': 'Project review',
        'subtitle': 'Prepare for the live assessment demo',
      },
    ];

    return MoodleScaffold(
      title: 'Calendar',
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/notifications'),
        ),
        const SizedBox(width: 8),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Upcoming deadlines',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: moodlePurple,
            ),
          ),
          const SizedBox(height: 24),
          ...events.map(
            (event) => Card(
              color: moodleWhite,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: moodleBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.event_outlined, color: moodlePurple),
                title: Text(event['title'] ?? ''),
                subtitle: Text(
                  '${event['date'] ?? ''} • ${event['subtitle'] ?? ''}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
