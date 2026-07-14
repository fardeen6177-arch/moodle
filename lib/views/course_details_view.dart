import 'package:flutter/material.dart';
import 'package:moodle/constants.dart';
import 'package:moodle/widgets/moodle_scaffold.dart';

class CourseDetailsView extends StatelessWidget {
  const CourseDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MoodleScaffold(
      title: 'Course details',
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/notifications'),
        ),
        const SizedBox(width: 8),
      ],
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'USER EXPERIENCE DESIGN AND IMPLEMENTATION',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: moodlePurple,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'M30235 • FHEQ 5',
            style: TextStyle(color: moodleTextMuted),
          ),
          SizedBox(height: 24),
          Card(
            color: moodleWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: moodleBorder),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'This page shows a simplified weekly outline for the current module. Each section can be expanded into resources, notes, and assessment hints.',
                style: TextStyle(color: moodleTextDark),
              ),
            ),
          ),
          SizedBox(height: 16),
          _ExpandableWeekCard(
            title: 'Week 1',
            details: 'Introduction, coursework brief, and module expectations.',
            resources: [
              'Coursework brief PDF',
              'Moodle overview and assessment notes',
              'Starter wireframe examples',
            ],
          ),
          _ExpandableWeekCard(
            title: 'Week 2',
            details: 'Planning, sketches, and responsive layout decisions.',
            resources: [
              'User flow sketches',
              'Responsive layout checklist',
              'Accessibility reminders',
            ],
          ),
          _ExpandableWeekCard(
            title: 'Week 3',
            details: 'Navigation, state management, and assessment updates.',
            resources: [
              'Navigation map',
              'State management summary',
              'Assessment submission reminder',
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpandableWeekCard extends StatelessWidget {
  const _ExpandableWeekCard({
    required this.title,
    required this.details,
    required this.resources,
  });

  final String title;
  final String details;
  final List<String> resources;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: moodleWhite,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: moodleBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        iconColor: moodlePurple,
        collapsedIconColor: moodlePurple,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: moodlePurple,
          ),
        ),
        subtitle: Text(details),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Resources',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: moodleTextDark,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...resources.map(
            (resource) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.link, size: 18, color: moodlePurple),
                  const SizedBox(width: 8),
                  Expanded(child: Text(resource)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
