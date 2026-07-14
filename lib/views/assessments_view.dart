import 'package:flutter/material.dart';
import 'package:moodle/constants.dart';
import 'package:moodle/widgets/moodle_scaffold.dart';

class AssessmentsView extends StatelessWidget {
  const AssessmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    const assessments = [
      {
        'title': 'Referral / Deferral Re-assessment',
        'status': 'Open',
        'date': '29 Jul 2026',
      },
      {
        'title': 'Coursework brief review',
        'status': 'In progress',
        'date': '03 Aug 2026',
      },
      {
        'title': 'Demo preparation',
        'status': 'Pending',
        'date': '05 Aug 2026',
      },
    ];

    return MoodleScaffold(
      title: 'Assessments',
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
            'Assessment list',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: moodlePurple,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Track your current submission status and key dates.',
            style: TextStyle(color: moodleTextMuted),
          ),
          const SizedBox(height: 16),
          ...assessments.map(
            (assessment) => Card(
              color: moodleWhite,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: moodleBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading:
                    const Icon(Icons.assignment_outlined, color: moodlePurple),
                title: Text(assessment['title'] ?? ''),
                subtitle: Text('Status: ${assessment['status'] ?? ''}'),
                trailing: Text(assessment['date'] ?? ''),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
