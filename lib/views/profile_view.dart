import 'package:flutter/material.dart';
import 'package:moodle/constants.dart';
import 'package:moodle/widgets/moodle_scaffold.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return MoodleScaffold(
      title: 'Profile',
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
            'Student profile',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: moodlePurple,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: moodleWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: moodleBorder),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: moodlePurple,
                    child: Text(
                      'FS',
                      style: TextStyle(
                        color: moodleWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Fardeen Shaikh',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('UP ID: up2199439'),
                  SizedBox(height: 8),
                  Text('Course: USER EXPERIENCE DESIGN AND IMPLEMENTATION'),
                  SizedBox(height: 8),
                  Text('Email: up2199439@myport.ac.uk'),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _ProfileChip(label: 'Referral / Deferral'),
                      _ProfileChip(label: 'Mobile-first UI'),
                      _ProfileChip(label: 'Flutter'),
                      _ProfileChip(label: 'GitHub Fork'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                child: _SummaryCard(title: 'Attendance', value: '96%'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(title: 'Modules', value: '4'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileChip extends StatelessWidget {
  const _ProfileChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: moodleGrayBg,
      labelStyle: const TextStyle(color: moodleTextDark),
      side: const BorderSide(color: moodleBorder),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: moodleWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: moodleBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: moodleTextMuted)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: moodlePurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
